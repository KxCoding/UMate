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
    
    case professorExists = 2000;
    case lectureInfoExists = 2001;
    case lectureReviewExists = 2002;
    case testInfoExists = 2003;
}



///  공통 응답 데이터
/// - Author: 남정은(dlsl7080@gmail.com)
struct CommonResponse: Codable {
    let code: Int
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
    let code: Int
    let message: String?
}



/// 게시물 목록 화면
/// - Author: 남정은(dlsl7080@gmail.com)
struct PostListDtoResponseData: Codable {
    let totalCount: Int
    
    struct PostDto: Codable {
        let postId: Int
        let userId: String
        let userName: String?
        
        let title: String
        let content: String
        
        var likeCnt: Int
        var commentCnt: Int
        var scrapCnt: Int
        let categoryNumber: Int
        var createdAt: String
        var dateStr: String? {
            return BoardDataManager.shared.decodingFormatter.date(from: createdAt)?.relativeDate
        }
    }
    
    let list: [PostDto]
    let code: Int
    let message: String?
}



/// 게시물 상세 정보 화면
/// - Author: 남정은(dlsl7080@gmail.com)
struct PostDtoResponseData: Codable {
    struct Post: Codable {
        let postId: Int
        
        let userId: String
        let userName: String?
        let profileUrl: String?
        
        let boardId: Int
        
        let title: String
        let content: String
        let likeCnt: Int
        let commentCnt: Int
        let scrapCnt: Int
        let categoryNumber: Int
        var createdAt: String
        var dateStr: String? {
            return BoardDataManager.shared.decodingFormatter.date(from: createdAt)?.detailPostDate
        }
    }
    
    var post: Post
    let isLiked: Bool
    let isScrapped: Bool
    let scrapPostId: Int
    let code: Int
    let message: String?
}



/// 해당 게시물에 포함된 댓글 목록
/// - Author: 남정은(dlsl7080@gmail.com)
struct CommentListResponseData: Codable {
    let lastId: Int
    
    struct Comment: Codable {
        let commentId: Int
        
        let userId: String
        let userName: String?
        let profileUrl: String?
        
        let postId: Int
        var content: String
        var likeCnt: Int
        let originalCommentId: Int
        let isReComment: Bool
        var createdAt: String
        let updatedAt: String
        var dateStr: String? {
            return BoardDataManager.shared.decodingFormatter.date(from: createdAt)?.commentDate
        }
    }
    
    let list: [Comment]
    let code: Int
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
    let code: Int
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
    let code: Int
    let message: String?
}



// MARK: - POST Response
/// 게시물 저장 응답데이터
/// - Author: 남정은(dlsl7080@gmail.com)
struct SavePostResponseData: Codable {
    struct Post: Codable {
        let postId: Int
        
        let userId: String
        let userName: String?
        let profileUrl: String?
        
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
    let code: Int
    let message: String?
}



/// 댓글 저장 응답데이터
/// - Author: 김정민(kimjm010@icloud.com)
struct SaveCommentResponseData: Codable {
    struct Comment: Codable {
        let commentId: Int
        
        let userId: String
        let userName: String?
        let profileUrl: String?
        
        let postId: Int
        
        var content: String
        var likeCnt: Int
        let originalCommentId: Int
        let isReComment: Bool
        let createdAt: String
        let updatedAt: String
    }
    
    let comment: Comment
    let code: Int
    let message: String?
}



/// 댓글 좋아요 저장 응답데이터
/// - Author: 김정민(kimjm010@icloud.com)
struct SaveLikeCommentResponseData: Codable {
    struct LikeComment: Codable {
        let likeCommentId: Int
        let userId: String
        let commentId: Int
        let createdAt: String
        let updatedAt: String
    }
    
    let likeComment: LikeComment?
    let code: Int
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
    let code: Int
    let message: String?
}

