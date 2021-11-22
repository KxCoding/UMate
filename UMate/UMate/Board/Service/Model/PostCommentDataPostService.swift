//
//  PostService.swift
//  UMate
//
//  Created by Chris Kim on 2021/11/21.
//

import Foundation
import Moya


class PostDataService {
    static let shared = PostDataService()
    private init() { }
    
    /// 네트워크 통신 관리 공유 객체
    ///
    /// 셀마다 객체를 만들지 않고 동일한 객체에 접근하도록 합니다.
    let provider = MoyaProvider<ScrapInfoService>()
}



/// 게시물 '공감' 및 '스크랩' 정보 서비스
enum ScrapInfoService {
    case saveScrapInfo(ScrapPostData)
    case saveLikeInfo(LikePostData)
}



extension ScrapInfoService: TargetType {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://umateserverboard.azurewebsites.net")!
    }
    
    /// 기본 URL제외한 경로
    var path: String {
        switch self {
        case .saveScrapInfo:
            return "/api/scrapPost"
        case .saveLikeInfo:
            return "/api/likePost"
        }
    }
    
    /// HTTP요청 메소드
    var method: Moya.Method {
        return .post
    }
    
    /// HTTP 작업
    var task: Task {
        switch self {
        case .saveScrapInfo(let scrapPostData):
            return .requestJSONEncodable(scrapPostData)
        case .saveLikeInfo(let likePostData):
            return .requestJSONEncodable(likePostData)
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



/// 게시물 저장 서비스
enum PostSaveService {
    case uploadPost(PostPostData)
}



extension PostSaveService: TargetType {
    
    /// 기본 URL
    var baseURL: URL {
        URL(string: "https://umateserverboard.azurewebsites.net")!
    }
    
    /// 기본 URL 제외한 경로
    var path: String {
        return "/api/boardPost"
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        return .post
    }
    
    /// HTTP 작업
    var task: Task {
        switch self {
        case .uploadPost(let postPostData):
            return .requestJSONEncodable(postPostData)
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



/// 댓글 저장 서비스
enum CommentSaveService {
    case saveComment(CommentPostData)
}



extension CommentSaveService: TargetType {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://umateserverboard.azurewebsites.net")!
    }
    
    /// 기본 URL 제외한 경로
    var path: String {
        return "/api/comment"
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        return .post
    }
    
    /// HTTP 작업
    var task: Task {
        switch self {
        case .saveComment(let commentPostData):
            return .requestJSONEncodable(commentPostData)
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



class CommentDataService {
    static let shared = CommentDataService()
    private init() { }
    
    let provider = MoyaProvider<CommentLikeService>()
}


/// 댓글 '좋아요' 저장 서비스
enum CommentLikeService {
    case saveCommentLikeData(LikeCommentPostData)
}



extension CommentLikeService: TargetType {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://board1104.azurewebsites.net")!
    }
    
    /// 기본 URL 제외한 경로
    var path: String {
        return "/api/likeComment"
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        return .post
    }
    
    /// HTTP 작업
    var task: Task {
        switch self {
        case .saveCommentLikeData(let likeCommentPostData):
            return .requestJSONEncodable(likeCommentPostData)
        }
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
