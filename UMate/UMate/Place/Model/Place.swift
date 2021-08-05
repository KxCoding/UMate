//
//  Model.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit

// 가게
struct Place {
    
    enum PlaceType: String {
        case cafe = "카페"
        case restaurant = "식당"
        case bakery = "베이커리"
        case studyCafe = "스터디카페"
        case pub = "주점"
        case desert = "디저트 가게"
    }
    
    var id = UUID()
    
    var name: String
    
    var university: String
    var district: String
    
    // var location
    
    var type: PlaceType
    var typeIconImage: UIImage? {
        switch type {
        case .cafe:
            return UIImage(named: "cafe")
        case .restaurant:
            return UIImage(named: "restaurant")
        case .bakery:
            return UIImage(named: "bakery")
        case .studyCafe:
            return UIImage(named: "pencil")
        case .pub:
            return UIImage(named: "beer")
        case .desert:
            return UIImage(named: "ice-cream")
        }
    }
    
    var keywords: [String]
    
    var images = [UIImage]()
    
    var instagramID: String?
    var url: String?
}
