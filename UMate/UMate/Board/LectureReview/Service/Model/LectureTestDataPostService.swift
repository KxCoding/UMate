//
//  PostService.swift
//  UMate
//
//  Created by Chris Kim on 2021/11/22.
//

import Foundation
import Moya


/// 강의평 저장 서비스
enum LectureReviewSaveService {
    case saveLectureReviewData(LectureReviewPostData)
}



extension LectureReviewSaveService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://umateserverboard.azurewebsites.net")!
    }
    
    /// 기본 URL 제외한 경로
    var path: String {
        return "/api/lectureReview"
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        return .post
    }
    
    /// HTTP 작업
    var task: Task {
        switch self {
        case .saveLectureReviewData(let lectureReviewPostData):
            return .requestJSONEncodable(lectureReviewPostData)
        }
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        if let token = LoginDataManager.shared.loginKeychain.get(AccountKeys.apiToken.rawValue) {
            return ["Content-Type": "application/json", "Authorization":"Bearer \(token)"]
        }
        return nil
    }
}



/// 시험 정보 저장 서비스
enum TestInfoSaveService {
    case saveTestInfoData(TestInfoPostData)
}



extension TestInfoSaveService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://umateserverboard.azurewebsites.net")!
    }
    
    /// 기본 URL 제외한 경로
    var path: String {
        return "/api/testInfo"
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        return .post
    }
    
    /// HTTP 작업
    var task: Task {
        switch self {
        case .saveTestInfoData(let testInfoPostData):
            return .requestJSONEncodable(testInfoPostData)
        }
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        if let token = LoginDataManager.shared.loginKeychain.get(AccountKeys.apiToken.rawValue) {
            return ["Content-Type": "application/json", "Authorization":"Bearer \(token)"]
        }
        return nil
    }
}
