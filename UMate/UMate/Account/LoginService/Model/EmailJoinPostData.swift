//
//  EmailJoinPostData.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/17.
//

import Foundation


/// 회원가입 POST 모델
/// - Author: 장현우(heoun3089@gmail.com)
struct EmailJoinPostData: Codable {
    
    /// 이메일
    let email: String
    
    /// 비밀번호
    let password: String
    
    /// 유저 이름
    let userName: String
    
    /// 닉네임
    let nickName: String
    
    /// 입학 연도
    let yearOfAdmission: String
}
