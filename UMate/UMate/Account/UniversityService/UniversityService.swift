//
//  UniversityService.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/28.
//

import Foundation
import Moya


/// 대학교 네트워크 요청 서비스
/// - Author: 장현우(heoun3089@gmail.com)
enum UniversityService {
    case universityList
}



extension UniversityService: TargetType, AccessTokenAuthorizable {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://umateloginserver.azurewebsites.net")!
    }
    
    /// 기본 URL을 제외한 나머지 경로
    var path: String {
        return "/api/university"
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        return .get
    }
    
    /// HTTP 작업 유형
    var task: Task {
        return .requestPlain
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    /// 인증 타입
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
