//
//  historyListViewController.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/22.
//

import UIKit

class HistoryListViewController: UIViewController {

    private var padding: CGFloat = 32.0
    var messages: [Message]
    var type: Consts.Places
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HistoryListCollectionViewCell.self, forCellWithReuseIdentifier: "MessageCell")
        
        return collectionView
    }()
    
    var label = CreateLabel()
        .setupText("현재 대화한 내용이 없습니다.")
        .setupFont(OBFont.header)
        .setupTextColor(MyColor.decsriptionColor.decsription1)
        .setuplabelAlignment(.center)
        .build()
    
    var bottomView = UIView()
    
    lazy var muteButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", image: UIImage(systemName: "speaker.zzz"), target: self, action: #selector(muteButtonItemTapped))
        
        return button
    }()
    
    init(messages: [Message], type: Consts.Places) {
        self.messages = messages
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColor.backgroundColor
        setupViews()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TTSManager.shared.stop()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false

            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )

            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func setupNavigationBar() {

        navigationItem.rightBarButtonItem = muteButtonItem
        guard let role = Consts.role[type] else {
            navigationItem.title = "대화 리스트"
            return
        }
        let job = role[0]
        let name = role[1]
        navigationItem.titleView = setTitle(title: "대화리스트", subTitle: name)
    }
    
    
    //FIXME: 반복되는 부분
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
        [collectionView, label, bottomView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: padding),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            
            label.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            
            bottomView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        bottomView.backgroundColor = .systemMint
        label.isHidden = !messages.isEmpty
    }
    
    @objc func muteButtonItemTapped() {
        TTSManager.shared.stop()
    }
}

extension HistoryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 100)
    }
}

extension HistoryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? HistoryListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(message: messages[indexPath.row], type: self.type)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        TTSManager.shared.play(message.content)
    }
}
