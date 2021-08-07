//
//  Post.swift
//  Post
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit

class Post {
    init(images: [UIImage?], postTitle: String, postContent: String, postWriter: String, insertDate: Date, likeCount: Int = 0, commentCount: Int, scrapCount: Int = 0, publicity: Post.Category.Publicity? = nil, club: Post.Category.Club? = nil, career: Post.Category.Career? = nil) {
        self.images = images
        self.postTitle = postTitle
        self.postContent = postContent
        self.postWriter = postWriter
        self.insertDate = insertDate
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.scrapCount = scrapCount
        self.publicity = publicity
        self.club = club
        self.career = career
    }
    
    //let imageURL: [String]
    let images: [UIImage?]
    let postTitle: String
    let postContent: String
    let postWriter: String
    
    let insertDate: Date
    var likeCount: Int = 0
    let commentCount: Int
    var scrapCount: Int = 0
    
    //여기서 all은 카테고리를 선택하지 않을 경우를 나타냄
    //카테고리 게시판은 무조건 글 작성시에 카테고리를 선택하도록 되어있음. 
    struct Category {
        enum Publicity: String {
            case all = "전체"
            case lectureAndEvent = "강연 및 행사"
            case partTimeJob = "알바 및 과외"
            case etcetera = "기타"
        }
        
        enum Club: String {
            case all = "전체"
            case inside = "교내"
            case union = "연합"
        }
        
        enum Career: String {
            case all = "전체"
            case QNA = "질문"
            case review = "후기"
        }
    }
    
    var publicity: Category.Publicity? = nil
    var club: Category.Club? = nil
    var career: Category.Career? = nil
    
    var isScrapped = false
    var isliked = false
    
    let postID: String = ""
    let writerID: Int = 0
}

extension Post.Category.Publicity: CaseIterable { }
extension Post.Category.Club: CaseIterable { }
extension Post.Category.Career: CaseIterable { }



class Comment {
    internal init(image: UIImage?, writer: String, content: String, insertDate: Date, heartCount: Int, isliked: Bool = false) {
        self.image = image
        self.writer = writer
        self.content = content
        self.insertDate = insertDate
        self.heartCount = heartCount
        self.isliked = isliked
    }
    
    let image: UIImage?
    let writer: String
    let content: String
    let insertDate: Date
    let heartCount: Int
    
    var isliked = false
}



