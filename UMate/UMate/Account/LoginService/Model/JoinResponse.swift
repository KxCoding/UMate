//
//  JoinResponse.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/18.
//

import Foundation


/// 회원가입 관련 서버 응답 모델
/// - Author: 장현우(heoun3089@gmail.com)
struct JoinResponse: Codable, CommonResponseType, CommonAccountResponseType {
    
    /// 응답 코드
    var code: Int
    
    /// 서버 메시지
    var message: String?
    
    /// 유저 ID
    var userId: String?
    
    /// 유저 이메일
    var email: String?
    
    /// 토큰
    var token: String?
    
    /// 유저 이름
    let userName: String?
    
    /// 닉네임
    let nickName: String?
    
    /// 입학 연도
    let yearOfAdmission: String?
}
