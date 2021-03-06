//
//  UIVIewContoller+RegularExpression.swift
//  UMate
//
//  Created by 황신택 on 2021/12/01.
//

import Foundation
import UIKit


/// 이메일 / 비밀번호 정규식 검증 익스텐션
/// - Author: 황신택 (sinadsl1457@gmail.com)
extension UIViewController {
    /// 이메일 주소의 형식을 검증합니다.
    /// - Parameter email: 사용자 이메일
    /// - Returns: 검증에 성공하면 true, 실패하면 false를 리턴합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        return false
    }

       
    /// 암호 문자열의 형식을 검증합니다.
    /// - Parameter password: 사용자 암호
    /// - Returns: 검증에 성공하면 true, 실패하면 false를 리턴합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func isPasswordValid(_ password : String) -> Bool{
        if let range = password.range(of: Regex.password, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (password.startIndex, password.endIndex) {
            return true
        }
        return false
    }
}
