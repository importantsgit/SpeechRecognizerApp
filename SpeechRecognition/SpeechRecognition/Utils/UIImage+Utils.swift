//
//  UIImage+Utils.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/22.
//

import UIKit

extension UIImage {
    // 투명도
    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
