//
//  University.swift
//  UMate
//
//  Created by Effie on 2021/08/30.
//

import Foundation
import CoreLocation

struct University {
    
    /// id
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
    
    static var tempUniversity = University(id: 0,
                                               name: "숙명여자대학교",
                                               latitude: 37.545621,
                                               longitude: 126.96502,
                                               places: Place.dummyData)
    
}
