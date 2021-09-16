//
//  UserReviewTableViewCell.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/07/19.
//

import Cosmos
import UIKit


/// 사용자들이 작성한 리뷰를 표시할 테이블뷰셀 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class UserReviewTableViewCell: UITableViewCell {
    /// 별점을 이미지로 표시하는 뷰
    /// 사용자가 작성한 별점을 이미지로 표시합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var userPointView: CosmosView!
    
    /// 별점을 숫자로 표시하는 레이블
    /// 사용자가 작성한 별점을 숫자로 표시합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var userPointLabel: UILabel!
    
    /// 리뷰 텍스트를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    /// 작성 날짜를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 추천 버튼을 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var recommendationView: UIView!
    
    /// 추천 이미지
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var recommendationImageView: UIImageView!
    
    /// 추천 글자를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var recommendationLabel: UILabel!
    
    /// 추천 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var recommendationButton: UIButton!
    
    /// 신고 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var reportButton: UIButton!
    
    
    /// 초기화 작업을 실행합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPointLabel.text = "\(userPointView.rating)"
        recommendationView.layer.cornerRadius = 5
        reportButton.layer.cornerRadius = 5
    }
    
    
    /// 버튼을 누르면 하이라이트 상태가 토글 되고 그에 따라 백그라운드와 뷰 틴트, 레이블 텍스트 색상이 변경됩니다.
    /// - Parameter sender: 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func recommendationButtonTapped(_ sender: UIButton) {
        // 하이라이트 상태 토글
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == false
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == true
        
        // 하이라이트 상태에 따라 뷰 틴트 색상과 레이블 색상 변경
        recommendationImageView.tintColor = recommendationImageView.isHighlighted ? .white : .secondaryLabel
        recommendationLabel.textColor = recommendationImageView.isHighlighted ? .white : .secondaryLabel
        
        // 하이라이트 상태에 따라 뷰 색상 변경
        recommendationView.backgroundColor = recommendationImageView.isHighlighted ? .systemRed : .systemGray5
    }
}

