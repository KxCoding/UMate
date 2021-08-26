//
//  NonTitleTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/18.
//

import UIKit


class NonExpandableBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boardLabel: UILabel!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookmarkButton.tintColor = UIColor.init(named: "lightGrayNonSelectedColor")
    }
    
    
    /// 게시판 cell을 초기화하는 메소드
    /// - Parameters:
    ///   - boardList: cell에 나타낼 게시판 정보가 들어갈 배열
    ///   - indexPath: 각 게시판의 index path 
    func configure(boardList: [BoardUI], indexPath: IndexPath) {
        boardLabel.text = boardList[indexPath.row].boardNames.first
        
        /// index path로 북마크 버튼의 tag초기화
        /// 100, 101 ... 200, 201 .... 300, 301
        bookmarkButton.tag = indexPath.row + 100 * (indexPath.section + 1)
    }
}

