//
//  LectureBookTableViewCell.swift
//  LectureBookTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit


/// 교재 정보 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class LectureBookTableViewCell: UITableViewCell {
    /// 안내문 레이블
    @IBOutlet weak var explainLabel: UILabel!
    
    /// '교재명' 레이블
    @IBOutlet weak var bookNameLabel: UILabel!
    
    /// 교재명 텍스트 뷰
    @IBOutlet weak var bookLinkTextView: UITextView!
    
    
    /// 교재 정보 셀을 초기화합니다.
    /// - Parameter lecture: 선택된 강의
    func configure(lecture: LectureInfo) {
        // 등록된 교재가 없을 경우
        if lecture.textbookName.isEmpty {
            bookNameLabel.isHidden = true
            bookLinkTextView.text = "등록된 교재정보가 없습니다."
            bookLinkTextView.isSelectable = false
            explainLabel.isHidden = true
        }
        // 등록된 교재가 있을 경우
        else {
            let attributedString = NSMutableAttributedString(string: lecture.textbookName,
                                                            attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
            if let encoded = lecture.bookLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encoded)
            {
                attributedString.addAttribute(.link, value: url, range: NSMakeRange(0, attributedString.length))
                bookLinkTextView.attributedText = attributedString
                bookLinkTextView.linkTextAttributes = [
                    .foregroundColor: UIColor.label,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                ]
            }
        }
    }
}
