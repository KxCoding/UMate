//
//  PlaceAnnotation.swift
//  PlaceAnnotation
//
//  Created by Effie on 2021/08/23.
//

import Foundation
import CoreLocation
import MapKit


// MARK: Annotation Classes

/// 가게를 표시할 커스텀  annotation
class PlaceAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    /// 표시하고 있는 가게를 식별할 수 있는 id (생성 시점에 저장, place id 형식과 동기화)
    var placeId: Int
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
