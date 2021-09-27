//
//  CompanyModel.swift
//  CompanyModel
//
//  Created by 황신택 on 2021/09/15.
//

import Foundation

enum ItemType {
    case work(ClassificationWork)
    case region(ClassificationRegion)
    case degree(ClassificationDegree)
    case career(ClassificationCareer)
    case platForm(ClassificationPlatForm)
}

/// 직무 형태 구분을 위한 구조체
/// Author: 황신택
class ClassificationWork {
     init(title: String) {
        self.title = title
    }
    let title: String
}

class ClassificationRegion {
     init(title: String) {
        self.title = title
    }
    
    let title: String
}

class ClassificationDegree {
     init(title: String) {
        self.title = title
    }
    let title: String
}

class ClassificationCareer {
     init(title: String) {
        self.title = title
    }
    let title: String
}

class ClassificationPlatForm {
     init(title: String) {
        self.title = title
     }
    let title: String
}


/// 작업할 뷰컨트롤러를 위해서 타입을 배열로 리턴.
/// Author: 황신택
func generateClassificationModelList() -> [ItemType] {
    var list = [ItemType]()
    list = [
        .work(ClassificationWork(title: "직무")),
        .region(ClassificationRegion(title: "지역")),
        .degree(ClassificationDegree(title: "학력")),
        .career(ClassificationCareer(title: "경력")),
        .platForm(ClassificationPlatForm(title: "직무형태"))
    ]
    
    return list
}


/// 회사 정보입력을 위한 구조체
/// Author: 황신택

enum FieldType: String {
    case sales
    case planning
    case advertisement
    case Distribution
    case it
}


class Company {
     init(popular: String, field: FieldType, title: String, detail: String, image: String, favoriteImage: String, day: String) {
        self.popular = popular
        self.field = field
        self.title = title
        self.detail = detail
        self.image = image
        self.favoriteImage = favoriteImage
        self.day = day
    }
    
    let popular: String
    let field: FieldType
    let title: String
    let detail: String
    let image: String
    let favoriteImage: String
    let day: String
    
}


/// 작업할 뷰컨트롤러를 위해서 타입을 배열로 리턴.
/// Author: 황신택
func generateCompanyList() -> [Company] {
    var list = [Company]()
    
    list = [
        Company(popular: "인기", field: FieldType.it, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.Distribution, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.advertisement, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.planning, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.sales, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.it, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.it, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.Distribution, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.advertisement, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.planning, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.sales, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14"),
        Company(popular: "인기", field: FieldType.it, title: "엔씨소프트", detail: "사내 정보시스템 back-end 개발자 모집", image: "building.2.crop.circle", favoriteImage: "star", day: "D-14")
      
        
    ]
    
    return list
}
