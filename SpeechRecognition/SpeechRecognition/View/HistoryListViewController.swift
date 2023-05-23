//
//  historyListViewController.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/22.
//

import UIKit

class HistoryListViewController: UIViewController {
    
    var messages: [Message] = {
        if let data = PreferenceDataUtils.getData(key: Consts.SaveKey.messages.rawValue),
           let messages = try? JSONDecoder().decode(Messages.self, from: data) {
            return messages.messages
        }
        
        return []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        fetchData().forEach{
            print("\($0.role): \($0.content)")
        }
        
    }
    
    func fetchData() -> [Message] {
        return messages
    }
}
