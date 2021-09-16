//
//  University.swift
//  UMate
//
//  Created by Effie on 2021/08/30.
//

import CoreLocation
import Foundation


/// 대학 정보를 포함하는 클래스
///
/// 임시로 선언한 타입입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
struct University {
    
    /// 대학교 ID
    var id: Int
    
    /// 학교 이름
    var name: String
    
    /// 학교 대표 좌표
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// 학교 주변 가게
    var places: [Place]
    
    /// 임시 대학 데이터
    static var tempUniversity = University(id: 0,
                                               name: "숙명여자대학교",
                                               latitude: 37.545621,
                                               longitude: 126.96502,
                                               places: Place.dummyData)
    
}
