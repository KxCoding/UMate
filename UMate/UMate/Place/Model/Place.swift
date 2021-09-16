//
//  Model.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import CoreLocation
import MapKit
import UIKit


/// 가게 정보를 담고 있는 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
struct Place: Codable {
    
    /// 가게 종류 = 열거형으로 제한
    enum PlaceType: String, CustomStringConvertible {
        
        case cafe
        case restaurant
        case bakery
        case studyCafe
        case pub
        case dessert
        
        /// description 속성
        var description: String {
            switch self {
            case .cafe:
                return "카페"
            case .restaurant:
                return "식당"
            case .bakery:
                return "베이커리"
            case .studyCafe:
                return "스터디카페"
            case .pub:
                return "주점"
            case .dessert:
                return "디저트"
            }
        }
        
        /// 타입을 나타내는 아이콘
        var iconImage: UIImage? {
            return UIImage(named: rawValue) // 영어
        }
        
        /// 타입을 나타내는 사진
        var photoImage: UIImage? {
            return UIImage(named: "\(rawValue)-img") // 영어
        }
        
    }
    
    
    
    /// 가게의 ID
    var id: Int//= UUID()
    
    /// 가게 이름
    var name: String
    
    /// 가게가 있는 지역
    var district: String
    
    /// 가게 좌표 - 위도
    let latitude: Double
    
    /// 가게 좌표 - 경도
    let longitude: Double
    
    /// 가게 좌표
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
    
    /// 가게의 종류
    let type: String
    var placeType: PlaceType { return PlaceType(rawValue: type) ?? .cafe }
    
    /// 가게를 나타내는 키워드 (각 키워드는 공백 포함 8자 이내)
    var keywords: [String]
    
    /// 미리보기 이미지(썸네일)의 url
    var thumbnailUrl: String
    
    /// 상세 화면에 표시할 이미지의 url - 이미지가 없으면 빈 배열
    var imageUrls: [String]
    
    /// 인스타그램 아이디(optional)
    var instagramId: String?
    
    /// 관련 url(optional)
    var url: String?
    
    /// 전화번호
    var tel: String?
    
    /// annotation
    var annotation: MKAnnotation {
        return PlaceAnnotation(coordinate: coordinate,
                               title: name,
                               subtitle: keywords.first ?? "",
                               placeId: id,
                               placeType: placeType)
    }
    
    /// 더미 데이터 (type property)
    static var dummyData: [Place] = [
        Place(id: 0, name: "데일리루틴",
              district: "숙대입구역 인근",
              latitude: 37.544055, longitude: 126.972906,
              type: "cafe",
              keywords: ["레트로", "사진 찍기 좋은", "새로 오픈한", "친절", "따뜻한", "커피 맛집", "목재 가구"],
              thumbnailUrl: "cafe",
              imageUrls: [],
              instagramId: "dailyroutinecoffee",
              url: "http://naver.me/xrPcV2Ie")
    ]
    
}
