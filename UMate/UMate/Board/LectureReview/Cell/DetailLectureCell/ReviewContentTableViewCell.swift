//
//  ReviewContentTableViewCell.swift
//  ReviewContentTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit
import Cosmos


class ReviewContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var recommendationView: UIView!
    @IBOutlet weak var recommendationImageView: UIImageView!
    @IBOutlet weak var recommendationLabel: UILabel!
    @IBOutlet weak var recommendationButton: UIButton!
    
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var semesterLabel: UILabel!
    
    @IBOutlet weak var reviewContentLabel: UILabel!
    
    /// 버튼을 누르면 하이라이트 상태가 토글 되고 그에 따라 백그라운드와 뷰 틴트, 레이블 텍스트 색상이 변경됩니다.
    /// - Parameter sender: 버튼
    @IBAction func recommendationButtonTapped(_ sender: Any) {
        /// 하이라이트 상태 토글
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == false
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == true
        
        /// 하이라이트 상태에 따라 뷰 틴트 색상과 레이블 색상 변경
        recommendationImageView.tintColor = recommendationImageView.isHighlighted ? .white : .secondaryLabel
        recommendationLabel.textColor = recommendationImageView.isHighlighted ? .white : .secondaryLabel
        
        /// 하이라이트 상태에 따라 뷰 색상 변경
        recommendationView.backgroundColor = recommendationImageView.isHighlighted ? .systemRed : .systemGray5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recommendationView.layer.cornerRadius = 5
        reportButton.layer.cornerRadius = 5
    }
    
    func configure(lecture: LectureInfo, indexPath: IndexPath) {
        reviewContentLabel.text = lecture.reviews[indexPath.row].reviewContent
        ratingView.rating = Double(lecture.reviews[indexPath.row].rating.rawValue)
    }
}
