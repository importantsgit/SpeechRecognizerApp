//
//  LaunchViewController.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/06/21.
//

import UIKit
import AVFoundation
import AVFAudio
import Speech

class LaunchViewController: SRViewController {
    var titleLabel = CreateLabel()
        .setupText("Speech\nAnd\nRecognition")
        .setuplabelAlignment(.left)
        .setupTextColor(.white)
        .setupFont(.systemFont(ofSize: 48, weight: .bold))
        .setuplabelNumberOfLines(0)
        .build()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        checkPermissions()
    }
}

extension LaunchViewController {
    private func setupViews() {
        [titleLabel].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32.0)
        ])
    }
    
    func checkPermissions() {
        if SFSpeechRecognizer.authorizationStatus() != .authorized || AVAudioSession.sharedInstance().recordPermission != .granted {
            self.changingRootView(vc: PermissionViewController(), time: 3)
            return
        }
        self.changingRootView(vc: UINavigationController(rootViewController: MainViewController()), time: 3)
    }
}
