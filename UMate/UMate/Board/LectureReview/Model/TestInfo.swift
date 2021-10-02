//
//  TestInfo.swift
//  UMate
//
//  Created by 남정은 on 2021/09/16.
//

import Foundation


/// 시험정보 모델 클래스
/// - Author: 남정은(dlsl7080@gmail.com)
class TestInfo {
    /// 수강학기
    let semester: String
    
    /// 시험종류
    let testType: String
    
    /// 시험전략
    let testStrategy: String
    
    /// 문제유형을 담는 배열
    let questionTypes: [String]
    
    /// 문제예시를 담는 배열
    let examples:  [String]
    
    
    init(semester: String, testType: String, testStrategy: String, questionTypes: [String], examples: [String]) {
        self.semester = semester
        self.testType = testType
        self.testStrategy = testStrategy
        self.questionTypes = questionTypes
        self.examples = examples
    }
}


