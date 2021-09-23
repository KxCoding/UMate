//
//  ConfigureListModel.swift
//  UMate
//
//  Created by 황신택 on 2021/09/22.
//

import Foundation

//enum ConfigureCellType {
//    case work(WorkListModel)
//    case region(WorkRegionList)
//
//}

struct WorkListModel {
    let classification1: String
    let classification2: String
    var state: Bool
    let header: String?
}


func generateWorkList() -> [WorkListModel] {
    var list = [WorkListModel]()
    
    list = [
        WorkListModel(classification1: "전체", classification2: "영업.영업관리", state: false, header: "직무"),
        WorkListModel(classification1: "전략.기획", classification2: "마케팅.광고.홍보", state: false, header: nil),
        WorkListModel(classification1: "유통.물류", classification2: "IT.SW", state: false, header: nil)
        
    ]
    
    return list
}


struct WorkRegionList {
    let region1: String
    let region2: String
    let region3: String
    let region4: String
    let region5: String
    let header: String?
}


func generateWorkRegionList() -> [WorkRegionList] {
    var list = [WorkRegionList]()
    
    list = [
        WorkRegionList(region1: "전체", region2: "서울", region3: "경기", region4: "광주", region5: "대구", header: "지역"),
        WorkRegionList(region1: "대전", region2: "부산", region3: "세종", region4: "울산", region5: "인천", header: nil),
        WorkRegionList(region1: "강원", region2: "경남", region3: "경북", region4: "전남", region5: "전북", header: nil)
    ]
    
    return list
}


struct Degree {
    let none: String
    let college: String
    let university: String
    let graduateSchool: String
    let doctorate: String
    let header: String
}


func generateDegreeList() -> [Degree] {
    var list = [Degree]()
    list = [
        Degree(none: "학력무관", college: "2-3년졸업", university: "4년제졸업", graduateSchool: "석사졸업", doctorate: "박사졸업", header: "학력")
    ]
    
    return list
}


struct PlatForm {
    let first: String
    let second: String
    let header: String?
}

func generatePlatFormList() -> [PlatForm] {
    var list = [PlatForm]()
    list = [
        PlatForm(first: "전체", second: "정규직", header: "근무 형태"),
        PlatForm(first: "계약직", second: "전환형 인턴", header: nil),
        PlatForm(first: "체험형 인턴", second: "기타", header: nil)
    ]
    
    return list
}


