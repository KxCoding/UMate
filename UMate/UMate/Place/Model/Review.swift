//
//  Review.swift
//  Review
//
//  Created by Effie on 2021/07/23.
//

import UIKit


/// 가게 리뷰와 관련된 구조체
/// - Author: 장현우(heoun3089@gmail.com)
struct PlaceReviewItem {
    /// 음식맛 관련 열거형
    /// - Author: 장현우(heoun3089@gmail.com)
    enum Taste: String {
        case delicious = "맛있다"
        case fresh = "신선하다"
        case clean = "깔끔하다"
        case plain = "고소하다"
        case salty = "짜다"
    }
    
    
    
    /// 서비스 관련 열거형
    /// - Author: 장현우(heoun3089@gmail.com)
    enum Service: String {
        case kind = "친절함"
        case unkind = "불친절함"
        case touchy = "까칠함"
    }
    
    
    
    /// 분위기 관련 열거형
    /// - Author: 장현우(heoun3089@gmail.com)
    enum Mood: String {
        case quiet = "조용한"
        case emotional = "감성적인"
        case simple = "심플한"
        case cute = "아기자기한"
        case clear = "깔끔한"
    }
    
    
    
    /// 음식 가격 관련 열거형
    /// - Author: 장현우(heoun3089@gmail.com)
    enum Price: String {
        case cheap = "저렴하다"
        case affordable = "적당하다"
        case expensive = "비싸다"
    }
    
    
    
    /// 음식양 관련 열거형
    /// - Author: 장현우(heoun3089@gmail.com)
    enum Amount: String {
        case small = "적다"
        case suitable = "적당하다"
        case plenty = "푸짐하다"
    }
    
    
    
    /// 평점 관련 열거형
    /// - Author: 장현우(heoun3089@gmail.com)
    enum StarRating: Double {
        case onePoint = 1
        case twoPoint = 2
        case threePoint = 3
        case fourPoint = 4
        case fivePoint = 5
    }
}
