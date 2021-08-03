//
//  Board.swift
//  Board
//
//  Created by 남정은 on 2021/07/21.
//


import UIKit

class Board {
    internal init(boardTitle: String, posts: [Post], categories: [String] = []) {
        self.boardTitle = boardTitle
        self.posts = posts
        self.categories = categories
    }
    
    let boardTitle: String
    var posts: [Post]
    var categories: [String]
}

struct BoardUI {
    internal init(sectionName: String?, isExpanded: Bool = false, boardNames: [String]) {
        self.sectionName = sectionName
        self.boardNames = boardNames
        self.isExpanded = isExpanded
    }
    
    let sectionName: String?
    var isExpanded: Bool
    let boardNames: [String]    
}
