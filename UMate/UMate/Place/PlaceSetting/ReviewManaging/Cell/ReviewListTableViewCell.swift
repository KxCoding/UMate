//
//  ReviewListTableViewCell.swift
//  ReviewListTableViewCell
//
//  Created by Hyunwoo Jang on 2021/09/02.
//

import Cosmos
import UIKit


/// 나의 리뷰 셀
/// - Author: 장현우(heoun3089@gmail.com)
class ReviewListTableViewCell: UITableViewCell {
    
    /// 상점 이름 레이블
    @IBOutlet weak var placeTitleLabel: UILabel!
    
    /// 평점뷰
    @IBOutlet weak var starRatingView: CosmosView!
    
    /// 날짜 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 작성한 리뷰 레이블
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 상점 이미지뷰
    @IBOutlet weak var storeImageView: UIImageView!
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    ///
    /// 상점 이름과 리뷰를 작성한 날짜, 작성한 리뷰 내용을 표시합니다.
    /// 상점 이미지를 표시합니다.
    /// - Parameter reviewItem: 리뷰 객체
    /// - Author: 장현우(heoun3089@gmail.com)
    func configure(with placeReview: PlaceReviewList.PlaceReview) {
        placeTitleLabel.text = placeReview.place.name
        starRatingView.rating = placeReview.starRating
        dateLabel.text = placeReview.insertDate.reviewDBDate?.reviewDate
        contentLabel.text = placeReview.reviewText
    }
}
