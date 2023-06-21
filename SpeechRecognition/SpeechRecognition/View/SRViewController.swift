//
//  SRViewController.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/06/21.
//

import UIKit

class SRViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SRViewController {
    func setupStatusBar() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.setupStatusBar()
        }
    }
    
    func showAlert(withTitle title: String, message: String,_ buttonText: String = "OK") {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: buttonText, style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    func presentingView(vc: UIViewController) {
        let vc = vc
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func changingRootView(vc: UIViewController, time: Int) {
        let time = time
        
        let DelayTime = DispatchTimeInterval.seconds(time)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+DelayTime) {
                sceneDelegate.changeRootVC(vc, animated: true)
            }
        }
    }
}

