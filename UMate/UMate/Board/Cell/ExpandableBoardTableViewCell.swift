//
//  BoardListTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/16.
//

import UIKit


/// 그룹으로 묶여서 접었다 필 수 있는 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class ExpandableBoardTableViewCell: NonExpandableBoardTableViewCell {
    /// 게시판 셀을 초기화합니다.
    /// - Parameters:
    ///   - boardList: 게시판 정보
    ///   - indexPath: 각 게시판의 indexPath
    ///   - bookmarks: 북마크 정보
    ///   - Author: 남정은(dlsl7080@gmail.com)
    override func configure(boardList: [BoardDtoResponseData.BoardDto], indexPath: IndexPath, bookmarks: [Int:Bool]) {
        super.configure(boardList: boardList, indexPath: indexPath, bookmarks: bookmarks)

        // 섹션을 접었다 펼쳤을 시 북마크 속성에 따른 버튼 색 유지
        if bookmarks[bookmarkButton.tag] == true {
            bookmarkButton.tintColor = UIColor.init(named: "blackSelectedColor")
        } else {
            bookmarkButton.tintColor = UIColor.init(named: "lightGrayNonSelectedColor")
        }
    }
}


