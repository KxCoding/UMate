//
//  PlaceReviewPostData.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/23.
//

import Foundation


/// 상점 리뷰 목록 응답 모델
/// - Author: 장현우(heoun3089@gmail.com)
struct PlaceReviewList: Codable {
    
    /// 상점 리뷰 모델
    struct PlaceReview: Codable {
        
        /// 상점 모델
        struct Place: Codable {
            
            /// 상점 이름
            let name: String
        }
        
        /// 상점 리뷰 아이디
        let placeReviewId: Int
        
        /// 유저 아이디
        let userId: String?
        
        /// 상점 정보를 가진 속성
        let place: Place
        
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
        
        /// 추천수
        let recommendationCount: Int
        
        /// 리뷰를 작성한 날짜
        let insertDate: String
    }
    
    /// 리뷰 데이터 총 개수
    let totalCount: Int
    
    /// 상점 리뷰 목록
    let list: [PlaceReview]
    
    /// 서버 상태 코드
    let code: Int
    
    /// 서버 메시지
    let message: String?
    
    
    /// 서버 응답 데이터를 파싱합니다.
    /// - Parameters:
    ///   - data: 서버 응답 데이터
    ///   - vc: 이 메소드를 호출하는 뷰컨트롤러
    /// - Returns: 상점 리뷰 목록
    static func parse(data: Data, vc: CommonViewController) -> [PlaceReview] {
        var list = [PlaceReview]()
        
        do {
            let decoder = JSONDecoder()
            let placeReviewList = try decoder.decode(PlaceReviewList.self, from: data)
            
            if placeReviewList.code == ResultCode.ok.rawValue {
                list = placeReviewList.list
            }
        } catch {
            vc.alert(message: error.localizedDescription)
        }
        
        return list
    }
}
