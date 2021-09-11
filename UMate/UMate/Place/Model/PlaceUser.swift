//
//  UserPlaceInfo.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import UIKit
import CoreLocation

/// Place
struct PlaceUser {
    
    /// 사용자의 소속 대학
    var university: University? = nil
    
    /// Place 사용자의 데이터 클래스
    struct UserData {
        
        /// 사용자가 북마크한 가게 목록 (ID)
        var bookmarkedPlaces = [Int]()
        
        /// 사용자가 작성한 리뷰 목록
        var reviews = [UUID]()
        
        /// 자주 사용하는 문장 (템플릿)
        var reviewTemplate: [ReviewTemplate] = [ReviewTemplate.temp1,
                                                ReviewTemplate.temp2,
                                                ReviewTemplate.temp3]
    }
    
    /// Place 사용자의 Place Info
    var userData = UserData()
    
    /// 임시 사용자
    static var tempUser: PlaceUser = {
        var user = PlaceUser()
        
        /// 속성 초기화
        user.university = University.tempUniversity
        
        /// 더미 북마크 데이터
        user.userData.bookmarkedPlaces = [1, 9, 10, 17]
        
        return user
    }()
    
}


struct ReviewTemplate: Codable {
    let id: Int
    let name: String
    let content: String
    
    static let temp1 = ReviewTemplate(id: 0,
                                     name: "항목별",
                                     content: """
                                        [🥢맛] 건강한 맛을 선호하는데...
                                        [🎨분위기] 자타공인 감성 벌레...🐛
                                        [🧼위생] 민감한 편은 아닌데...
                                        """)
    
    static let temp2 = ReviewTemplate(id: 1,
                                     name: "추천 메뉴",
                                     content: """
                                        [✔️추천 메뉴]
                                        하나만 먹는다면 -
                                        추천 조합 -
                                        """)
    
    static let temp3 = ReviewTemplate(id: 2,
                                     name: "블로그 홍보",
                                     content: """
                                        블로그에도 리뷰 올렸어요! 구경오세요
                                        https://blog.naver.com/blogpeople
                                        """)
    
}
