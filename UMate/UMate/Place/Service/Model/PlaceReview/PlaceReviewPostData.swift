//
//  PlaceReviewPostData.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/23.
//

import Foundation


/// 상점 리뷰 POST 모델
/// - Author: 장현우(heoun3089@gmail.com)
struct PlaceReviewPostData: Codable {
    
    /// 상점 이름
    let place: String
    
    /// 맛
    let taste: String
    
    /// 서비스
    let service: String
    
    /// 분위기
    let mood: String
    
    /// 가격
    let price: String
    
    /// 음식양
    let amount: String
    
    /// 평점
    let starRating: Double
    
    /// 리뷰 텍스트
    let reviewText: String
}
