//
//  Request.swift
//  UMate
//
//  Created by 남정은 on 2021/11/01.
//

import Foundation


/// 게시물 서버에 저장할 때 사용
/// - Author: 남정은(dlsl7080@gmail.com)
struct PostPostData: Codable {
    let postId: Int
    let userId: String
    let boardId: Int
    let title: String
    let content: String
    let categoryNumber: Int
    let urlStrings: [String]
    let createdAt: String
}



/// 댓글을 서버에 저장할 때 사용
/// - Author: 남정은(dlsl7080@gmail.com)
struct CommentPostData: Codable {
    let userId: String
    let postId: Int
    let content: String
    let originalCommentId: Int
    let isReComment: Bool
    let createdAt: String
}



/// 게시글을 스크랩을 서버에 저장할 때 사용
/// - Author: 남정은(dlsl7080@gmail.com)
struct ScrapPostData:Codable {
    let userId: String
    let postId: Int
    let createdAt: String
}



/// 게시물 좋아요를 서버에 저장할 때 사용
/// - Author: 남정은(dlsl7080@gmail.com)
struct LikePostData: Codable {
    let userId: String
    let postId: Int
    let createdAt: String
}



/// 댓글 좋아요를 서버에 저장할 때 사용
/// - Author: 남정은(dlsl7080@gmail.com)
struct LikeCommentPostData: Codable {
    let likeCommentId: Int
    let userId: String
    let commentId: Int
    let createdAt: String
}
