//
//  Contest.swift
//  UMate
//
//  Created by 황신택 on 2021/10/08.
//

import Foundation

/// contests 제이슨 형식 데이터를 파싱하기 위해 Codable을 채용했습니다.
/// InternationalActivityViewController에서 모델로 사용합니다.
/// - Author: 황신택 (sinadsl1457@gmail.com)
struct ContestSingleData: Codable {
    /// 인기 대외활동 데이터를 구성할 때 사용됩니다.
    struct FavoriteContests: Codable {
        let url: String
        let description: String
    }
    /// 대외활동 데이터를 구성할 때 사용됩니다.
    struct Contests: Codable {
        let field: String
        let description: String
        let institution: String
        let url: String
    }
    
    
    let header: String
    
    let favoriteList: [FavoriteContests]
    let contestList: [Contests]
}





