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
    
    /// 가게 종류
    ///
    /// 한국어 이름, 이미지 등을 케이스의 원시값으로 제공합니다.
    enum PlaceType: String, CustomStringConvertible {
        
        /// 카페
        case cafe
        
        /// 식당
        case restaurant
        
        /// 베이커리
        case bakery
        
        /// 스터디카페
        case studyCafe
        
        /// 주점
        ///
        /// ex) 펍, 바, 전통주점
        case pub
        
        /// 디저트 가게
        case dessert
        
        /// 한글 이름
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
        
        /// 타입 아이콘
        var iconImage: UIImage? {
            return UIImage(named: rawValue)
        }
        
        /// 타입 이미지
        ///
        /// 북마크 관리 화면에서 가게 종류 필터 버튼에 사용됩니다.
        var photoImage: UIImage? {
            return UIImage(named: "\(rawValue)-img")
        }
        
    }
    
    
    
    /// 가게 Id
    var id: Int//= UUID()
    
    /// 가게 이름
    var name: String
    
    /// 가게가 있는 지역
    var district: String
    
    /// 위도
    let latitude: Double
    
    /// 경도
    let longitude: Double
    
    /// 가게 좌표
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
    
    /// 가게 종류
    ///
    /// json 파싱을 위한 속성입니다.
    let type: String
    
    /// 가게 종류
    ///
    /// 디코딩된 데이터와 매칭되는 Placetype을 제공합니다. 매칭되는 가게 종류가 없을 때는 cafe를 기본값으로 사용합니다.
    var placeType: PlaceType { return PlaceType(rawValue: type) ?? .cafe }
    
    /// 가게를 표현하는 키워드
    ///
    /// 가게의 특징, 분위기 등을 표현하는 키워드로, 상세 정보 화면의 키워드 컬렉션 뷰에서 사용됩니다.
    var keywords: [String]
    
    /// 미리보기 이미지 url
    var thumbnailUrl: String
    
    /// 상세 화면에 표시할 이미지 url
    ///
    /// 이미지가 없으면 빈 배열을 리턴하므로, 항목이 있는지 확인 후 사용해야 합니다.
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
    
    /// 가게 더미 데이터
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
