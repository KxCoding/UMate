//
//  Board.swift
//  Board
//
//  Created by 남정은 on 2021/07/21.
//


import UIKit


/// 게시판에대한 모델
/// - Author: 남정은
class Board {
    /// 게시판 이름
    let boardTitle: String
    
    /// 해당 게시판에 포함되는 게시글 목록
    var posts: [Post]
    
    /// 게시판에 포함되는 카테고리 번호를 담는 배열
    var categoryNumbers: [Int]
    
    /// 게시판에 포함되는 카테고리명을 담는 배열
    var categoryNames: [String]
    
    
    init(boardTitle: String, posts: [Post], categoryNumbers: [Int] = [], categoryNames: [String] = []) {
        self.boardTitle = boardTitle
        self.posts = posts
        self.categoryNumbers = categoryNumbers
        self.categoryNames = categoryNames
    }
}



/// 게시판 UI에 대한 모델
/// - Author: 남정은
struct BoardUI {
    /// 게시판을 묶는 섹션이름(그룹명)
    let sectionName: String?
    
    /// 펼침, 접힘에 대한 속성
    var isExpanded: Bool
    
    /// 게시판 이름을 담는 배열
    let boardNames: [String]
    
    
    init(sectionName: String?, isExpanded: Bool = false, boardNames: [String]) {
        self.sectionName = sectionName
        self.boardNames = boardNames
        self.isExpanded = isExpanded
    }
}
