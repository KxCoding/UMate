//
//  ReviewTemplate.swift
//  UMate
//
//  Created by Effie on 2021/09/14.
//

import Foundation


/// 리뷰 템플릿를 나타내는 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
struct ReviewTemplate: Codable {
    
    /// 템플릿 Id
    let id: Int
    
    /// 템플릿 이름
    let name: String
    
    /// 템플릿 내용
    let content: String
    
    /// 임시 템플릿 1
    static let temp1 = ReviewTemplate(id: 0,
                                      name: "항목별",
                                      content: """
                                        [🥢맛] 건강한 맛을 선호하는데...
                                        [🎨분위기] 자타공인 감성 벌레...🐛
                                        [🧼위생] 민감한 편은 아닌데...
                                        """)
    
    /// 임시 템플릿 2
    static let temp2 = ReviewTemplate(id: 1,
                                      name: "추천 메뉴",
                                      content: """
                                        [✔️추천 메뉴]
                                        하나만 먹는다면 -
                                        추천 조합 -
                                        """)
    
    /// 임시 템플릿 3
    static let temp3 = ReviewTemplate(id: 2,
                                      name: "블로그 홍보",
                                      content: """
                                        블로그에도 리뷰 올렸어요! 구경오세요
                                        https://blog.naver.com/blogpeople
                                        """)
    
}
