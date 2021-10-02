//
//  BoardCustomHeaderView.swift
//  BoardCustomHeaderView
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 게시판 목록을 section별로 펼치거나 접는 기능
extension Notification.Name {
    static let expandOrFoldSection = Notification.Name(rawValue: "expandOrFoldSection")
}



/// 게시판 목록 화면에 expandable board에 들어갈 헤더뷰
/// - Author: 남정은(dlsl7080@gmail.com)
class BoardCustomHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var backView: UIView!
    
    /// section이름을 나타내는 레이블
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 섹션이 접혔을 때 게시판 이름을 나타내는 레이블
    @IBOutlet weak var summaryLabel: UILabel!
    
    /// 우측에 넣을 화살표를 나타내는 이미지 뷰
    @IBOutlet weak var arrowImageView: UIImageView!
    
    /// 게시판 목록 section 버튼
    @IBOutlet weak var expandOrFoldButton: UIButton!
    
    
    /// 버튼을 눌렀을 때 게시판 목록을 section에 따라서 펼치거나 접습니다.
    /// - Parameter sender: UIButton. section에서 펼침/접힘을 동작을 담당하는 버튼입니다.
    @IBAction func expandOrFoldSection(_ sender: UIButton) {
        let section = sender.tag
        
        // expandableBoard의 펼침/접힘에 대한 속성 변경
        expandableBoardList[section - 2].isExpanded = !expandableBoardList[section - 2].isExpanded
        
        NotificationCenter.default.post(name: .expandOrFoldSection, object: nil, userInfo: ["section": section])
    }
    
    
    ///  section 헤더를 초기화합니다.
    /// - Parameter section: 초기화할 헤더의 section
    func configure(section: Int) {
        expandOrFoldButton.tag = section
        
        titleLabel.text = expandableBoardList[section - 2].sectionName
        
        if expandableBoardList[section - 2].isExpanded {
            summaryLabel.isHidden = true
            arrowImageView.image = UIImage(named: "up-arrow")
        } else {
            summaryLabel.isHidden = false
            summaryLabel.text = expandableBoardList[section - 2].boardNames.joined(separator: ",")
            arrowImageView.image = UIImage(named: "down-arrow")
        }
    }
}
