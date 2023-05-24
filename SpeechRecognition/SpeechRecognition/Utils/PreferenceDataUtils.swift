//
//  PreferenceDataUtils.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/22.
//

import Foundation

enum PreferenceDataUtils {
    static public func setData(value: Data, key: Consts.Places) {
        guard let key = Consts.saveKey[key] else {
            print("key is Invaild")
            return
        }
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static public func getData(key: Consts.Places,_ defaultValue: Data? = nil) -> Data? {
        guard let key = Consts.saveKey[key] else {
            print("key is Invaild")
            return nil
        }
        let saved = UserDefaults.standard.value(forKey: key) as? Data
        return saved ?? defaultValue
    }
    
    static public func removeObject(key: Consts.Places){
        guard let key = Consts.saveKey[key] else {
            print("key is Invaild")
            return
        }
        UserDefaults.standard.removeObject(forKey: key)
    }
}
