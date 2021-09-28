//
//  HomeModel.swift
//  HomeModel
//
//  Created by 황신택 on 2021/09/15.
//

import Foundation

/// 셀타입 열거형으로 만들고 연관값 사용.
/// 속성 전부 동일하나 구분지어 사용해야하기 때문에 연관값을 사용.
/// Author: 황신택
enum HomeViewCellType {
    case main(HomeViewCellData)
    case promotion(HomeViewCellData)
    case contest(HomeViewCellData)
}

/// 홈뷰 구성화면 데이타
/// Author: 황신택
struct HomeViewCellData {
    let cellTitle: String
    let detailTitle: String?
    let backgoundImageName: String
}

/// 홈뷰 컨트롤러에서 사용할 데이타 함수
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


