//
//  HomeModel.swift
//  HomeModel
//
//  Created by 황신택 on 2021/09/15.
//

import Foundation

/// 셀타입 열거형으로 세분화
enum CellType {
    case main(CellData)
    case promotion(CellData)
    case contest(CellData)
}

/// 실제 데이타를 저장할 구조체
struct CellData {
    let cellTitle: String
    let detailTitle: String?
    let backgoundImageName: String
}

/// 홈뷰 컨트롤러에서 사용할 데이타 함수
func getToHomeDataList() -> [CellType] {
    var list = [CellType]()
    
    list = [
        .main(CellData(cellTitle: "즐겨찾는 게시판", detailTitle: nil, backgoundImageName: "wish-list")),
        .main(CellData(cellTitle: "HOT 게시판", detailTitle: nil, backgoundImageName: "features")),
        .main(CellData(cellTitle: "Q&A 게시판", detailTitle: nil, backgoundImageName: "question")),
        .main(CellData(cellTitle: "교내홍보 게시판", detailTitle: nil, backgoundImageName: "megaphone")),
        .promotion(CellData(cellTitle: "채용정보", detailTitle: "많은 채용정보를 여기서 확인하세요.", backgoundImageName: "team")),
        .contest(CellData(cellTitle: "공모전/ 대외활동", detailTitle: "다양한 공모전 대외활동을 확인하세요.", backgoundImageName: "contest"))
    ]
    
    return list
}

