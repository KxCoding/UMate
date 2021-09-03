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
        let image: UIImage?
        let placeName: String
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
    
    /// 임시로 사용할 더미데이터
    static var dummyData = [
        PlaceReviewItem.UserReview(reviewText: "분위기 너무 좋아요", date: "2021.06.01", image: UIImage(named: "search_00"), placeName: "오오비"),
        PlaceReviewItem.UserReview(reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", date: "2021.05.28", image: UIImage(named: "search_01"), placeName: "카페 모"),
        PlaceReviewItem.UserReview(reviewText: "커피는 데일리루틴 나만 알고싶은집", date: "2021.05.23", image: UIImage(named: "search_02"), placeName: "데일리루틴")
    ]
}
