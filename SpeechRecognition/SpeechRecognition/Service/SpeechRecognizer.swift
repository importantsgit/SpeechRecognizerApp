//
//  SpeechRecognizer.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/16.
//

import Foundation
import AVFoundation
import Speech

// 동시성 프로그래밍에서 가장 주의해야할 것인 Deadlock, race condition을 해결하기 위한 자료형 Actor
// reference type이고 actor는 한 번에 하나의 작업만 액터의 상태를 변경할 수 있는 형태
// race condition: 두 개 이상의 프로세스가 공통 자원을 병행적으로(concurrently) 읽거나 쓰는 동작을 할 때, 공용 데이터에 대한 접근이 어떤 순서에 따라 이루어졌는지에 따라 그 실행 결과가 같지 않고 달라지는 상태
actor SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        // 음싱 인식 중 발생할 수 있는 오류를 정의하는 열거형
        case nilRecognizer
        case notAuthorzedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        // 각 오류에 대한 메세지 속성
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorzedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    // 항상 main에서 동작하는 actor를 의미
    @MainActor var transcript: String = "hello?"
    
    private var audioEngine: AVAudioEngine?
    // 수순 소리만을 인식하는 오디오 엔진 객체
    private var request: SFSpeechAudioBufferRecognitionRequest?
    // 음성인식요청 처리 - 사용자가 말하면, recognitionRequest에서 음성인식 프로세스를 진행할 수 있음
    private var task: SFSpeechRecognitionTask?
    // 인식 요청 결과 제공 - 중간에 인식 취소하거나 중지 할 수 있게 함 (staring, completed ...)
    private var recognizer: SFSpeechRecognizer?
    // 음성을 텍스트로 변화하는데 사용되는 주요 객체
    
    init() {
        recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-KR"))
        guard recognizer != nil else {
            self.transcribe(RecognizerError.nilRecognizer)
            return
        }
        print("recognizer ready")
        checkAuthorization()
    }
    
    // nonisolated 읽기만 가능한 actor는 race codition이 발생하지 않는 것을 보장하므로, 메소드 앞에 nonisolated를 붙여서 사용하는 쪽에서 Task, await 키워드 없이 접근이 가능하게 제공
    nonisolated private func checkAuthorization() {
        // async 작업의 단위
        // DispatchQueue, Thread 따로 없이 작성하면 main thread sync로 동작
        // 이때 Task 블록 감싸서 snync 수행할 수 있도록 제공
        // 만약 Task 블록 없이 async 함수 호출하려면 async 함수 호출하는 쪽도 async여야 가능
        Task {
            do {
                // await: 다음 라인의 코드 실행시키지 않고 대기
                // 콜백 지옥 벗어날 수 있음
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorzedToRecognize
                }
                
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                transcribe(error)
            }
        }
    }
    
    // 특정 메소드만 메인 스레드에서 항상 실행되어야 하는 경우 @MainActor 키워드 사용
    @MainActor func startTranscribing() {
        // Concurrency한 환경(병렬)을 바다로 비유
        // Task를 배로 표현
        // - 순차적 (Sequential)
        // - 비동기적 (Asynchronous)
        // - 독립적 (Self-contained)
        // - Task들은 서로 아무런 영향을 주지 않기 때문에 이론적으로 Race Condition에서 안전
        Task {
            await transcribe()
        }
    }
    
    @MainActor func resetTranscript() {
        Task {
            await reset()
        }
    }
    
    @MainActor func stopTranscribing() {
        Task {
            await reset()
        }
    }
    
    private func transcribe() {
        guard let recognizer = recognizer, recognizer.isAvailable else {
            self.transcribe(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try Self.prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            self.task = recognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
            })
        } catch {
            self.reset()
            self.transcribe(error)
        }
    }
    
    private func reset() {
        task?.cancel()
        // 인식 요청 결과 취소
        audioEngine?.stop()
        // 오디오 입력 중단
        audioEngine?.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        // 각 발화(사용자가 말한 음성) (최종이 아닌)부분 결과가 보고됨
        
        // 오디오 녹음을 준비 할 AVAudioSession을 만들기
        // audioEngine (장치)에 녹음 할 오디오 입력이 있는지 확인.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    // 음성 인식 작업의 결과를 처리하는 핸들러
    // 최종 결과가 수신되거나 오류가 발생하면 오디오 엔진 중지하고 변환 작업을 종료
    nonisolated private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?){
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        if let result {
            self.transcribe(result.bestTranscription.formattedString)
        }
    }
    
    // 유저가 말한 내용 기록
    nonisolated private func transcribe(_ message: String) {
        Task { @MainActor in
            transcript = message
        }
    }
    
    // 오류 발생시 error 기록
    nonisolated private func transcribe(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        Task{ @MainActor [errorMessage] in
            self.transcript = "<< \(errorMessage) >>"
        }
    }
}


// 권한 확인
extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        return await withCheckedContinuation{ continuation in
            self.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        return await withCheckedContinuation({ continuation in
            self.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        })
    }
}
