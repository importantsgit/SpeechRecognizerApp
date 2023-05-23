//
//  ViewController.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/16.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {
    private var parentView = UIView()
    private var userView = UIView()
    private var chatView = UIView()
    private var userScrollView = UIScrollView()
    private var chatGPTScrollView = UIScrollView()
    private var userContainView = UIView()
    private var chatGPTcontainView = UIView()
    
    var vm = ViewModel(api: ChatGPTAPI(apiKey: Consts.ChatGPTAPIKEY))

    var userTitleLabel = CreateLabel().setupText("User")
        .setupTextColor(.systemGray)
        .setupFont(OBFont.title.title1)
        .setuplabelAlignment(.left)
        .build()
    
    var chatGPTTitleLabel = CreateLabel().setupText("ChatGPT")
        .setupTextColor(.systemGray)
        .setupFont(OBFont.title.title1)
        .setuplabelAlignment(.left)
        .build()
    
    var speechRecognizer = SpeechRecognizer()
    
    var TextToSpeechManager = TTSManager()
    
    lazy var listButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(listButtonItemTapped))
        
        return button
    }()
    
    lazy var button: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var userLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "가볍게 인사해주세요!"
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.numberOfLines = 0
        
        
        return label
    }()
    
    var chatGPTLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "당신과 대화할 준비가 되어 있답니다."
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.numberOfLines = 0
        
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = "회화"
        navigationItem.rightBarButtonItem = listButtonItem
    }
    
    func setupViews() {
        self.view.backgroundColor = .systemGray6
        
        [parentView, userView, userTitleLabel, userScrollView, userContainView, chatView, chatGPTTitleLabel, chatGPTScrollView, chatGPTcontainView, userLabel, chatGPTLabel, button].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [parentView, button].forEach{
            self.view.addSubview($0)
        }

        [userView, chatView].forEach{
            parentView.addSubview($0)
        }
        
        [userTitleLabel, userScrollView].forEach{
            userView.addSubview($0)
        }
        
        [chatGPTTitleLabel, chatGPTScrollView].forEach{
            chatView.addSubview($0)
        }

        userScrollView.addSubview(userContainView)
        userContainView.addSubview(userLabel)
        chatGPTScrollView.addSubview(chatGPTcontainView)
        chatGPTcontainView.addSubview(chatGPTLabel)
        
        [userView, chatView].forEach{
            $0.backgroundColor = .systemBackground
            $0.layer.cornerRadius = 12.0
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 0.5
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowColor = UIColor.gray.cgColor
        }

        let buttonSize = 64.0
        let buttonCornerRadius = 32.0
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let screenHeight = windowScene?.windows.first?.frame.height ?? 300.0
        let labelMargin: CGFloat = 16.0
        print(screenHeight)
        
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            parentView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            parentView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            parentView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24.0),
            
            userView.topAnchor.constraint(equalTo: parentView.topAnchor),
            userView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 32.0),
            userView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -32.0),
            userView.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.48),
            
            userTitleLabel.topAnchor.constraint(equalTo: userView.topAnchor, constant: 16.0),
            userTitleLabel.leftAnchor.constraint(equalTo: userView.leftAnchor, constant: 16.0),
            userTitleLabel.rightAnchor.constraint(equalTo: userView.rightAnchor),
            
            userScrollView.topAnchor.constraint(equalTo: userTitleLabel.bottomAnchor),
            userScrollView.leftAnchor.constraint(equalTo: userView.leftAnchor),
            userScrollView.rightAnchor.constraint(equalTo: userView.rightAnchor),
            userScrollView.bottomAnchor.constraint(equalTo: userView.bottomAnchor),
            
            userContainView.topAnchor.constraint(equalTo: userScrollView.topAnchor),
            userContainView.bottomAnchor.constraint(equalTo: userScrollView.bottomAnchor),
            userContainView.leftAnchor.constraint(equalTo: userScrollView.leftAnchor),
            userContainView.rightAnchor.constraint(equalTo: userScrollView.rightAnchor),
            userContainView.widthAnchor.constraint(equalTo: userScrollView.widthAnchor, multiplier: 1.0),
            
            userLabel.topAnchor.constraint(equalTo: userContainView.topAnchor, constant: labelMargin),
            userLabel.bottomAnchor.constraint(equalTo: userContainView.bottomAnchor, constant: -labelMargin),
            userLabel.leftAnchor.constraint(equalTo: userContainView.leftAnchor, constant: labelMargin),
            userLabel.rightAnchor.constraint(equalTo: userContainView.rightAnchor, constant: -labelMargin),
            
            
            chatView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            chatView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 32.0),
            chatView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -32.0),
            chatView.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.48),
            
            chatGPTTitleLabel.topAnchor.constraint(equalTo: chatView.topAnchor, constant: 16.0),
            chatGPTTitleLabel.leftAnchor.constraint(equalTo: chatView.leftAnchor, constant: 16.0),
            chatGPTTitleLabel.rightAnchor.constraint(equalTo: chatView.rightAnchor),
            
            chatGPTScrollView.topAnchor.constraint(equalTo: chatGPTTitleLabel.bottomAnchor),
            chatGPTScrollView.leftAnchor.constraint(equalTo: chatView.leftAnchor),
            chatGPTScrollView.rightAnchor.constraint(equalTo: chatView.rightAnchor),
            chatGPTScrollView.bottomAnchor.constraint(equalTo: chatView.bottomAnchor),
            
            chatGPTcontainView.topAnchor.constraint(equalTo: chatGPTScrollView.topAnchor),
            chatGPTcontainView.bottomAnchor.constraint(equalTo: chatGPTScrollView.bottomAnchor),
            chatGPTcontainView.leftAnchor.constraint(equalTo: chatGPTScrollView.leftAnchor),
            chatGPTcontainView.rightAnchor.constraint(equalTo: chatGPTScrollView.rightAnchor),
            chatGPTcontainView.widthAnchor.constraint(equalTo: chatGPTScrollView.widthAnchor, multiplier: 1.0),
            
            chatGPTLabel.topAnchor.constraint(equalTo: chatGPTcontainView.topAnchor, constant: labelMargin),
            chatGPTLabel.bottomAnchor.constraint(equalTo: chatGPTcontainView.bottomAnchor, constant: -labelMargin),
            chatGPTLabel.leftAnchor.constraint(equalTo: chatGPTcontainView.leftAnchor, constant: labelMargin),
            chatGPTLabel.rightAnchor.constraint(equalTo: chatGPTcontainView.rightAnchor, constant: -labelMargin),

            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32.0),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: buttonSize),
            button.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        button.layer.cornerRadius = buttonCornerRadius
    }
    
    @objc func buttonTapped() {
        button.isSelected.toggle()
        
        if button.isSelected {
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing()
            button.backgroundColor = .gray
        } else {
            var str = ""
            speechRecognizer.stopTranscribing()
            userLabel.text = speechRecognizer.transcript
            Task {
                str += await vm.send(text:speechRecognizer.transcript)
                chatGPTLabel.text = str
            }
            button.backgroundColor = .systemRed
        }
    }
    
    @objc func listButtonItemTapped() {
        var vc = HistoryListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
