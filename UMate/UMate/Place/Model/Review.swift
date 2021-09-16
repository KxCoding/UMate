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
    enum TotalPoint: String {
        case onePoint = "1점"
        case twoPoint = "2점"
        case threePoint = "3점"
        case fourPoint = "4점"
        case fivePoint = "5점"
    }
    
    
    
    /// 리뷰 텍스트
    let reviewText: String
    
    /// 날짜
    let date: String

    /// 가게 이미지
    let image: UIImage?
    
    /// 가게 이름
    let placeName: String
    
    /// 별점
    let starPoint: Double
    
    /// 음식맛
    let taste: Taste
    
    /// 서비스
    let service: Service
    
    /// 분위기
    let mood: Mood
    
    /// 가격
    let price: Price
    
    /// 음식양
    let amount: Amount
    
    /// 평점
    let totalPoint: TotalPoint
    
    /// 임시로 사용할 더미데이터
    static var dummyData = [
        PlaceReviewItem(reviewText: "분위기 너무 좋아요",
                        date: "2021.06.01",
                        image: UIImage(named: "search_00"),
                        placeName: "오오비",
                        starPoint: 4.5,
                        taste: .clean,
                        service: .kind,
                        mood: .clear,
                        price: .cheap,
                        amount: .suitable,
                        totalPoint: .fourPoint),
        PlaceReviewItem(reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        date: "2021.05.28",
                        image: UIImage(named: "search_01"),
                        placeName: "카페 모",
                        starPoint: 4.0,
                        taste: .plain,
                        service: .touchy,
                        mood: .cute,
                        price: .affordable,
                        amount: .plenty,
                        totalPoint: .fivePoint),
        PlaceReviewItem(reviewText: "좋아요",
                        date: "2021.05.21",
                        image: UIImage(named: "search_00"),
                        placeName: "오오비",
                        starPoint: 4.5,
                        taste: .clean,
                        service: .kind,
                        mood: .clear,
                        price: .cheap,
                        amount: .suitable,
                        totalPoint: .fourPoint),
        PlaceReviewItem(reviewText: "깔끔해요",
                        date: "2021.04.10",
                        image: UIImage(named: "search_00"),
                        placeName: "오오비",
                        starPoint: 4.5,
                        taste: .clean,
                        service: .kind,
                        mood: .clear,
                        price: .cheap,
                        amount: .suitable,
                        totalPoint: .fourPoint)
    ]
}
