//
//  Review.swift
//  Review
//
//  Created by Effie on 2021/07/23.
//

import UIKit

struct PlaceReviewItem {
    struct UserReview {
        let reviewText: String
        let date: String
    }
    
    
    let starPoint: Double
    
    enum Taste: String {
        case delicious = "맛있다"
        case fresh = "신선하다"
        case clean = "깔끔하다"
        case plain = "고소하다"
        case salty = "짜다"
    }
    let taste: Taste
    
    enum Service: String {
        case kind = "친절함"
        case unkind = "불친절함"
        case touchy = "까칠함"
    }
    let service: Service
    
    enum Mood: String {
        case quiet = "조용한"
        case emotional = "감성적인"
        case simple = "심플한"
        case cute = "아기자기한"
        case clear = "깔끔한"
        
    }
    let mood: Mood
    
    enum Price: String {
        case cheap = "저렴하다"
        case affordable = "적당하다"
        case expensive = "비싸다"
    }
    let price: Price
    
    enum Amount: String {
        case small = "적다"
        case suitable = "적당하다"
        case plenty = "푸짐하다"
    }
    let amount: Amount
}
