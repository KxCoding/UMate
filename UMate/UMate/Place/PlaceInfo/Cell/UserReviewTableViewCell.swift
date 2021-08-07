//
//  UserReviewTableViewCell.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/07/19.
//

import UIKit
import Cosmos

class UserReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var userPointView: CosmosView!
    @IBOutlet weak var userPointLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recommendationView: UIView!
    @IBOutlet weak var recommendationImageView: UIImageView!
    @IBOutlet weak var recommendationLabel: UILabel!
    @IBOutlet weak var recommendationButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        userPointLabel.text = "\(userPointView.rating)"
        recommendationView.layer.cornerRadius = 5
        reportButton.layer.cornerRadius = 5
    }
    
    
    /// 버튼을 누르면 하이라이트 상태가 토글 되고 그에 따라 백그라운드와 뷰 틴트, 레이블 텍스트 색상이 변경됩니다.
    /// - Parameter sender: 버튼
    @IBAction func recommendationButtonTapped(_ sender: UIButton) {
        /// 하이라이트 상태 토글
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == false
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == true
        
        /// 하이라이트 상태에 따라 뷰 틴트 색상과 레이블 색상 변경
        recommendationImageView.tintColor = recommendationImageView.isHighlighted ? .white : .lightGray
        recommendationLabel.textColor = recommendationImageView.isHighlighted ? .white : .lightGray
        
        /// 하이라이트 상태에 따라 뷰 색상 변경
        recommendationView.backgroundColor = recommendationImageView.isHighlighted ? .systemRed : .systemGray5
    }
}

