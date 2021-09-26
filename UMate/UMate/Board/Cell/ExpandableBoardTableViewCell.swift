//
//  BoardListTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/16.
//

import UIKit


/// 그룹으로 묶여서 접었다 필 수 있는 테이블 뷰 셀
/// - Author: 남정은
class ExpandableBoardTableViewCell: UITableViewCell {
    // TODO: 서버로 옮긴 후 삭제
    var board: BoardViewController?
    
    /// 게시판 이름
    @IBOutlet weak var boardLabel: UILabel!
    
    /// 게시판 북마크 버튼
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// 북마크 버튼 설정
        bookmarkButton.tintColor = UIColor.init(named: "lightGrayNonSelectedColor")
        bookmarkButton.alpha = 0.8
    }
    
    /// 게시판 셀을 초기화
    /// - Parameters:
    ///   - boardList: 셀에 나타낼 게시판 정보가 들어갈 배열
    ///   - indexPath: 각 게시판의 인덱스패스
    func configure(boardList: [BoardUI], indexPath: IndexPath) {
        boardLabel.text = boardList[indexPath.section - 2].boardNames[indexPath.row]
        
        /// 인덱스패스로 북마크 버튼의 tag초기화
        /// 100, 101 ... 200, 201 .... 300, 301
        bookmarkButton.tag = indexPath.row + 100 * (indexPath.section + 1)
        
        /// 섹션을 접었다 펼쳤을 시 북마크 속성에 따른 버튼 색 유지
        if board?.bookmarks[bookmarkButton.tag] == true {
            bookmarkButton.tintColor = UIColor.init(named: "blackSelectedColor")
        } else {
            bookmarkButton.tintColor = UIColor.init(named: "lightGrayNonSelectedColor")
        }
    }
}


