//
//  Consts.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/22.
//

import Foundation

public enum Consts {
    static let IS_DEBUG = true
    
    static let ChatGPTAPIKEY   = "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"
    
    enum PrefKey: String {
        case uuid = "OBJECT_DETECTION_UUID"
    }
    
    enum SaveKey: String {
        case messages = "Messages"
    }
}
