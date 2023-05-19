//
//  ChatGPTAPI.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/19.
//

import Foundation

final class ChatGPTAPI: @unchecked Sendable {
    // Sendable
    // 주어진 타입의 값이 concurrent code에서 안전하게 사용될 수 있음을 알려주는 프로토콜
    // 복사를 통해서 동시성 도메인 간에 안전하게 값을 전달할 수 있는 타입 (안전한 타입)
    // 동시에 사용하기 안전한 타입 / Actor 간에 값을 공유할 수 있는 타입
    // 참조를 하면 Race Condition에 노출될 수 있음
    // 만족시키기 위해서 final Class이어야 하고
    // 변경 불가능한 저장소(immutable Storage)만 포함해야 함
    // Value type내의 모든 stored property가 모두 Sendable 타입인 경우에만 Sendable
    // actor 올 수 있음 / let만 올 수 있음 / var 오지 못함
    
    // @unchecked 특정 타입이 추가적인 체크 없이 동시성 경계를 통과할 수있는 것으로 간주
    
    private let systemMessage: Message
    private let temperature: Double
    // 높을수록 더 다양하고 무작위해짐
    private let model: String
    
    private let apiKey: String
    private var historyList = [Message]()
    private let urlSession = URLSession.shared
    private var urlRequest: URLRequest {
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        headers.forEach{
            urlRequest.setValue($1, forHTTPHeaderField: $0)
        }
        return urlRequest
    }
    
    let dateFomatter: DateFormatter = {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "YYYY-MM-dd"
        dateFomatter.locale = Locale.init(identifier: "kr-KR")
        
        return dateFomatter
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    
        return jsonDecoder
    }()
    
    private var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }
    
    init(apiKey: String, model: String = "gpt-3.5-turbo", systemPrompt: String = "You are a BBF that reluctantly answers questions with warm responses", temperature: Double = 0.5) {
        self.apiKey = apiKey
        self.model = model
        self.systemMessage = .init(role: "BBF", content: systemPrompt)
        // systemPrompt: 역할 지정
        self.temperature = temperature

    }
    
    // 메세지 관리
    private func generateMessages(from text: String) -> [Message] {
        var messages = [systemMessage] + historyList + [Message(role: "user", content: text)]
        
        // 만약 4000*4 메세지 초과면 삭제
        if messages.contentCount > (4000 * 4) {
            _ = historyList.removeFirst()
            messages = generateMessages(from: text)
        }
        return messages
    }
    
    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let request = Request(model: model, temperature: temperature, messages: generateMessages(from: text), stream: stream)
        // stream이 false면 한번의 응답 반환하고 연결이 끊어지지만/true면 연결 유지된 상태에서 계속 요청과 응답을 주고 받을 수 있음
        return try JSONEncoder().encode(request)
    }
    
    // 유저와 AI가 대화한 내용 저장
    private func appendToHistoryList(userText: String, responseText: String){
        self.historyList.append(.init(role: "user", content: userText))
        self.historyList.append(.init(role: "assistant", content: responseText))
    }
    
    // post하기 (비동기)
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)
        
        let (result, response) = try await urlSession.bytes(for: urlRequest)
        // HTTP 요청을 비동기적으로 수행
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            // ~=: 범위에 속하는 지
            var errorText = ""
            for try await line in result.lines {
                // 데이터에서 한 줄씩 읽을 수 있는 비동기 스트림
                // 비동기적으로 데이터 반환
                errorText += line
            }
            
            if let data = errorText.data(using: .utf8), let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                errorText = "\n \(errorResponse.message)"
            }
            
            throw "Bad Response: \(httpResponse.statusCode), \(errorText)"
        }

        // AsyncStream
        // 순서가 있고, 비동기적으로 생성된 요소들의 sequence
        
        // 비동기적으로 스트림을 생성하는데 사용되며, 메시지 스트림을 통해 여러 응답을 전송할 수 있음
        // 순서가 있고, 비동기적으로 생성된 요소들의 Sequence
        // 클로저 내부에서 하고 싶은 일을 정의
        // 기존 Sequence를 생성하려면 IteratorProtocol(반복자)를 직접 구현해서 만들어 줘야 했지만,
        // AsyncStream은 AstncSequence를 준수 Iterator를 직접 구현할 필요 없이 간편하게 사용 가능
        
        // 이 함수를 통해, 반환된 스트림을 사용하여 비동기적으로 전달되는 응답을 처리할 수 있음
        return AsyncThrowingStream<String, Error> { continuation in
            Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    var responseText = ""
                    for try await line in result.lines {
                        if line.hasPrefix("data: "), // 접두어 확인
                           let data = line.dropFirst(6).data(using: .utf8), // 접두어 빼고 나머지
                           let response = try? self.jsonDecoder.decode(StreamCompletionResponse.self, from: data),
                           let text = response.choices.first?.delta.content {
                            responseText += text
                            continuation.yield(text)
                            // text를 스트림에 전달
                            // 이로써 외부로부터 비동기적으로 응답 데이터를 전송할 수 있게 됨
                        }
                    }
                    self.appendToHistoryList(userText: text, responseText: responseText)
                    continuation.finish()
                    // 스트림 완료
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    func sendMessage(_ text: String) async throws -> String {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text, stream: false)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            var error = "Bad Response: \(httpResponse.statusCode)"
            if let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                error.append("\n\(errorResponse.message)")
            }
            throw error
        }
        
        do {
            let completionResponse = try self.jsonDecoder.decode(CompletionResponse.self, from: data)
            let responseText = completionResponse.choices.first?.message.content ?? ""
            self.appendToHistoryList(userText: text, responseText: responseText)
            return responseText
        } catch {
            throw error
        }
    }
    
    func deleteHistoryList() {
        self.historyList.removeAll()
    }
}

extension String: CustomNSError {
    public var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: self]
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

extension Array where Element == Message {
    
    var contentCount: Int { reduce(0, { $0 + $1.content.count })}
}


