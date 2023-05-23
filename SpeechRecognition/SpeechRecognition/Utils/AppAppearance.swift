//
//  AppAppearance.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/22.
//

import UIKit

final class AppApperance {
    static func setupNavigationBarApperance() {
        
        // MARK: - NavigationBar
        
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            // background와 shadow를 테마에 적절한 Color로 reset해줌
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = colorToImage(.systemMint)
            appearance.shadowColor = UIColor.clear
            
            // 바 텍스트 색상
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemMint]
            UINavigationBar.appearance().tintColor = .white
            // 바 색상
            appearance.backgroundColor = .systemMint
            
            // 적용
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
 

        } else {
            //TODO: iOS 이전 버전 작성
        }

    }
    
    static func setupTabBarApperance() {
        
        // MARK: - UITabBar
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().backgroundColor = .gray
    }
    
    
    static func colorToImage(_ color: UIColor) -> UIImage {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let screenwidth = windowScene?.windows.first?.frame.width ?? 300
        let size: CGSize = CGSize(width: screenwidth, height: 2)
        let image: UIImage = UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image.alpha(0.5)
    }
}


