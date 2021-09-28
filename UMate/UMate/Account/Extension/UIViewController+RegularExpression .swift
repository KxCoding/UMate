//
//  Extension.swift
//  UMate
//
//  Created by 황신택 on 2021/09/17.
//

import Foundation
import UIKit

/// 공통적으로  중복으로 사용하는 메소드들.
/// Author: 황신택
extension UIViewController {
    ///  regular expression으로 이메일을 검증하는 메소드
    /// - Parameter email: String
    /// - Returns: Bool
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        return false
    }

    
    /// 레귤러 익스프레션을 사용하여 암호 검증.
    /// - Parameter password: String
    /// - Returns: Bool
    func isPasswordValid(_ password : String) -> Bool{
        if let range = password.range(of: Regex.password, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (password.startIndex, password.endIndex) {
            return true
        }
        return false
    }

   
}


