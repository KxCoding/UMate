//
//  NonTitleTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/18.
//

import UIKit


/// 펼침기능이 없는 게시판 목록 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class NonExpandableBoardTableViewCell: UITableViewCell {
    /// 게시판 이름 레이블
    @IBOutlet weak var boardLabel: UILabel!
    
    /// 게시판 아이콘 이미지 뷰
    @IBOutlet weak var boardImageView: UIImageView!
    
    
    /// 게시판 셀을 초기화합니다.
    /// - Parameters:
    ///   - boardList: 게시판 정보
    ///   - indexPath: 각 게시판의 indexPath
    ///   - Author: 남정은(dlsl7080@gmail.com)
    func configure(boardList: [BoardDtoResponseData.BoardDto], indexPath: IndexPath) {
        let target = boardList[indexPath.row]
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                boardImageView.image = UIImage(named: "paper")
            } else {
                boardImageView.image = UIImage(named: "chat")
            }
        } else {
            boardImageView.alpha = 0.8
        }
       
        boardLabel.text = target.name
    }
}

