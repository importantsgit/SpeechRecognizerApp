//
//  SceneDelegate.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let vc = LaunchViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.backgroundColor = .systemMint
        window?.makeKeyAndVisible()
    }
    
    func setupStatusBar() {
        let window = self.window
        let statusBarManager = window?.windowScene?.statusBarManager
        let barView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
        barView.backgroundColor = .systemMint
        window?.addSubview(barView)
    }
    
    func changeRootVC(_ vc: UIViewController, animated: Bool){
        guard let window = self.window else {return}
        window.rootViewController = vc
        
        if animated {
            UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil)
        }
    }
}

