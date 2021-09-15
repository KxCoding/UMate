//
//  CompanyModel.swift
//  CompanyModel
//
//  Created by 황신택 on 2021/09/15.
//

import Foundation

/// 직무 형태 구분을 위한 구조체
struct Classification {
    let title: String
    let detail: String
}

/// 회사 정보입력을 위한 구조체
struct Company {
    let popular: String
    let field: String
    let title: String
    let detail: String
    let image: String
    let favoriteImage: String
    let day: String
    
}

/// 작업할 뷰컨트롤러를 위해서 메소드화시킴
func generateClassificationModelList() -> [Classification] {
    var list = [Classification]()
    list = [
        Classification(title: "직무:", detail: " 전체"),
        Classification(title: "지역:", detail: " 전체"),
        Classification(title: "학력:", detail: " 전체"),
        Classification(title: "경력:", detail: " 전체"),
        Classification(title: "근무형태:", detail: " 전체")
    
    ]
    
    return list
}

/// 작업할 뷰컨트롤러를 위해서 메소드화시킴
func generateCompanyList() -> [Company] {
    var list = [Company]()
    
    list = [
        Company(popular: "인기", field: "IT.SW", title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: "IT.SW", title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: "IT.SW", title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: "IT.SW", title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: "IT.SW", title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: "IT.SW", title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: "IT.SW", title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14")
        
    ]
    
    return list
}
