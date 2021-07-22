//
//  Board.swift
//  Board
//
//  Created by 남정은 on 2021/07/21.
//


import UIKit

struct Board {
    let boardTitle: String
    let posts: [Post]
    //여기에 board id넣고 사용자가 즐겨찾기 하면 추가되는 방식으로 해야하나?
}

struct BoardUI {
    internal init(sectionName: String?, boardNames: [String]) {
        self.sectionName = sectionName
        self.boardNames = boardNames
    }
    
    internal init(sectionName: String?, isExpanded: Bool, boardNames: [String]) {
        self.sectionName = sectionName
        self.boardNames = boardNames
        self.isExpanded = isExpanded
    }
    
    let sectionName: String?
    var isExpanded: Bool = false
    let boardNames: [String]    
}
