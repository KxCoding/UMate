//
//  LoginResponse.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/18.
//

import Foundation


/// 계정 관련 기본 서버 응답 타입
/// - Author: 장현우(heoun3089@gmail.com)
protocol CommonAccountResponseType {
    
    /// 유저 ID
    var userId: String? { get }
    
    /// 유저 이메일
    var email: String? { get }
    
    /// 토큰
    var token: String? { get }
    
    /// 유저 이름
    var realName: String? { get }
    
    /// 닉네임
    var nickName: String? { get }
    
    /// 대학교 이름
    var universityName: String? { get }
    
    /// 입학 연도
    var yearOfAdmission: String? { get }
}



/// 로그인 관련 서버 응답 모델
/// - Author: 장현우(heoun3089@gmail.com)
struct LoginResponse: Codable, CommonResponseType, CommonAccountResponseType {
    
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
    let realName: String?
    
    /// 닉네임
    let nickName: String?
    
    /// 대학교 이름
    var universityName: String?
    
    /// 입학 연도
    let yearOfAdmission: String?
}
