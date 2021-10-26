//
//  UserReviewTableViewCell.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/07/19.
//

import Cosmos
import UIKit


/// 사용자 리뷰 셀
/// - Author: 장현우(heoun3089@gmail.com)
class UserReviewTableViewCell: UITableViewCell {
    
    /// 별점 이미지뷰
    ///
    /// 사용자가 작성한 별점을 이미지로 표시합니다.
    @IBOutlet weak var userPointView: CosmosView!
    
    /// 별점 레이블
    ///
    /// 사용자가 작성한 별점을 숫자로 표시합니다.
    @IBOutlet weak var userPointLabel: UILabel!
    
    /// 리뷰 텍스트 레이블
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    /// 작성 날짜 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 추천 버튼 컨테이너 뷰
    @IBOutlet weak var recommendationContainerView: UIView!
    
    /// 추천 이미지뷰
    @IBOutlet weak var recommendationImageView: UIImageView!
    
    /// 추천 레이블
    @IBOutlet weak var recommendationLabel: UILabel!
    
    /// 추천 버튼
    @IBOutlet weak var recommendationButton: UIButton!
    
    /// 신고 버튼
    @IBOutlet weak var reportButton: UIButton!
    
    /// 추천수 레이블
    @IBOutlet weak var recommendationCountLabel: UILabel!
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 별점을 숫자로 표시합니다.
    /// 추천 버튼 컨테이너 뷰와 신고 버튼 외곽선을 둥글게 깎습니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPointLabel.text = "\(userPointView.rating)"
        recommendationContainerView.layer.cornerRadius = 5
        reportButton.layer.cornerRadius = 5
    }
    
    
    /// 하이라이트 상태가 토글 되고 그에 따라 백그라운드와 뷰 틴트, 레이블 텍스트 색상이 변경됩니다.
    /// - Parameter sender: 추천 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func recommendationButtonTapped(_ sender: UIButton) {
        // 하이라이트 상태 토글
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == false
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == true
        
        // 하이라이트 상태에 따라 뷰 틴트 색상과 레이블 색상 변경
        recommendationImageView.tintColor = recommendationImageView.isHighlighted ? .white : .secondaryLabel
        recommendationLabel.textColor = recommendationImageView.isHighlighted ? .white : .secondaryLabel
        
        // 하이라이트 상태에 따라 뷰 색상 변경
        recommendationContainerView.backgroundColor = recommendationImageView.isHighlighted ? .systemRed : .systemGray5
    }
}
