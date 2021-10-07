//
//  TabSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit


/// 하위 탭 섹션 셀
/// - Author: 박혜정(mailmelater11@gmail.com)
class TabSectionTableViewCell: UITableViewCell {
    
    /// 정보 탭 버튼
    @IBOutlet weak var detailButton: UIButton!
    
    /// 리뷰 탭 버튼
    @IBOutlet weak var reviewButton: UIButton!
    
    /// 언더라인의 정보 탭 쪽 가운데 정렬 제약
    @IBOutlet weak var centerXToDetailConstraint: NSLayoutConstraint!
    
    /// 언더라인의 리뷰 탭 쪽 가운데 정렬 제약
    @IBOutlet weak var centerXToReviewConstraint: NSLayoutConstraint!
    
    
    // MARK: Cell Lifecycle Method
    
    /// 셀이 로드되면 UI를 초기화합니다.
    ///
    /// 하위 탭이 선택되면 선택된 탭에 따라 언더라인의 센터 제약을 바꾸는 옵저버를 추가합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailButton.tag = 100
        reviewButton.tag = 101
        
        NotificationCenter.default.addObserver(forName: .tapToggleDidRequest, object: nil, queue: .main) { [weak self] noti in
            
            guard let selectedTap = noti.userInfo?["selectedTap"] as? PlaceInfoViewController.SubTab else { return }
            
            switch selectedTap {
            case .detail:
                self?.centerXToDetailConstraint.priority = UILayoutPriority(1000)
            case .review:
                self?.centerXToDetailConstraint.priority = UILayoutPriority(998)
            }
        }
    }
    
}
