//
//  CommonConstant.swift
//  CommonConstant
//
//  Created by 안상희 on 2021/08/06.
//

import Foundation


/// 정규식
/// - Author: 안상희
struct Regex {
    /// 사용자의 이메일 주소를 검증하기 위한 정규식.
    static let email = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    
    /// 사용자의 아이디를 검증하기 위한 정규식.
    ///
    /// 영문 소문자로 시작하는 아이디, 길이는 5~15자, 끝날 때 제한이 없습니다.
    static let id = "^[a-z]{5,15}/g"
    
    /// 사용자의 비밀번호를 검증하기 위한 정규식.
    ///
    /// 최소 8 자, 대문자 하나 이상, 소문자 하나, 숫자 하나 및 특수 문자 하나 이상입니다.
    static let password = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}"#
}
