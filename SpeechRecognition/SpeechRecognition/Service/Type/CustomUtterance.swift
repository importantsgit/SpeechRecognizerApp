//
//  Utterance.swift
//  SpeechRecognition
//
//  Created by Importants on 5/17/24.
//

import Foundation

struct CustomUtterance {
    var rate: Float
    var pitchMultiplier: Float
    var postUtteranceDelay: Double
    var volume: Float
    var voice: Voice
    
    init(
        rate: Float = 1.0,
        pitchMultiplier: Float = 1.0,
        postUtteranceDelay: Double = 1.0,
        volume: Float = 1.0,
        voice: Voice = .siri_Aaron
    ) {
        self.rate = rate
        self.pitchMultiplier = pitchMultiplier
        self.postUtteranceDelay = postUtteranceDelay
        self.volume = volume
        self.voice = voice
    }
}
