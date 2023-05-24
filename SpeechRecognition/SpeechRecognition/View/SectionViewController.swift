//
//  ViewController.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/16.
//

import UIKit
import AVFoundation
import Speech

class SectionViewController: UIViewController {
    private var parentView = UIView()
    private var userView = UIView()
    private var chatView = UIView()
    private var userScrollView = UIScrollView()
    private var chatGPTScrollView = UIScrollView()
    private var userContainView = UIView()
    private var chatGPTcontainView = UIView()
    
    var type: Consts.Places
    
    var vm: ViewModel

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
    
    lazy var resetButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetButtonItemTapped))
        
        return button
    }()
    
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
    
    init(type: Consts.Places){
        self.vm = ViewModel(api: ChatGPTAPI(apiKey: Consts.ChatGPTAPIKEY, type: type))
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        getLastContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TTSManager.shared.stop()
    }
    
    func getLastContent() {
        guard let message = vm.getLastMessage() else {return}
        userLabel.text = "상대의 말에 이어서 말해보세요"
        chatGPTLabel.text = message.content
    }
    
    func setupNavigationBar() {

        navigationItem.rightBarButtonItems = [listButtonItem, resetButtonItem]
        guard let role = Consts.role[type] else {
            navigationItem.title = "Talk"
            return
        }
        let job = role[0]
        let name = role[1]
        navigationItem.titleView = setTitle(title: job, subTitle: name)
    }
    
    func setTitle(title: String, subTitle: String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -5, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        let subTitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subTitleLabel.backgroundColor = UIColor.clear
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.text = subTitle
        subTitleLabel.textColor = .white
        subTitleLabel.sizeToFit()
        let titleLabelSize = titleLabel.frame.size, subTitleLabelSize = subTitleLabel.frame.size
        
        let width = titleLabelSize.width > subTitleLabelSize.width ? titleLabelSize.width : subTitleLabelSize.width
        let height = titleLabelSize.height + subTitleLabelSize.height + 4.0
        
        let titleStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subTitleLabel)
        titleStackView.spacing = 2.0
        titleStackView.axis = .vertical
        titleStackView.alignment = .center
        titleStackView.distribution = .equalCentering
        
        return titleStackView
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
        let messages = self.vm.getMessages()
        let vc = HistoryListViewController(messages: messages, type: self.type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func resetButtonItemTapped() {
        let vc = PopupViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.setPopup(title: "데이터 삭제", description: "삭제하면 저장되었던 데이터가 사라집니다.", buttonTitle: "삭제하기", buttonType: .optional) { [weak self] in
            guard let self = self else {return}
            self.vm.deleteMessages()
            self.resetLabel()
        }

        self.present(vc, animated: true)
    }
    
    func resetLabel() {
        userLabel.text = "가볍게 인사해주세요!"
        chatGPTLabel.text = "당신과 대화할 준비가 되어 있답니다."
    }
}

enum SectionViewContent {
    //static let
}
