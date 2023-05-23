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
    private let TTS = TTSManager()
    
    init(api: ChatGPTAPI) {
        self.api = api
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
        
        TTS.play(streamText)
        return streamText
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
