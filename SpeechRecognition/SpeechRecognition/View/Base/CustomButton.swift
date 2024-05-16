//
//  UIButton.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/23.
//
import UIKit

class OBButton: UIButton {
    var buttonFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    var baseColor = UIColor(hex: "#FF3B30")
    var radius: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OBButton {
    func setConfigration(_ text: String,_ font: UIFont?) {
        if let font = font {
            self.buttonFont = font
        }
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.attributedTitle = AttributedString(text, attributes: AttributeContainer([NSAttributedString.Key.font: self.buttonFont]))
            config.baseForegroundColor = .white
            config.baseBackgroundColor = MyColor.accentColor
            config.cornerStyle = .capsule
            self.configuration = config
            
        } else {
            self.setTitle(text, for: .normal)
            self.setTitle(text, for: .selected)
            self.setTitle(text, for: .disabled)
            self.titleLabel?.font = self.buttonFont
        }
    }
    
    enum PopupButtonType {
        case dismiss
        case active
    }
    
    func setPopupConfigration(_ text: String,_ font: UIFont?, type: PopupButtonType) {
        if let font = font {
            self.buttonFont = font
        }
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            
            if type == .dismiss {
                config = UIButton.Configuration.bordered()
                config.baseForegroundColor = MyColor.decsriptionColor.decsription1
            } else {
                config.baseForegroundColor = .white
                config.baseBackgroundColor = MyColor.accentColor
            }
            
            config.attributedTitle = AttributedString(text, attributes: AttributeContainer([NSAttributedString.Key.font: self.buttonFont]))
            config.cornerStyle = .medium
            self.configuration = config
            
        } else {
            self.setTitle(text, for: .normal)
            self.setTitle(text, for: .selected)
            self.setTitle(text, for: .disabled)
            self.titleLabel?.font = self.buttonFont
        }
    }
}
