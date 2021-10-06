//
//  HomeModel.swift
//  HomeModel
//
//  Created by 황신택 on 2021/09/15.
//

import Foundation

/// 셀의 카테고리
/// 속성은 동일하나 구분 지어 사용해야 하기 때문에 연관 값을 사용했습니다.
/// Author: 황신택(sinadsl1457@gmail.com)
enum HomeViewCellType {
    /// 홈뷰 컨트롤러의 4개의 게시판
    case main(HomeViewCellData)
    
    /// 채용정보탭
    case promotion(HomeViewCellData)
    
    /// 공모전탭
    case contest(HomeViewCellData)
}

/// 홈뷰의 셀 데이타
struct HomeViewCellData {
    /// 카테고리 타이틀
    let cellTitle: String
    
    /// 상세내용
    let detailTitle: String?
    
    /// 카테고리 이미지
    let backgoundImageName: String
}


/// 홈뷰 컨트롤러에서 사용할 데이타 리스트
/// - Returns: [HomeViewCellType]
func getHomeDataList() -> [HomeViewCellType] {
    var list = [HomeViewCellType]()
    
    list = [
        .main(HomeViewCellData(cellTitle: "즐겨찾는 게시판", detailTitle: nil, backgoundImageName: "board")),
        .main(HomeViewCellData(cellTitle: "HOT 게시판", detailTitle: nil, backgoundImageName: "social")),
        .main(HomeViewCellData(cellTitle: "Q&A 게시판", detailTitle: nil, backgoundImageName: "faq")),
        .main(HomeViewCellData(cellTitle: "교내홍보 게시판", detailTitle: nil, backgoundImageName: "promotion")),
        .promotion(HomeViewCellData(cellTitle: "채용정보", detailTitle: "많은 채용정보를 여기서 확인하세요.", backgoundImageName: "jobhunt")),
        .contest(HomeViewCellData(cellTitle: "공모전/ 대외활동", detailTitle: "다양한 공모전 대외활동을 확인하세요.", backgoundImageName: "winner"))
    ]
    
    return list
}


