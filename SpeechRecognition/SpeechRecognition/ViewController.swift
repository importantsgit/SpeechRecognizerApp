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
    
    private var scrollView = UIScrollView()
    private var containView = UIView()
    
//    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-KR"))
//    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    private var recognitionTask: SFSpeechRecognitionTask?
//    private let audioEngine = AVAudioEngine()
    
    var speechRecognizer = SpeechRecognizer()
    
    lazy var button: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var listenButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .blue
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var label: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = """
        An urgent health warning now. The CDC has issued a travel advisory after five people in Texas became ill with suspected fungal meningitis after traveling to the border town of Matamoros, Mexico. At least one person died from this. Four others are hospitalized.
        And health officials are now trying to figure out if the cases are linked and if there are more infections. We have CNN Senior medical correspondent Elizabeth Cohen, who is following this story. Elizabeth, why were these residents in Matamoros in for the first place?
        
        Brianna, this has been happening more and more that folks who live in Texas or really anywhere. They find out that procedures in Mexico are much less expensive and they often have a shorter wait time.
        So, as you mentioned, we have four people in the hospital, one person who has died. These people were in their 30s, 40s and 50s, and CDC is issuing a very brunt piece of advice. Cancel any appointments that you might have to get an epidural for an anesthetic in Mexico.
        Now if anything sounds familiar, it's because 11 years ago something very similar happened. People in the United States getting care in the United States were getting fungal infection from epidurals. More than 60 people died Brianna.
        What are the signs of fungal meningitis? Because they are looking to see if there are more people with this.
        Right. So, the CDC and other health officials are saying if you've been to Matamoros, if you've gotten this procedure. You should be on the lookdown for a headache, for fever, for nausea, for vomiting. If you're experiencing any of those and you had that procedure, you should definitely seek medical attention.
        """
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.numberOfLines = 0
        
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    func setupViews() {
        self.view.backgroundColor = .systemBackground
        
        [scrollView, containView, label, button, listenButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [scrollView, button, listenButton].forEach{
            self.view.addSubview($0)
        }

        scrollView.addSubview(containView)
        containView.addSubview(label)
        
        let buttonSize = 64.0
        let buttonCornerRadius = 32.0
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16.0),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32.0),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32.0),
            
            containView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            containView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            containView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0),
            
            label.topAnchor.constraint(equalTo: containView.topAnchor),
            label.bottomAnchor.constraint(equalTo: containView.bottomAnchor),
            label.leftAnchor.constraint(equalTo: containView.leftAnchor),
            label.rightAnchor.constraint(equalTo: containView.rightAnchor),
            
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32.0),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: buttonSize),
            button.heightAnchor.constraint(equalToConstant: buttonSize),
            
            listenButton.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            listenButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24.0),
            listenButton.widthAnchor.constraint(equalToConstant: buttonSize),
            listenButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        

        
        button.layer.cornerRadius = buttonCornerRadius
        listenButton.layer.cornerRadius = buttonCornerRadius
    }
    
    @objc func buttonTapped() {
        button.isSelected.toggle()
        
        if button.isSelected {
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing()
            button.backgroundColor = .gray
        } else {
            speechRecognizer.stopTranscribing()
            label.text = speechRecognizer.transcript
            button.backgroundColor = .systemRed
        }
    }
}
