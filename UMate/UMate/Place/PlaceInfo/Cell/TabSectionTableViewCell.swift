//
//  TabSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit


/// 하위 탭이 표시되는 섹션 셀 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
class TabSectionTableViewCell: UITableViewCell {
    
    /// 정보 탭 버튼
    @IBOutlet weak var detailButton: UIButton!
    
    /// 리뷰 탭 버튼
    @IBOutlet weak var reviewButton: UIButton!
    
    /// 선택 상태에 따라 언더바 위치를 결정할 center 제약 - 정보 탭
    @IBOutlet weak var centerXToDetailConstraint: NSLayoutConstraint!
    
    /// 선택 상태에 따라 언더바 위치를 결정할 center 제약 - 리뷰 탭
    @IBOutlet weak var centerXToReviewConstraint: NSLayoutConstraint!
    
    
    // MARK: Cell Lifecycle Method
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 탭 버튼의 tag 값 초기화
        detailButton.tag = 100
        reviewButton.tag = 101
        
        
        // 탭 버튼을 누르면 center 제약을 바꾸는 방식으로 뷰 위치를 바꿉니다.
        NotificationCenter.default.addObserver(forName: .tapToggleDidRequest, object: nil, queue: .main) { [weak self] noti in
            
            guard let selectedTap = noti.userInfo?["selectedTap"] as? PlaceInfoViewController.SubTab else { return }
            
            // 전달된 탭에 따라 막대의 위치를 제약으로  변경
            switch selectedTap {
            case .detail:
                self?.centerXToDetailConstraint.priority = UILayoutPriority(1000)
            case .review:
                self?.centerXToDetailConstraint.priority = UILayoutPriority(998)
            }
            
        }
        
    }
}
