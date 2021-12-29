//
//  Response.swift
//  UMate
//
//  Created by 남정은 on 2021/11/03.
//

import Foundation


/// 최근 강의평 화면
/// - Author: 남정은(dlsl7080@gmail.com)
struct LectureInfoListResponseData: Codable {
    struct LectureInfo:Codable {
        /// 강의정보 Id
        let lectureInfoId: Int
        
        /// 강의명
        let title: String
        
        /// 교수명
        let professor: String
        
        /// 최신 리뷰 Id
        let reviewId: Int
        
        /// 수강학기
        var semester: String?
        
        /// 평점
        var rating: Int?
        
        /// 강의평 내용
        var content: String?
    }
    
    let totalCount: Int
    let list: [LectureInfo]
    let code: Int
    let message: String?
}


/// 강의 정보화면
/// - Author: 남정은(dlsl7080@gmail.com)
struct LectureInfoDetailResponse: Codable {
    struct LectrueInfo: Codable {
        /// 강의정보 Id
        let lectureInfoId: Int
        
        /// 교수 Id
        let professorId: Int
        
        /// 강의명
        let title: String
        
        /// 교재명
        let bookName: String
        
        /// 교재링크
        let bookLink: String
        
        /// 수강학기
        let semesters: String
    }
    
    let lectureInfo: LectrueInfo
    let code: Int
    let message: String?
}


/// 강의 정보에 포함된 강의평리스트
/// - Author: 남정은(dlsl7080@gmail.com)
struct LectureReviewListResponse: Codable {
    struct LectureReview: Codable {
        /// 강의평 Id
        var lectureReviewId: Int
        
        /// 사용자 Id
        let userId: String
        
        /// 강의정보 Id
        let lectureInfoId: Int
        
        /// 과제 빈도
        let assignment: Int
        
        /// 조모임 빈도
        let groupMeeting: Int
        
        /// 평가 기준
        let evaluation: Int
        
        /// 출결 방식
        let attendance: Int
        
        /// 시험 횟수
        let testNumber: Int
        
        /// 평점
        let rating: Int
        
        /// 수강학기
        let semester: String
        
        /// 강의평 내용
        let content: String
        
        /// 등록 일자
        let createdAt: String
        
        struct ReviewResponseData {
            var responseData: LectureReviewListResponse.LectureReview
        }
    }
    
    var lectureReviews: [LectureReview]
    let code: Int
    let message: String?
}


/// 강의정보에 포함된 시험정보리스트
/// - Author: 남정은(dlsl7080@gmail.com)
struct TestInfoListResponse: Codable {
    struct TestInfo: Codable {
        /// 시험정보 Id
        let testInfoId: Int
        
        /// 사용자 Id
        let userId: String
        
        /// 강의정보 Id
        let lectureInfoId: Int
        
        /// 수강학기
        let semester: String
        
        /// 시험종류
        let testType: String
        
        /// 시험전략
        let testStrategy: String
        
        /// 문제 유형
        let questionTypes: String
        
        struct Example: Codable {
            /// 문제 예시 Id
            let exampleId: Int
            
            /// 시험 정보 Id
            let testInfoId: Int
            
            /// 문제 예시
            let content: String
        }
        let examples:  [Example]
        
        /// 등록일자
        let createdAt: String
    }

    var testInfos: [TestInfo]
    let code: Int
    let message: String?
}


/// 시험정보 저장 응답데이터
/// - Author: 남정은(dlsl7080@gmail.com)
struct SaveTestInfoResponseData: Codable {
    struct TestInfo: Codable {
        /// 시험정보 Id
        let testInfoId: Int
        
        /// 사용자 Id
        let userId: String
        
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
        
        /// 등록 일자
        let createdAt: String
    }
    
    struct Example: Codable {
        /// 문제 예시 Id
        let exampleId: Int
        
        /// 시험정보 Id
        let testInfoId: Int
        
        /// 문제 예시
        let content: String
    }
    
    let testInfo: TestInfo
    let examples: [Example]
    let code: Int
    let message: String?
}


/// 강의평 저장 응답데이터
/// - Author: 남정은(dlsl7080@gmail.com)
struct SaveLectureReviewResponseData: Codable {
    struct LectureReview: Codable {
        /// 강의평 Id
        let lectureReviewId: Int
        
        /// 사용자 Id
        let userId: String
        
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
        
        /// 평점
        let rating: Int
        
        /// 수강 학기
        let semester: String
        
        /// 강의평 내용
        let content: String
        
        /// 등록 일자
        let createdAt: String
    }
    
    let lectureReview: LectureReview
    let code: Int
    let message: String?
}
