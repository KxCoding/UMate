//
//  NonTitleTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/18.
//

import UIKit


/// 펼치지않는 게시판 목록을 나타내는 테이블 뷰 셀
/// - Author: 남정은
class NonExpandableBoardTableViewCell: UITableViewCell {
    /// 게시판 이름
    @IBOutlet weak var boardLabel: UILabel!
    
    /// 게시판 이미지 아이콘
    @IBOutlet weak var boardImageView: UIImageView!
    
    /// 게시판 북마크 버튼
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// 북마크 버튼 설정
        bookmarkButton.tintColor = UIColor.init(named: "lightGrayNonSelectedColor")
        bookmarkButton.alpha = 0.8
    }
    
    
    /// section == 1 게시판 셀을 초기화
    /// - Parameters:
    ///   - boardList: 셀에 나타낼 게시판 정보가 들어갈 배열
    ///   - indexPath: 각 게시판의 인덱스패스
    func configure(boardList: [BoardUI], indexPath: IndexPath) {
        boardLabel.text = boardList[indexPath.row].boardNames.first
        
        /// 인덱스패스로 북마크 버튼의 tag초기화
        /// 100, 101 ... 200, 201 .... 300, 301
        bookmarkButton.tag = indexPath.row + 100 * (indexPath.section + 1)
    }
    
    
    /// section == 0 게시판 셀을 초기화
    /// - Parameters:
    ///   - boardList: 셀에 나타낼 게시판 정보가 들어갈 배열
    ///   - indexPath: 각 게시판의 인덱스패스
    func configure(indexPath: IndexPath) {
        let menuList = ["내가 쓴 글", "댓글 단 글", "내 강의평"]
        boardLabel.text = menuList[indexPath.row]
        boardImageView.image = UIImage(systemName: "pencil")
        bookmarkButton.isHidden = true
    }
}

