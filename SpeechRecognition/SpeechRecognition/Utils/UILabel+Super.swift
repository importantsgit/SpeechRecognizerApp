//
//  UILabel+Super.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/22.
//
import UIKit

class CreateLabel {
    private var label = UILabel()
    private var labelText: String = ""
    private var labelFont: UIFont = OBFont.description.description1
    private var labelTextColor: UIColor = .tertiaryLabel
    private var labelNumberOfLines:Int = 1
    private var lineHeight: CGFloat?
    private var alignment: NSTextAlignment = .left

    @discardableResult
    public func setupText(_ text: String) -> CreateLabel {
        self.labelText = text
        return self
    }
    
    @discardableResult
    public func setupFont(_ font: UIFont?) -> CreateLabel {
        if let font = font { self.labelFont = font }
        return self
    }
    
    @discardableResult
    public func setupTextColor(_ color: UIColor) -> CreateLabel {
        self.labelTextColor = color
        return self
    }
    
    @discardableResult
    public func setuplabelNumberOfLines(_ num: Int) -> CreateLabel {
        self.labelNumberOfLines = num
        return self
    }
    
    @discardableResult
    public func setuplabelAlignment(_ alignment: NSTextAlignment) -> CreateLabel {
        self.alignment = alignment
        return self
    }
    
    @discardableResult
    public func setupLineHeight(_ lineHeight: CGFloat) -> CreateLabel {
        self.lineHeight = lineHeight
        return self
    }
    
    public func build() -> UILabel {
        label.numberOfLines = labelNumberOfLines
        label.text = labelText
        label.font = labelFont
        label.textColor = labelTextColor
        label.textAlignment = alignment
        
        if let lineHeight = self.lineHeight {
            label.lineHeight(to: lineHeight)
        }
        label.textAlignment = alignment
        
        // autoLayout 적용 (폰트크기 저절로 조절)
        //label.adjustsFontSizeToFitWidth = true

        return label
    }
}

