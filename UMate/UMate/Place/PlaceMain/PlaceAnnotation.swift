//
//  PlaceAnnotation.swift
//  PlaceAnnotation
//
//  Created by Effie on 2021/08/23.
//

import CoreLocation
import Foundation
import MapKit


// MARK: Annotation Classes

/// 가게를 표시할 커스텀  annotation
/// - Author: 박혜정(mailmelater11@gmail.com)
class PlaceAnnotation: NSObject, MKAnnotation {
    
    /// 좌표 데이터 (필수)
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    /// 제목
    var title: String?
    
    /// 부제목
    var subtitle: String?
    
    /// 표시하고 있는 가게를 식별할 수 있는 id
    var placeId: Int
    
    /// 표시하는 가게의 형식
    var placeType: Place.PlaceType
    
    
    init(coordinate: CLLocationCoordinate2D,
         title: String? = nil, subtitle: String? = nil,
         placeId: Int, placeType: Place.PlaceType) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.placeId = placeId
        self.placeType = placeType
    }
    
}
