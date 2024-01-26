//
//  Consts.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/24.
//

import Foundation

public enum Consts {
    static let IS_DEBUG = true
    
    static let ChatGPTAPIKEY = "--" // insert your ChatGPT API KEY
    
    enum PrefKey: String {
        case uuid = "OBJECT_DETECTION_UUID"
    }
    
    enum SaveDefaultKey: String {
        case messages = "Messages"
    }
    
    enum Places {
        case hotel
        case airport
        case cafe
        case friend
        case dog
    }
    
    static let saveKey: Dictionary<Places, String> = [
        .hotel: "HOTEL",
        .airport: "AIRPORT",
        .cafe: "CAFE",
        .friend: "FRIEND",
        .dog: "DOG"
    ]
    
    static let role: Dictionary<Places, [String]> = [
        .hotel: ["hotelier", "Jaehun"],
        .friend: ["friend", "Bob"],
        .airport: ["immigrationOfficer", "Tamsjiro"],
        .cafe: ["barista", "Mike"],
        .dog: ["Dog", "Mongmong"]
    ]
}
