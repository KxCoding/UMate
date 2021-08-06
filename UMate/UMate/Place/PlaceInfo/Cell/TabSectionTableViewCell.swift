//
//  TabSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit

class TabSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    
    @IBOutlet weak var centerXToDetailConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerXToReviewConstraint: NSLayoutConstraint!
    
    
    /// 셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 탭 버튼의 tag 값 초기화
        detailButton.tag = 100
        reviewButton.tag = 101
        
        NotificationCenter.default.addObserver(forName: .tapToggleDidRequest, object: nil, queue: .main) { [weak self] noti in
            
            guard let selectedTap = noti.userInfo?["selectedTap"] as? PlaceInfoViewController.SubTab else { return }
            
            // 전달된 탭에 따라 막대의 위치 변경
            switch selectedTap {
            case .detail:
                self?.centerXToDetailConstraint.priority = UILayoutPriority(1000)
            case .review:
                self?.centerXToDetailConstraint.priority = UILayoutPriority(998)
            }
            
        }
        
    }
}
