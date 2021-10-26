//
//  Contest.swift
//  UMate
//
//  Created by 황신택 on 2021/10/08.
//

import Foundation

/// contests 제이슨 형식 데이터를 파싱하기 위해 Codable을 채용했습니다.
/// ContestsViewController에서 모델로 사용합니다.
/// - Author: 황신택 (sinadsl1457@gmail.com)
struct ContestSingleData: Codable {
    /// 인기 대외활동 데이터
    struct PopularContests: Codable {
        let id: Int
        let url: String
        let description: String
        let website: String
    }
    
    
    
    /// 대외활동 데이터
    struct Contests: Codable {
        let id: Int
        let field: String
        let description: String
        let institution: String
        let url: String
        let website: String
    }
    
    let header: String
    var favoriteList: [PopularContests]
    var contestList: [Contests]
}




