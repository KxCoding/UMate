//
//  Extension.swift
//  UMate
//
//  Created by 황신택 on 2021/09/17.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// 문자열을 정규식으로 검증합니다.
    /// - Parameter email: 사용자 이메일
    /// - Returns: 정규식에서 검증 되면 true 아니면 false 입니다.
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        
        return false
    }


   
    
    /// 문자열을 정규식으로 검증합니다.
    /// - Parameter password: 사용자 패스워드
    /// - Returns: 정규식에서 검증 되면 true 아니면 false 입니다.
    func isPasswordValid(_ password : String) -> Bool{
        if let range = password.range(of: Regex.password, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (password.startIndex, password.endIndex) {
            return true
        }
        
        return false
    }

}


