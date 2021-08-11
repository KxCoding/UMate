//
//  Search.swift
//  Search
//
//  Created by Hyunwoo Jang on 2021/08/01.
//

import Foundation
import UIKit

struct SearchPlaceItem {
    let image: UIImage?
    let placeTitle: String
    let regionName: String
    let classificationName: String
    
    enum PlaceType: String {
        case cafe = "cafe"
        case restaurant = "restaurant"
        case bakery = "bakery"
        case studyCafe = "pencil"
        case pub = "beer"
        case desert = "desert"
    }
    let placeType: PlaceType
}
