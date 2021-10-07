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
    
    /// 모든 타입
    ///
    /// 북마크 관리 화면에서 필터링을 위해 필요한 케이스입니다.
    case all
    
    /// 카페
    case cafe
    
    /// 식당
    case restaurant
    
    /// 베이커리
    case bakery
    
    /// 디저트 가게
    case dessert
    
    /// 주점
    ///
    /// 펍, 바, 전통주점 등의 주점
    case pub
    
    /// 스터디카페
    case studyCafe
    
    /// 매칭되는 실제 Place.PlaceType 케이스
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
