//
//  BoardService.swift
//  UMate
//
//  Created by 남정은 on 2021/11/22.
//

import Foundation
import RxSwift
import NSObject_Rx
import Moya


/// 게시판 네트워크 요청 서비스
/// - Author: 남정은(dlsl7080@gmail.com)
enum BoardService {
    /// GET
    case boardList
    case postList(Int)
    case detailPost(Int)
    case postImageList(Int)
    case commentList(Int)
    case likeCommentList
    
    case recentLectureReviewList(Int, Int)
    case detailLectureInfo(Int)
    case lectureReviewList(Int)
    case testInfoList(Int)
    
    
    /// DELETE
    case deleteComment(Int)
    case deletePost(Int)
    case deleteScrapPost(Int)
    case deleteLikeComment(Int)
}



extension BoardService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var baseURL: URL {
        return URL(string: "https://umate-api.azurewebsites.net")!
    }
    
    var path: String {
        switch self {
        case .boardList:
            return "/api/board"
        case .postList:
            return "/api/boardPost"
        case .detailPost(let postId):
            return "/api/boardPost/\(postId)"
        case .postImageList:
            return "/api/image"
        case .commentList:
            return "/api/comment"
        case .likeCommentList:
            return "/api/likeComment"
        case .deleteComment(let commentId):
            return "/api/comment/\(commentId)"
        case .deletePost(let postId):
            return "/api/boardpost/\(postId)"
        case .deleteScrapPost(let scrapPostId):
            return "/api/scrapPost/\(scrapPostId)"
        case .deleteLikeComment(let likeCommentId):
            return "/api/likeComment/\(likeCommentId)"
            
            
        /// 강의평가
        case .recentLectureReviewList:
            return "/api/lectureInfo"
        case .detailLectureInfo(let lectureInfoId):
            return "/api/lectureInfo/\(lectureInfoId)"
        case .lectureReviewList:
            return "/api/lectureReview"
        case .testInfoList:
            return "/api/testInfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        /// 게시판
        case .boardList, .postList, .detailPost, .postImageList, .commentList, .likeCommentList:
            return .get
        case .deletePost, .deleteComment, .deleteScrapPost, .deleteLikeComment:
            return .delete
            
            
        /// 강의평가
        case .recentLectureReviewList, .detailLectureInfo, .lectureReviewList, .testInfoList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        /// 게시판
        case .boardList, .likeCommentList, .detailPost:
            return .requestPlain
        case .postList(let boardId):
            return .requestParameters(parameters: ["boardId": boardId], encoding: URLEncoding.queryString)
        case .postImageList(let postId), .commentList(let postId):
            return .requestParameters(parameters: ["postId": postId], encoding: URLEncoding.queryString)
            
        case .deletePost(let postId), .deleteScrapPost(let postId):
            return .requestParameters(parameters: ["postId": postId], encoding: URLEncoding.queryString)
        case .deleteComment(let commentId), .deleteLikeComment(let commentId):
            return .requestParameters(parameters: ["commentId": commentId], encoding: URLEncoding.queryString)
        
            
        /// 강의평가
        case .detailLectureInfo(_):
            return .requestPlain
        case .recentLectureReviewList(let lecturePage, let lecturePageSize):
            return .requestParameters(parameters: ["page": lecturePage, "pageSize": lecturePageSize], encoding: URLEncoding.queryString)
        case .lectureReviewList(let lectureInfoId), .testInfoList(let lectureInfoId):
            return .requestParameters(parameters: ["lectureInfoId": lectureInfoId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        if let token = LoginDataManager.shared.loginKeychain.get(AccountKeys.apiToken.rawValue) {
            return ["Content-Type": "application/json", "Authorization":"Bearer \(token)"]
        }
        return nil
    }
}
