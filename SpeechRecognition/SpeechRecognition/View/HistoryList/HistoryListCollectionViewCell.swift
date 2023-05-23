//
//  HistoryListTableViewCell.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/23.
//

import UIKit

class HistoryListCollectionViewCell: UICollectionViewCell {
    
    var containView = UIView()
    var padding: CGFloat = 24.0
    
    var roleLabel = CreateLabel()
        .setupText("")
        .setupFont(UIFont.systemFont(ofSize: 18, weight: .semibold))
        .setupTextColor(MyColor.titleColor.title1)
        .setuplabelAlignment(.center)
        .setuplabelNumberOfLines(1)
        .build()
    
    var contentLabel = CreateLabel()
        .setupText("")
        .setupFont(UIFont.systemFont(ofSize: 15))
        .setupTextColor(MyColor.decsriptionColor.decsription1)
        .setuplabelAlignment(.left)
        .setuplabelNumberOfLines(0)
        .build()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
}
extension HistoryListCollectionViewCell {
    
    private func setupViews() {
        contentView.addSubview(containView)
        containView.translatesAutoresizingMaskIntoConstraints = false
        
        containView.layer.backgroundColor = UIColor.systemBackground.cgColor
        containView.layer.borderColor = MyColor.border.cgColor
        containView.layer.borderWidth = 0.5
        containView.layer.cornerRadius = 4.0
        
        containView.layer.shadowColor = UIColor.lightGray.cgColor
        containView.layer.shadowRadius = 5.0
        containView.layer.shadowOpacity = 0.3
        containView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        
        
        [roleLabel, contentLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            containView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding/2),
            containView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            containView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding),
            containView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding/2),
            
            roleLabel.topAnchor.constraint(equalTo: containView.topAnchor, constant: 16.0),
            roleLabel.leftAnchor.constraint(equalTo: containView.leftAnchor, constant: 16.0),
            
            contentLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 8.0),
            contentLabel.leftAnchor.constraint(equalTo: roleLabel.leftAnchor, constant: 2.0),
            contentLabel.rightAnchor.constraint(equalTo: containView.rightAnchor, constant: -16.0),
            contentLabel.bottomAnchor.constraint(equalTo: containView.bottomAnchor, constant: -32.0)
        ])
    }

    func setup(message: Message) {
        roleLabel.text = message.role == "assistant" ? "Tamsjiro (immigration officer)" : "User"
        contentLabel.text = message.content
    }
}
