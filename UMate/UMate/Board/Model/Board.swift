//
//  Board.swift
//  Board
//
//  Created by 남정은 on 2021/07/21.
//


import UIKit

class Board {
    internal init(boardTitle: String, posts: [Post]) {
        self.boardTitle = boardTitle
        self.posts = posts
    }
    
    let boardTitle: String
    var posts: [Post]
    //여기에 board id넣고 사용자가 즐겨찾기 하면 추가되는 방식으로 해야하나?
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
