//
//  Post.swift
//  Post
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit

struct Post {
    //let imageURL: [String]
    let image: UIImage?
    let postTitle: String
    let postContent: String
    let postWriter: String
    
    let insertDate: Date
    let likeCount: Int
    let commentCount: Int
    
    
    let postID: String = ""
    let writerID: Int = 0
}

struct Comment {
    let commentContent: String
    let commentWriter: String
    
    let wrtierID: Int = 0
}
