//
//  MainContentModel.swift
//  SpeechRecognition
//
//  Created by 이재훈 on 2023/05/24.
//

import UIKit

struct MainContentModel {
    let image: UIImage?
    let title: String
    let type: Consts.Places
    
    static let collection: [MainContentModel] = [
        .init(image: UIImage(named: "airport"), title: "공항", type: .airport),
        .init(image: UIImage(named: "cafe"), title: "카페", type: .cafe),
        .init(image: UIImage(named: "hotel"), title: "호텔", type: .hotel),
        .init(image: UIImage(named: "friend"), title: "친구와 대화", type: .friend),
        .init(image: UIImage(named: "dog"), title: "개와 대화", type: .dog)
    ]
}
