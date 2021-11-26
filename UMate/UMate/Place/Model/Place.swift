//
//  Model.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import CoreLocation
import MapKit
import UIKit
import WebKit


/// 상점 정보 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
struct Place: Codable {
    
    /// 상점 종류
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
        
        /// 디저트 판매점
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
        ///
        /// 북마크 관리 화면과 상세 정보 화면에서 사용됩니다.
        var iconImage: UIImage? {
            return UIImage(named: rawValue)
        }
        
        /// 타입 이미지
        ///
        /// 북마크 관리 화면에서 상점 종류 필터 버튼에 사용됩니다.
        var photoImage: UIImage? {
            return UIImage(named: "\(rawValue)-img")
        }
        
    }
    
    // MARK: Properties
    
    /// 상점 Id
    var id: Int
    
    /// 상점 이름
    var name: String
    
    /// 상점이 있는 지역
    var district: String
    
    /// 위도
    let latitude: Double
    
    /// 경도
    let longitude: Double
    
    /// 상점 좌표
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// annotation
    var annotation: MKAnnotation {
        return PlaceAnnotation(coordinate: coordinate,
                               title: name,
                               subtitle: keywords.first ?? "",
                               placeId: id,
                               placeType: placeType)
    }
    
    /// 상점 종류
    ///
    /// json 파싱을 위한 속성입니다.
    let type: String
    
    /// 상점 종류
    ///
    /// 디코딩된 데이터와 매칭되는 Placetype을 제공합니다. 매칭되는 상점 종류가 없을 때는 cafe를 기본값으로 사용합니다.
    var placeType: PlaceType { return PlaceType(rawValue: type) ?? .cafe }
    
    /// 상점을 표현하는 키워드
    ///
    /// 상점의 특징, 분위기 등을 표현하는 키워드로, 상세 정보 화면의 키워드 컬렉션 뷰에서 사용됩니다.
    var keywords: [String]
        
    /// 전화번호
    var tel: String?
    
    /// 인스타그램 아이디(optional)
    var instagramId: String?
    
    /// 관련 url(optional)
    var url: String?
    
    /// 미리보기 이미지 url
    var thumbnailUrl: String
    
    /// 상세 화면에 표시할 이미지 url
    ///
    /// 이미지가 없으면 빈 배열을 리턴하므로, 항목이 있는지 확인 후 사용해야 합니다.
    var imageUrls: [String]
    
    #warning("임시 데이터입니다")
    /// 임시 데이터
    static let dummyPlace: Place = Place(id: 0,
                                         name: "",
                                         district: "",
                                         latitude: 0,
                                         longitude: 0,
                                         type: "cafe",
                                         keywords: [""],
                                         tel: nil,
                                         instagramId: nil,
                                         url: nil,
                                         thumbnailUrl: "cafe",
                                         imageUrls: [""])
    
    #warning("임시 데이터입니다")
    /// 임시 데이터
    static var dummyData: [Place] = [
        Place(id: 0,
              name: "",
              district: "",
              latitude: 0,
              longitude: 0,
              type: "cafe",
              keywords: [""],
              tel: nil,
              instagramId: nil,
              url: nil,
              thumbnailUrl: "cafe",
              imageUrls: [""])
    ]
    
    
    // MARK: Initializers
    
    init(id: Int, name: String, district: String, latitude: Double, longitude: Double, type: String, keywords: [String], tel: String?, instagramId: String?, url: String?, thumbnailUrl: String, imageUrls: [String]) {
        self.id = id
        self.name = name
        self.district = district
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.keywords = keywords
        self.tel = tel
        self.instagramId = instagramId
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        self.imageUrls = imageUrls
    }
    
    
    init(simpleDto: PlaceSimpleDto) {
        id = simpleDto.placeId
        name = simpleDto.name
        
        district = simpleDto.district
        latitude = simpleDto.latitude
        longitude = simpleDto.longitude
        
        type = simpleDto.type
        keywords = simpleDto.keywords.components(separatedBy: "#")
            .map({ $0.trimmingCharacters(in: .whitespaces) })
        
        tel = nil
        instagramId = nil
        url = nil
        
        thumbnailUrl = simpleDto.thumbnailImageUrl ?? ""
        imageUrls = []
    }
    
    
    init(dto: PlaceDto) {
        id = dto.placeId
        name = dto.name
        
        district = dto.district
        latitude = dto.latitude
        longitude = dto.longitude
        
        type = dto.type
        keywords = dto.keywords.components(separatedBy: "#").map({ $0.trimmingCharacters(in: .whitespaces) })
        
        tel = dto.tel
        instagramId = dto.instagramId
        url = dto.websiteUrl
        
        thumbnailUrl = dto.thumbnailImageUrl ?? ""
        let urls = [dto.placeImageUrl0 ?? "", dto.placeImageUrl1 ?? "", dto.placeImageUrl2 ?? "", dto.placeImageUrl3 ?? "", dto.placeImageUrl4 ?? "", dto.placeImageUrl5 ?? ""]
        
        imageUrls = []
        
        for url in urls {
            if url.count > 0 { imageUrls.append(url) }
        }
    }
    
}
