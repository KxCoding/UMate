//
//  Post.swift
//  Post
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit

class Post {
    internal init(images: [UIImage?], postTitle: String, postContent: String, postWriter: String, insertDate: Date, likeCount: Int, commentCount: Int, isScrapped: Bool = false) {
        self.images = images
        self.postTitle = postTitle
        self.postContent = postContent
        self.postWriter = postWriter
        self.insertDate = insertDate
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.isScrapped = isScrapped
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
    
    var isScrapped = false
    var isliked = false
    
    let postID: String = ""
    let writerID: Int = 0
}

struct Comment {
    let commentContent: String
    let commentWriter: String
    
    let wrtierID: Int = 0
}
