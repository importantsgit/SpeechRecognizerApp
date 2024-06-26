//
//  ViewModel.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/19.
//

import Foundation
import AVKit

class ViewModel: ObservableObject {
    
    private let api: ChatGPTAPI
    private let textSpeaker: TextSpeaker
    
    init(api: ChatGPTAPI, textSpeaker: TextSpeaker = .init()) {
        self.api = api
        self.textSpeaker = textSpeaker
    }
    
    @MainActor func send(text: String) async -> String {
        var streamText = ""
        
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
            }
        }
        catch {
            streamText = error.localizedDescription
            print(streamText)
            return ""
        }
        
        do {
            try await textSpeaker.play(streamText)
        }
        catch {
            print("textSpeaker Error: \(error.localizedDescription)")
        }
        
        return streamText
    }
    
    func getMessages() -> [Message] {
        api.getMessages()
    }
    
    func deleteMessages() {
        api.deleteMessages()
    }
    
    func getLastMessage() -> Message? {
        api.getLastMessage()
    }
    
}

struct AttributedOutput {
    let string: String
    let results: [ParserResult]
}

struct ParserResult: Identifiable {
    
    let id = UUID()
    let attributedString: AttributedString
    let isCodeBlock: Bool
    let codeBlockLanguage: String?
    
}
