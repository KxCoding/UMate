//
//  EmailLoginPostData.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/18.
//

import Foundation


/// 로그인 POST 모델
/// - Author: 장현우(heoun3089@gmail.com)
struct EmailLoginPostData: Codable {
    
    /// 이메일
    let email: String
    
    /// 비밀번호
    let password: String
}
