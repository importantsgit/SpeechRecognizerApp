//
//  TTSManager.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/17.
//

import Foundation
import AVFAudio

// Text To Speak
actor TextSpeaker: NSObject {

    private let synthesizer = AVSpeechSynthesizer()
    private var utteranceSetting: CustomUtterance!
    
    enum TTSError: Error {
        case TTSUnavailable
        case TextEmpty
        
        var message: String {
            switch self {
            case .TTSUnavailable: return "TTS is unvailable"
            case .TextEmpty: return "Text is not existed"
            }
        }
    }
    
    var stoppedSpeak: ((Bool)->Void)?
    
    init(utterance: CustomUtterance = .init()) {
        super.init()
        synthesizer.delegate = self
        
        Task {
            await self.setUtterance(utterance)
            try await self.prepareAudioSession()
        }
    }
    
    private func setUtterance(_ utterance: CustomUtterance) async {
        self.utteranceSetting = utterance
    }
    
    public func changeUtterance(_ utterance: CustomUtterance) {
        self.utteranceSetting = utterance
    }
    
    func play(_ text: String?) throws {
        guard let text = text else {
            throw TTSError.TextEmpty
        }
       
        let utterance = AVSpeechUtterance(string: text)
        // 음성 합성을 위한 텍스트와 음성에 영향을 미치는 매개변수를 캡슐화하는 개체
        // 여러 utterance로 나누어 다른 말투로 말하게 할 수 있음
        
        utterance.voice = AVSpeechSynthesisVoice(
            identifier: utteranceSetting.voice.rawValue
        )
        //utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        // en-KR 가 아니면 오류 생김
        //AVSpeechSynthesisVoice(language: "en-KR")
        // 음성 합성기가 발화할 때 사용하는 음성
        // 발화: 말하는 행위나 음성을 내는 것
        
        // utterance를 enqueue(queue)하기 전에 이 속성들을 사용해야 함
        
        utterance.rate = utteranceSetting.rate
        // 말하기 속도
        // AVSpeechUtteranceMinimumSpeechRate ~ AVSpeechUtteranceMaximumSpeechRate 범위 내의 소수 값
        // 기본값: AVSpeechUtteranceDefaultSpeechRate
        
        utterance.pitchMultiplier = utteranceSetting.pitchMultiplier
        // 발화할 때 음성 합성기가 사용하는 기준 피치 (음성의 높고 낮음을 결정하는 인식된 주파수)
        // 0.5~2.0 기본값: 1.0
        
        utterance.postUtteranceDelay = utteranceSetting.postUtteranceDelay
        // 여러 utterance가 대기열에 존재할 때, 음성 합성기는 현재 utterance의 postUtteranceDelay와 다음 utterance의 preUtteranceDelay의 합과 동일한 최소 시간만큼 일시적으로 일시정지함
        
        utterance.volume = utteranceSetting.volume
        // 0.0~1.0 기본값: 1.0
        
        synthesizer.stopSpeaking(at: .immediate)

        // 음성이 시작된 후 합성기를 일시 중지하거나 중지할 수 있음
        //synthesizer.pauseSpeaking(at: .immediate)
        // 상태값 확인 가능
        //synthesizer.isPaused / synthesizer.isSpeaking
        
        synthesizer.speak(utterance)
        // 만약 말을 하지 않으면 즉시 말하기 시작하거나 postUtteranceDelay만큼 일시정지 한 후 말하기를 시작
        // 합성기가 말하고 있는 경우, 합성기는 utterance를 대기열에 추가하고 받은 순서대로 말함
    }
    
    func prepareAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playback, mode: .default)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    private func transcribe(_ error: Error) {
        var errorMessage = ""

        if let error = error as? TTSError {
            errorMessage += error.message + "?"
        } else {
            errorMessage += error.localizedDescription + "?"
        }
        print(errorMessage)
    }
}

// 각 의미있는 단위마다 utterance를 생성하여 음성 진행 상황에 대한 알림을 받고 싶으면 delegate 채택

extension TextSpeaker: AVSpeechSynthesizerDelegate {
    private func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) async {
        //
    }
    
    private func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) async {
        //
    }
    
    private func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) async {
        //
    }
    
    private func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) async {
    }
    
    private func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) async {
        //
    }
    
    private func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) async {
        //
    }
    
}

