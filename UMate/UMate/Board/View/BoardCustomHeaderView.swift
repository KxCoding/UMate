//
//  BoardCustomHeaderView.swift
//  BoardCustomHeaderView
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 게시판 목록을 section별로 펼치거나 접는 기능
/// - Author: 남정은(dlsl7080@gmail.com)
extension Notification.Name {
    static let expandOrFoldSection = Notification.Name(rawValue: "expandOrFoldSection")
}



/// 게시판 목록 화면에 expandable board에 들어갈 headerView
/// - Author: 남정은(dlsl7080@gmail.com)
class BoardCustomHeaderView: UITableViewHeaderFooterView {
    /// 배경색을 설정하는 뷰
    @IBOutlet weak var backView: UIView!
    
    /// section이름 레이블
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 섹션이 접혔을 때 게시판 이름 레이블
    @IBOutlet weak var summaryLabel: UILabel!
    
    /// 우측에 넣을 화살표 이미지 뷰
    @IBOutlet weak var arrowImageView: UIImageView!
    
    /// 게시판 목록 section 버튼
    @IBOutlet weak var expandOrFoldButton: UIButton!
    
    
    /// 버튼을 눌렀을 때 게시판 목록을 section에 따라서 펼치거나 접습니다.
    /// - Parameter sender: UIButton. section에서 펼침/접힘 동작을 담당하는 버튼입니다.
    @IBAction func expandOrFoldSection(_ sender: UIButton) {
        let section = sender.tag
        
        expandableArray[section] = !expandableArray[section]
        
        NotificationCenter.default.post(name: .expandOrFoldSection, object: nil, userInfo: ["section": section])
    }
    
    
    ///  section header를 초기화합니다.
    /// - Parameter section: 초기화할 header의 section
    func configure(section: Int, boardList: [BoardDtoResponseData.BoardDto]) {
        expandOrFoldButton.tag = section
        
        switch section {
        case 2:
            titleLabel.text = "홍보"
        case 3:
            titleLabel.text = "정보"
        default:
            break
        }
        
        if expandableArray[section] {
            summaryLabel.isHidden = true
            arrowImageView.image = UIImage(named: "up-arrow")
        } else {
            summaryLabel.isHidden = false
            summaryLabel.text = boardList.filter { $0.section == section }.map { $0.name }.joined(separator: ",")
            arrowImageView.image = UIImage(named: "down-arrow")
        }
    }
}
