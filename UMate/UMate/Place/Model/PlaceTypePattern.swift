//
//  PlaceTypePattern.swift
//  UMate
//
//  Created by Effie on 2021/09/14.
//

import Foundation


/// 가게 종류 필터 기능을 위한 열거형 (all 포함)
/// - Author: 박혜정(mailmelater11@gmail.com)
enum PlaceTypePattern: String {
    case all
    case cafe, restaurant, bakery, dessert, pub, studyCafe
    
    var matchedPlaceType: Place.PlaceType? {
        switch self {
        case .all:
            return .none
        case .cafe:
            return .cafe
        case .restaurant:
            return .restaurant
        case .bakery:
            return .bakery
        case .dessert:
            return .dessert
        case .pub:
            return .pub
        case .studyCafe:
            return .studyCafe
        }
    }
}
