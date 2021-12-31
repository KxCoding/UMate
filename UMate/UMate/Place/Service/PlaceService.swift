//
//  PlaceService.swift
//  UMate
//
//  Created by Effie on 2021/11/30.
//

import Foundation
import Moya


/// 네트워크 요청 서비스
/// - Author: 박혜정(mailmelater11@gmail.com)
enum PlaceService {
    case allPlaceList
    case universityPlaceList(Int)
    case placeInfo(Int)
    
    case bookmarkList
    case ifBookmarked(Int)
    case postBookmark(PlaceBookmarkPostData)
    case deleteBookmark(Int)
}



extension PlaceService: TargetType, AccessTokenAuthorizable {
    
    /// 기본 url
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    /// 나머지 경로
    var path: String {
        switch self {
        case .allPlaceList:
            return "/api/place"
        case .universityPlaceList(let universityId):
            return "/api/place/university/\(universityId)"
        case .placeInfo(let placeId):
            return "/api/place/\(placeId)"
        case .bookmarkList:
            return "/api/place/bookmark"
        case .ifBookmarked(let placeId):
            return "/api/place/bookmark/place/\(placeId)"
        case .postBookmark:
            return "/api/place/bookmark"
        case .deleteBookmark(let placeId):
            return "/api/place/bookmark/place/\(placeId)"
        }
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        switch self {
        case .allPlaceList, .universityPlaceList, .placeInfo, .bookmarkList, .ifBookmarked:
            return .get
        case .postBookmark:
            return .post
        case .deleteBookmark:
            return .delete
        }
    }
    
    /// HTTP 작업 유형
    var task: Task {
        switch self {
        case .allPlaceList, .bookmarkList:
            return .requestPlain
        case .universityPlaceList(let universityId):
            return .requestParameters(parameters: ["universityId": universityId],
                                      encoding: URLEncoding.queryString)
        case .placeInfo(let placeId):
            return .requestParameters(parameters: ["placeId": placeId],
                                      encoding: URLEncoding.queryString)
        case .ifBookmarked(let placeId):
            return .requestParameters(parameters: ["placeId": placeId],
                                      encoding: URLEncoding.queryString)
        case .postBookmark(let postData):
            return .requestJSONEncodable(postData)
        case .deleteBookmark(let placeId):
            return .requestParameters(parameters: ["placeId": placeId],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    /// HTTP 요청 헤더
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    /// 인증 타입
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
