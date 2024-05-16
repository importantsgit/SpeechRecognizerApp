//
//  TTSTest.swift
//  TTSTest
//
//  Created by Importants on 5/17/24.
//

import XCTest
@testable import SpeechRecognition

final class TTSTest: XCTestCase {
    var textSpeaker: TextSpeaker!

    override func setUpWithError() throws {
        let utterance: CustomUtterance = .init(
            rate: 1.0,
            pitchMultiplier: 1.0,
            postUtteranceDelay: 1.0,
            volume: 1.0,
            voice: .Eddy
        )
        textSpeaker = TextSpeaker(utterance: utterance)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        textSpeaker = nil
        try super.tearDownWithError()
    }
    
    func testTTS() throws {
        Task {
            await textSpeaker.play("hello?")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
