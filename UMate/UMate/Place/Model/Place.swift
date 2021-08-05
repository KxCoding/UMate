//
//  Model.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit
import CoreLocation

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
    
    var coordinate: CLLocationCoordinate2D?
    
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
    
    static let dummyData: [Place] = [
        Place(name: "스티키리키",
              university: "숙명여대",
              district: "숙대입구역 인근",
              coordinate: CLLocationCoordinate2D(latitude: 37.546489, longitude: 126.973707),
              type: .desert,
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
        Place(name: "데일리루틴",
              university: "숙명여대",
              district: "숙대입구역 인근",
              coordinate: CLLocationCoordinate2D(latitude: 37.544055, longitude: 126.972906),
              type: .cafe,
              keywords: ["레트로", "사진 찍기 좋은", "새로 오픈한", "친절", "따뜻한", "커피 맛집", "목재 가구"],
              instagramID: "dailyroutinecoffee",
              url: "http://naver.me/xrPcV2Ie"),
        Place(name: "부암동 치킨",
              university: "숙명여대",
              district: "청파동 언덕길",
              coordinate: CLLocationCoordinate2D(latitude: 37.544685, longitude: 126.967352),
              type: .restaurant,
              keywords: ["치킨", "맛집", "회식", "뒷풀이"],
              instagramID: nil,
              url: "http://naver.me/5y4qBz2M")
    ]
}

