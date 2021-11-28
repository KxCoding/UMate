//
//  Request.swift
//  UMate
//
//  Created by 남정은 on 2021/11/03.
//

import Foundation


/// 강의평 서버에 저장할 때 사용
/// - Author: 남정은(dlsl7080@gmail.com)
struct LectureReviewPostData: Codable {
    /// 강의평 Id
    let lectureReviewId: Int
    
    /// 강의정보 Id
    let lectureInfoId: Int
    
    /// 과제 빈도
    let assignment: Int
    
    /// 조모임 빈도
    let groupMeeting: Int
    
    /// 평가 기준
    let evaluation: Int
    
    /// 출결 방법
    let attendance: Int
    
    /// 시험 횟수
    let testNumber: Int
    
    /// 총평 점수
    let rating: Int
    
    /// 수강학기
    let semester: String
    
    /// 강의평 내용
    let content: String
    
    /// 등록 일자
    let createdAt: String
}


/// 시험정보 서버에 저장할 때 사용
/// - Author: 남정은(dlsl7080@gmail.com)
struct TestInfoPostData: Codable {
    /// 시험정보 Id
    let testInfoId: Int
    
    /// 강의정보 Id
    let lectureInfoId: Int
    
    /// 수강학기
    let semester: String
    
    /// 시험 종류
    let testType: String
    
    /// 시험 전략
    let testStrategy: String
    
    /// 문제 유형
    let questionTypes: String
    
    /// 문제 예시
    let examples: [String]
    
    /// 등록 일자
    let createdAt: String
}
