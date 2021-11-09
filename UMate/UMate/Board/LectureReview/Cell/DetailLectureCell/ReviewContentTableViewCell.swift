//
//  ReviewContentTableViewCell.swift
//  ReviewContentTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import Cosmos
import UIKit


/// 강의에대한 개별 리뷰를 나타내는 테이블 뷰 셀
/// - Author: 장현우, 김정민
class ReviewContentTableViewCell: UITableViewCell {
    /// 별점 뷰
    @IBOutlet weak var ratingView: CosmosView!
    
    /// 총평 레이블
    @IBOutlet weak var ratingLabel: UILabel!
    
    /// 추천버튼 뷰
    @IBOutlet weak var recommendationView: UIView!
    
    /// 추천버튼 이미지 뷰
    @IBOutlet weak var recommendationImageView: UIImageView!
    
    /// '추천'에대한 레이블
    @IBOutlet weak var recommendationLabel: UILabel!
    
    /// 추천 버튼
    @IBOutlet weak var recommendationButton: UIButton!
    
    /// 신고 버튼
    @IBOutlet weak var reportButton: UIButton!
    
    /// 수강학기 레이블
    @IBOutlet weak var semesterLabel: UILabel!
    
    /// 개별 리뷰 내용 레이블
    @IBOutlet weak var reviewContentLabel: UILabel!
    
    
    /// 버튼을 누르면 하이라이트 상태가 토글 되고 그에 따라 백그라운드와 뷰 틴트, 레이블 텍스트 색상이 변경됩니다.
    /// - Parameter sender: 추천 버튼
    /// - Author: 장현우
    @IBAction func recommendationButtonTapped(_ sender: Any) {
        // 하이라이트 상태 토글
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == false
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == true
        
        // 하이라이트 상태에 따라 뷰 틴트 색상과 레이블 색상 변경
        recommendationImageView.tintColor = recommendationImageView.isHighlighted ? .white : .secondaryLabel
        recommendationLabel.textColor = recommendationImageView.isHighlighted ? .white : .secondaryLabel
        
        // 하이라이트 상태에 따라 뷰 색상 변경
        recommendationView.backgroundColor = recommendationImageView.isHighlighted ? .systemRed : .systemGray5
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recommendationView.layer.cornerRadius = 5
        reportButton.layer.cornerRadius = 5
    }
    
    
    /// 셀을 초기화
    /// - Parameters:
    ///   - lecture: 강의 정보
    ///   - indexPath: 개별 리뷰 셀의 인덱스패스
    /// - Author: 김정민
    func configure(review: LectureReviewListResponse.LectureReview) {
        reviewContentLabel.text = review.content
        ratingView.rating = Double(review.rating)
        ratingLabel.text = "\(review.rating)"
        semesterLabel.text = "\(review.semester) 수강자"
    }
}
