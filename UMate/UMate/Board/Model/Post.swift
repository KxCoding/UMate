//
//  Post.swift
//  Post
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit

class Post {
    init(images: [UIImage?], postTitle: String, postContent: String, postWriter: String, insertDate: Date, likeCount: Int = 0, commentCount: Int, scrapCount: Int = 0, categoryRawValue: Int = -1) {
        self.images = images
        self.postTitle = postTitle
        self.postContent = postContent
        self.postWriter = postWriter
        self.insertDate = insertDate
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.scrapCount = scrapCount
        self.categoryRawValue = categoryRawValue
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
        enum Publicity: Int {
            case all = 2000
            case lectureAndEvent = 2001
            case partTimeJob = 2002
            case etcetera = 2003
        }
        
        enum Club: Int {
            case all = 2010
            case inside = 2011
            case union = 2012
        }
        
        enum Career: Int {
            case all = 3010
            case QNA = 3011
            case review = 3012
        }
    }
    
    let categoryRawValue: Int?
    
    var isScrapped = false
    var isliked = false
    
    let postID: String = ""
    let writerID: Int = 0
}

extension Post.Category.Publicity: CaseIterable { }
extension Post.Category.Club: CaseIterable { }
extension Post.Category.Career: CaseIterable { }

extension Post.Category.Publicity: CustomStringConvertible {
    public var description: String {
        switch self {
        case .all:
            return "전체"
        case .lectureAndEvent:
            return "강연∙행사"
        case .partTimeJob:
            return "알바∙과외"
        case .etcetera:
            return "기타"
        }
    }
}

extension Post.Category.Club: CustomStringConvertible {
    public var description: String {
        switch self {
        case .all:
            return "전체"
        case .inside:
            return "교내"
        case .union:
            return "연합"
        }
    }
}

extension Post.Category.Career: CustomStringConvertible {
    public var description: String {
        switch self {
        case .all:
            return "전체"
        case .QNA:
            return "질문"
        case .review:
            return "후기"
        }
    }
}



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
    var heartCount: Int
    
    var isliked = false
}



