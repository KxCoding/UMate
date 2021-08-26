//
//  Board.swift
//  Board
//
//  Created by 남정은 on 2021/07/21.
//


import UIKit

class Board {
    internal init(boardTitle: String, posts: [Post], categoryNumbers: [Int] = [], categoryNames: [String] = []) {
        self.boardTitle = boardTitle
        self.posts = posts
        self.categoryNumbers = categoryNumbers
        self.categoryNames = categoryNames
    }
    
    let boardTitle: String
    var posts: [Post]
    var categoryNumbers: [Int]
    var categoryNames: [String]
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
