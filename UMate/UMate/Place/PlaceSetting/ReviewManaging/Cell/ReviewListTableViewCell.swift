//
//  ReviewListTableViewCell.swift
//  ReviewListTableViewCell
//
//  Created by Hyunwoo Jang on 2021/09/02.
//

import UIKit

class ReviewListTableViewCell: UITableViewCell {
    /// 내가 쓴 리뷰 화면 UI와 관련된 변수들
    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter reviewItem: 표시할 내용을 가진 구조체
    func configure(with reviewItem: PlaceReviewItem.UserReview) {
        placeTitleLabel.text = reviewItem.placeName
        dateLabel.text = reviewItem.date
        contentLabel.text = reviewItem.reviewText
        storeImageView.image = reviewItem.image
    }
}
