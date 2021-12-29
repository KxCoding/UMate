//
//  TimetableService.swift
//  UMate
//
//  Created by 안상희 on 2021/12/29.
//

import Foundation
import RxSwift
import NSObject_Rx
import Moya


/// 시간표 서비스
/// Author: 안상희
enum TimetableService {
    /// POST
    case postTimetable(TimetablePostData)
    
    /// GET
    case getTimetable
    
    /// DELETE
    case deleteTimetable(Int)
}



extension TimetableService: TargetType, AccessTokenAuthorizable {
    /// Base URL
    var baseURL: URL {
        return URL(string: "https://umate-api.azurewebsites.net/")!
    }
    
    /// 요청 경로
    var path: String {
        switch self {
        case .postTimetable, .getTimetable:
            return "timetable"
        case .deleteTimetable(let timetableId):
            return "timetable/\(timetableId)"
        }
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        switch self {
        case .postTimetable:
            return .post
        case .getTimetable:
            return .get
        case .deleteTimetable:
            return .delete
        }
    }
    
    /// HTTP 작업 유형
    var task: Task {
        switch self {
        case .postTimetable(let timetablePostData):
            return .requestJSONEncodable(timetablePostData)
        case .getTimetable:
            return .requestPlain
        case .deleteTimetable:
            return .requestPlain
        }
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        if let token = LoginDataManager.shared.loginKeychain.get(AccountKeys.apiToken.rawValue) {
            return ["Content-Type": "application/json", "Authorization":"Bearer \(token)"]
        }
        return nil
    }
    
    
    /// 인증 타입
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}

