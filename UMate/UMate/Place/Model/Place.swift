//
//  Model.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit
import CoreLocation
import MapKit

// 가게
struct Place {
    
    /// 가게 종류 = 열거형으로 제한
    enum PlaceType: String, CustomStringConvertible {
        
        case cafe = "카페"
        case restaurant = "식당"
        case bakery = "베이커리"
        case studyCafe = "스터디카페"
        case pub = "주점"
        case dessert = "디저트"
        
        /// description 속성
        var description: String {
            switch self {
            case .cafe:
                return "cafe"
            case .restaurant:
                return "restaurant"
            case .bakery:
                return "bakery"
            case .studyCafe:
                return "studycafe"
            case .pub:
                return "pub"
            case .dessert:
                return "dessert"
            }
        }
        
        /// 타입을 나타내는 아이콘
        var iconImage: UIImage? {
            return UIImage(named: self.description)
        }
        
        /// 타입을 나타내는 사진
        var photoImage: UIImage? {
            return UIImage(named: "\(description)-img")
        }
        
        
    }
    
    /// 가게의 ID
    var id = UUID()
    
    /// 가게 이름
    var name: String
    
    /// 인근 대학
    var university: String
    
    /// 가게가 있는 지역
    var district: String
    
    /// 가게 좌표
    var coordinate: CLLocationCoordinate2D
    
    /// 가게의 종류
    var type: PlaceType
    
    /// 가게를 나타내는 키워드 (각 키워드는 공백 포함 8자 이내)
    var keywords: [String]
    
    /// 가게 사진
    var images = [UIImage]()
    
    /// 인스타그램 아이디(optional), 관련 url(optional)
    var instagramID: String?
    var url: String?
    
    /// annotation
    var annotation: MKAnnotation {
        switch type {
        case .cafe:
            return CafeAnnotation(coordinate: coordinate,
                                  title: name,
                                  subtitle: "\(keywords.first ?? "") \(type.rawValue)")
        case .restaurant:
            return RestaurantAnnotation(coordinate: coordinate,
                                        title: name,
                                        subtitle: "\(keywords.first ?? "") \(type.rawValue)")
        case .bakery:
            return BakeryAnnotation(coordinate: coordinate,
                                    title: name,
                                    subtitle: "\(keywords.first ?? "")")
        case .studyCafe:
            return StudyCafeAnnotation(coordinate: coordinate,
                                       title: name,
                                       subtitle: "\(keywords.first ?? "") \(type.rawValue)")
        case .pub:
            return PubAnnotation(coordinate: coordinate,
                                 title: name,
                                 subtitle: "\(keywords.first ?? "") \(type.rawValue)")
        case .dessert:
            return DesertAnnotation(coordinate: coordinate,
                                    title: name,
                                    subtitle: "\(keywords.first ?? "")")
        }
    }
    
    /// 더미 데이터 (type property)
    static let dummyData: [Place] = [
        Place(name: "데일리루틴",
              university: "숙명여대",
              district: "숙대입구역 인근",
              coordinate: CLLocationCoordinate2D(latitude: 37.544055, longitude: 126.972906),
              type: .cafe,
              keywords: ["레트로", "사진 찍기 좋은", "새로 오픈한", "친절", "따뜻한", "커피 맛집", "목재 가구"],
              instagramID: "dailyroutinecoffee",
              url: "http://naver.me/xrPcV2Ie"),
        Place(name: "스티키리키",
              university: "숙명여대",
              district: "숙대입구역 인근",
              coordinate: CLLocationCoordinate2D(latitude: 37.546489, longitude: 126.973707),
              type: .dessert,
              keywords: ["수제 아이스크림", "포토존", "핫플", "아기자기한"],
              instagramID: "stickyrickys",
              url: "http://naver.me/xE1xr6kD"),
        Place(name: "오오비",
              university: "숙명여대",
              district: "숙대입구역 인근",
              coordinate: CLLocationCoordinate2D(latitude: 37.542399, longitude: 126.973072),
              type: .cafe,
              keywords: ["햇살 맛집", "드립커피", "아늑한", "LP 음악", "통창"],
              instagramID: "oob_official",
              url: "http://naver.me/FMAdSiZN"),
        Place(name: "카페 모",
              university: "숙명여대",
              district: "숙대입구역 인근",
              coordinate: CLLocationCoordinate2D(latitude: 37.545498, longitude: 126.972927),
              type: .cafe,
              keywords: ["보태니컬", "영화", "햇살 맛집", "나만 알고 싶은"],
              instagramID: "cafe_mo",
              url: "http://naver.me/F7CF9X6a"),
        Place(name: "부암동 치킨",
              university: "숙명여대",
              district: "청파동 언덕길",
              coordinate: CLLocationCoordinate2D(latitude: 37.544685, longitude: 126.967352),
              type: .restaurant,
              keywords: ["치킨", "맛집", "회식", "뒷풀이"],
              instagramID: nil,
              url: "http://naver.me/5y4qBz2M"),
        Place(name: "본솔 카페",
              university: "숙명여대",
              district: "청파동 언덕길",
              coordinate: CLLocationCoordinate2D(latitude: 37.544997, longitude: 126.966482),
              type: .cafe,
              keywords: ["테이크아웃", "아라 맛집", "청귤 에이드"],
              instagramID: nil,
              url: nil)
    ]
}




/// 가게 종류 필터 기능을 위한 열거형 (all 포함)
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
