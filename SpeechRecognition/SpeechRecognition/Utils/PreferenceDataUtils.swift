//
//  PreferenceDataUtils.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/22.
//

import Foundation

enum PreferenceDataUtils {
    static public func setData(value: Data, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static public func getData(key: String,_ defaultValue: Data? = nil) -> Data? {
        let saved = UserDefaults.standard.value(forKey: key) as? Data
        return saved ?? defaultValue
    }
    
    
    static public func setStringData(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static public func setBooleanData(value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    

    static public func setIntData(value: Int, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static public func getStringData(key: String, defaultValue: String = "") -> String {
        let saved = (UserDefaults.standard.value(forKey: key) as? String)
        return saved ?? defaultValue
    }
    
    static public func getBooleanData(key: String, defaultValue: Bool = false) -> Bool {
        let saved = UserDefaults.standard.value(forKey: key) as? Bool
        return saved ?? defaultValue
    }
    
    static public func getArray(key: String, value: Any = []) -> Any? {
        let saved = UserDefaults.standard.value(forKey: key)
        return saved
    }
    
    static public func getIntData(key: String, defautValue: Int = 0) -> Int {
        let saved = UserDefaults.standard.value(forKey: key) as? Int
        return saved ?? defautValue
    }
}
