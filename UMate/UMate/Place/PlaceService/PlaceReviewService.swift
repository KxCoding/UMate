//
//  PlaceReviewService.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/28.
//

import Foundation
import Moya


/// 상점 리뷰 네트워크 요청 서비스
/// - Author: 장현우(heoun3089@gmail.com)
enum PlaceReviewService {
    case allPlaceReivewList
    case placeReviewList
    case savePlaceReview(PlaceReviewPostData)
    case editPlaceReview(PlaceReviewPutData)
    case removePlaceReview(Int)
}



extension PlaceReviewService: TargetType, AccessTokenAuthorizable {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://umateplacereviewserver.azurewebsites.net")!
    }
    
    /// 기본 URL을 제외한 나머지 경로
    var path: String {
        switch self {
        case .allPlaceReivewList:
            return "/allplacereview"
        case .placeReviewList, .savePlaceReview:
            return "/placereview"
        case .editPlaceReview(let placeReviewPutData):
            return "/placereview/\(placeReviewPutData.placeReviewId)"
        case .removePlaceReview(let id):
            return "/placereview/\(id)"
        }
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        switch self {
        case .allPlaceReivewList, .placeReviewList:
            return .get
        case .savePlaceReview:
            return .post
        case .editPlaceReview:
            return .put
        case .removePlaceReview:
            return .delete
        }
    }
    
    /// HTTP 작업 유형
    var task: Task {
        switch self {
        case .allPlaceReivewList, .placeReviewList, .removePlaceReview:
            return .requestPlain
        case .savePlaceReview(let placeReviewPostData):
            return .requestJSONEncodable(placeReviewPostData)
        case .editPlaceReview(let placeReviewPutData):
            return .requestJSONEncodable(placeReviewPutData)
        }
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
