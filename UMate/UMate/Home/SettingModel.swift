//
//  SettingModel.swift
//  SettingModel
//
//  Created by 황신택 on 2021/07/23.
//

import Foundation
import UIKit

struct Profile {
    let profileImage: UIImage?
    let id: String?
    let name: String
    let nickName: String?
    let university: String
    let entranceYear: String
}


enum CellType: String {
    case account
    case community
    case appConfig
    case information
    case etc
}


class PersonalItems {
    let content: String
    let type: CellType
    
    init(content: String, type: CellType) {
        self.content = content
        self.type = type
    }
    
}

class PersonalSections {
    let items: [PersonalItems]
    let header: String?
    let footer: String?
    
    init(items: [PersonalItems], header: String?, footer: String? = nil) {
        self.header = header
        self.footer = footer
        self.items = items
    }
    
    static func generateDataModel() -> [PersonalSections] {
        return [
            PersonalSections(items: [
                PersonalItems(content: "학교인증", type: .account),
                PersonalItems(content: "비밀번호 변경", type: .account),
                PersonalItems(content: "이메일 변경", type: .account),
            ], header: "계정", footer: nil),
            
            PersonalSections(items: [
                PersonalItems(content: "닉네임 설정", type: .community),
                PersonalItems(content: "프로필 이미지 변경", type: .community),
                PersonalItems(content: "이용 제한 내역", type: .community),
                PersonalItems(content: "커뮤니티 이용규칙", type: .community)
            ], header: "커뮤니티", footer: nil),
            
            PersonalSections(items: [
                PersonalItems(content: "다크 모드", type: .appConfig),
                PersonalItems(content: "알림 설정", type: .appConfig),
                PersonalItems(content: "암호 잠금", type: .appConfig),
                PersonalItems(content: "캐시 삭제", type: .appConfig)
            ], header: "앱 설정", footer: nil),
        
            PersonalSections(items: [
                PersonalItems(content: "앱 버전", type: .information),
                PersonalItems(content: "문의하기", type: .information),
                PersonalItems(content: "공지사항", type: .information),
                PersonalItems(content: "서비스 이용약관", type: .information),
                PersonalItems(content: "개인정보 처리방침", type: .information),
                PersonalItems(content: "오픈소스 라이선스", type: .information)
            ], header: "이용 안내", footer: nil),
            
            PersonalSections(items: [
                PersonalItems(content: "정보 동의 설정", type: .etc),
                PersonalItems(content: "회원 탈톼", type: .etc),
                PersonalItems(content: "로그아웃", type: .etc),
            ], header: "기타", footer: nil),
        
        ]
    }
}


