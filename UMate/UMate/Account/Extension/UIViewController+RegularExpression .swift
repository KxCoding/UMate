//
//  Extension.swift
//  UMate
//
//  Created by 황신택 on 2021/09/17.
//

import Foundation
import UIKit

/// 반복적으로 사용하는 메소드를 구현한 익스텐션
/// Author: 황신택
extension UIViewController {
    ///  레귤러 익스프레션으로  이메일을 검증하는 메소드
    /// - Parameter email: 전달된 파라미터를 레귤러 익스프레션으로 바인딩 하고 대 소문자  및 처음 문자 와 끝을 비교합니다.
    /// - Returns: 유저 이메일이 정상적인 이메일 형식인지 아닌지 true or false로 리턴합니다.
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        return false
    }

    
    /// 레귤러 익스프레션으로 패스워드를 검증하는 메소드
    /// - Parameter password: 전달된 파라미터를 레귤러 익스프레션으로 바인딩 하고 대 소문자  및 처음 문자 와 끝을 비교합니다.
    /// - Returns: 유저 패스워드가 정상적인 패스워드 형식인지 아닌지 true or false로 리턴합니다.
    func isPasswordValid(_ password : String) -> Bool{
        if let range = password.range(of: Regex.password, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (password.startIndex, password.endIndex) {
            return true
        }
        return false
    }

   
}


