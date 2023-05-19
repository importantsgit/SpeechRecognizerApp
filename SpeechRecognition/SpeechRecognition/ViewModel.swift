//
//  ViewModel.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/19.
//

import Foundation

class ViewModel: ObservableObject {
    
    private let api: ChatGPTAPI
    
    init(api: ChatGPTAPI) {
        self.api = api
    }
    
    @MainActor func sendAttributed(text: String) async {
        var streamText = ""
        var currentTextCount = 0
        var currentOutput: AttributedOutput?
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
                currentTextCount += text.count
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        if let currentString = currentOutput?.string, currentString != streamText {
            let output = await p
        }
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
