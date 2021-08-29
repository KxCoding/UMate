//
//  BoardListTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/16.
//

import UIKit


class ExpandableBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boardLabel: UILabel!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var board: BoardViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookmarkButton.tintColor = UIColor.init(named: "lightGrayNonSelectedColor")
        bookmarkButton.alpha = 0.8
    }
    
    
    /// 게시판 cell을 초기화하는 메소드
    /// - Parameters:
    ///   - boardList: cell에 나타낼 게시판 정보가 들어갈 배열
    ///   - indexPath: 각 게시판의 index path
    func configure(boardList: [BoardUI], indexPath: IndexPath) {
        boardLabel.text = boardList[indexPath.section - 1].boardNames[indexPath.row]
        
        /// index path로 북마크 버튼의 tag초기화
        /// 100, 101 ... 200, 201 .... 300, 301
        bookmarkButton.tag = indexPath.row + 100 * (indexPath.section + 1)
        
        /// section을 접었다 펼쳤을 시 북마크 속성에 따른 버튼 색 유지
        if board?.bookmarks[bookmarkButton.tag] == true {
            bookmarkButton.tintColor = UIColor.init(named: "blackSelectedColor")
        } else {
            bookmarkButton.tintColor = UIColor.init(named: "lightGrayNonSelectedColor")
        }
    }
}


