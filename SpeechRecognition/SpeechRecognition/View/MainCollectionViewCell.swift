//
//  MainCollectionViewCell.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/23.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    private var sectionView = UIView()
    private var containView = UIView()
    private var imageView = UIImageView()
    private var label = CreateLabel()
        .setupText("여행")
        .setuplabelNumberOfLines(1)
        .setupFont(OBFont.title.title2)
        .setuplabelAlignment(.center)
        .setupTextColor(MyColor.titleColor.title1)
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

extension MainCollectionViewCell {
    func setupViews() {
        sectionView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(sectionView)

        sectionView.layer.backgroundColor = UIColor.systemBackground.cgColor
        sectionView.layer.borderColor = MyColor.border.cgColor
        sectionView.layer.borderWidth = 0.5
        sectionView.layer.cornerRadius = 4.0
        sectionView.layer.shadowColor = UIColor.lightGray.cgColor
        sectionView.layer.shadowRadius = 5.0
        sectionView.layer.shadowOpacity = 0.3
        sectionView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        containView.translatesAutoresizingMaskIntoConstraints = false
        sectionView.addSubview(containView)
        
        containView.layer.cornerRadius = 4.0
        containView.clipsToBounds = true
        
        [imageView, label].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            containView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            sectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            sectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            sectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            sectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            containView.topAnchor.constraint(equalTo: sectionView.topAnchor),
            containView.leftAnchor.constraint(equalTo: sectionView.leftAnchor),
            containView.rightAnchor.constraint(equalTo: sectionView.rightAnchor),
            containView.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: containView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: containView.rightAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leftAnchor.constraint(equalTo: containView.leftAnchor),
            label.rightAnchor.constraint(equalTo: containView.rightAnchor),
            label.bottomAnchor.constraint(equalTo: containView.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 36.0)
            
        ])
        
        imageView.backgroundColor = .black
        
    }
    
    func setup(image: String, name: String) {
        self.imageView.image = UIImage(named: image)
        self.label.text = name
    }
}
