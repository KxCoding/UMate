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
/// 통합 예정입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
struct University {
    
    /// 대학교 Id
    var id: Int
    
    /// 학교 이름
    var name: String
    
    /// 학교 좌표의 위도
    var latitude: Double
    
    /// 학교 좌표의 경도
    var longitude: Double
    
    /// 학교 대표 좌표
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    /// 임시 데이터
    ///
    /// 다운로드나 파싱에 실패했을 때 기본값으로 사용합니다.
    static var tempUniversity = University(id: 0,
                                           name: "숙명여자대학교",
                                           latitude: 37.545621,
                                           longitude: 126.96502)
    
}
