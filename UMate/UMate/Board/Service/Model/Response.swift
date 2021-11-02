//
//  Response.swift
//  UMate
//
//  Created by 남정은 on 2021/11/01.
//

import Foundation


/// 서버 요청 결과값
/// - Author: 남정은(dlsl7080@gmail.com)
enum ResultCode: Int {
    case ok = 200
    case fail = -999
    case notFound = 404
    
    case boardExists = 1000;
    case categoryExists = 1001;
    case postExists = 1002;
}



///  공통 응답 데이터
/// - Author: 남정은(dlsl7080@gmail.com)
struct CommonResponse: Codable {
    let resultCode: Int
    let message: String?
}



// MARK: - fetch Response
/// 게시판 목록화면
/// - Author: 남정은(dlsl7080@gmail.com)
struct BoardDtoResponseData: Codable {
    struct BoardDto: Codable {
        let boardId: Int
        let section: Int
        let name: String
        
        struct Category: Codable {
            let categoryId: Int
            let boardId: Int
            let name: String
        }
        let categories: [Category]
    }
   
    let list: [BoardDto]
    let resultCode: Int
    let message: String?
}



/// 게시물 목록 화면
/// - Author: 남정은(dlsl7080@gmail.com)
struct PostListDtoResponseData: Codable {
    let totalCount: Int
    
    struct PostDto: Codable {
        let postId: Int
        let title: String
        let content: String
        let createdAt: String
        let userName: String
        let likeCnt: Int
        let commentCnt: Int
        let scrapCnt: Int
        let categoryNumber: Int
    }
    
    let list: [PostDto]
    let resultCode: Int
    let message: String?
}



/// 게시물 상세 정보 화면
/// - Author: 남정은(dlsl7080@gmail.com)
struct PostDtoResponseData: Codable {
    struct Post: Codable {
        let postId: Int
        let userId: String
        let boardId: Int
        let title: String
        let content: String
        let likeCnt: Int
        let commentCnt: Int
        let scrapCnt: Int
        let categoryNumber: Int
        let createdAt: String
    }
    
    let post: Post
    let isLiked: Bool
    let isScrapped: Bool
    let scrapPostId: Int
    let resultCode: Int
    let message: String?
}



/// 해당 게시물에 포함된 댓글 목록
/// - Author: 남정은(dlsl7080@gmail.com)
struct CommentListResponseData: Codable {
    let lastId: Int
    
    struct Comment: Codable {
        let commentId: Int
        let userId: String
        let postId: Int
        var content: String
        var likeCnt: Int
        let originalCommentId: Int
        let isReComment: Bool
        let createdAt: String
        let updatedAt: String
    }
    
    let list: [Comment]
    let resultCode: Int
    let message: String?
}



/// 좋아요한 댓글 목록
/// - Author: 남정은(dlsl7080@gmail.com)
struct LikeCommentListResponse: Codable {
    struct LikeComment: Codable {
        let likeCommentId: Int
        let userId: String
        let commentId: Int
        let createdAt: String
    }
    let list: [LikeComment]
    let resultCode: Int
    let message: String?
}



/// 게시물에 포함된 이미지 목록
/// - Author: 남정은(dlsl7080@gmail.com)
struct ImageListResponseData: Codable {
    struct PostImage: Codable {
        let postImageId: Int
        let postId: Int
        let urlString: String
    }
    
    let list: [PostImage]
    let resultCode: Int
    let message: String?
}



// MARK: - POST Response
/// 게시물 저장 응답데이터
/// - Author: 남정은(dlsl7080@gmail.com)
struct SavePostResponseData: Codable {
    struct Post: Codable {
        let postId: Int
        let userId: String
        let boardId: Int
        let title: String
        let content: String
        let likeCnt: Int
        let commentCnt: Int
        let scrapCnt: Int
        let categoryNumber: Int
        let createdAt: String
    }

    let post: Post
    let resultCode: Int
    let message: String?
}



/// 댓글 저장 응답데이터
/// - Author: 남정은(dlsl7080@gmail.com)
struct SaveCommentResponseData: Codable {
    struct Comment: Codable {
        let commentId: Int
        let userId: String
        let postId: Int
        var content: String
        var likeCnt: Int
        let originalCommentId: Int
        let isReComment: Bool
        let createdAt: String
        let updatedAt: String
    }
    
    let comment: Comment
    let resultCode: Int
    let message: String?
}



/// 댓글 좋아요 저장 응답데이터
/// - Author: 남정은(dlsl7080@gmail.com)
struct SaveLikeCommentResponseData: Codable {
    struct LikeComment: Codable {
        let likeCommentId: Int
        let userId: String
        let commentId: Int
        let createdAt: String
        let updatedAt: String
    }
    
    let likeComment: LikeComment?
    let resultCode: Int
    let message: String?
}



/// 게시글 스크랩 응답데이터
/// - Author: 남정은(dlsl7080@gmail.com)
struct SaveScrapPostPostResponse: Codable {
    struct ScrapPost: Codable {
        let scrapPostId: Int
        let userId: String
        let postId: Int
        let createdAt: String
        let updatedAt: String
    }
    
    let scrapPost: ScrapPost?
    let resultCode: Int
    let message: String?
}

