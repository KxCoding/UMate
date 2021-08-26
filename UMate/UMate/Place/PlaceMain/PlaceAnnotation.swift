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
    
    /// collection view와 동기화에 필요한 id
    var id: Int? = nil
    
    init(coordinate: CLLocationCoordinate2D,
         title: String, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}


/// 가게 타입별 annotation
class CafeAnnotation: PlaceAnnotation { }
class RestaurantAnnotation: PlaceAnnotation { }
class BakeryAnnotation: PlaceAnnotation { }
class StudyCafeAnnotation: PlaceAnnotation { }
class PubAnnotation: PlaceAnnotation { }
class DesertAnnotation: PlaceAnnotation { }
