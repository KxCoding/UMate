//
//  LectureBookTableViewCell.swift
//  LectureBookTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit

class LectureBookTableViewCell: UITableViewCell {

    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookLinkTextView: UITextView!
    
    
    func configure(lecture: LectureInfo) {
        /// 등록된 교재가 없을 경우
        if lecture.textbookName.isEmpty {
            bookNameLabel.isHidden = true
            bookLinkTextView.text = "등록된 교재정보가 없습니다."
            bookLinkTextView.isSelectable = false
            explainLabel.isHidden = true
        }
        /// 등록된 교재가 있을 경우
        else {
            let attribuedString = NSMutableAttributedString(string: lecture.textbookName,
                                                            attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
            if let encoded = lecture.bookLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encoded)
            {
                attribuedString.addAttribute(.link, value: url, range: NSMakeRange(0, attribuedString.length))
                bookLinkTextView.attributedText = attribuedString
                bookLinkTextView.linkTextAttributes = [
                    .foregroundColor: UIColor.label,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                ]
            }
        }
    }
}
