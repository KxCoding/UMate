//
//  ReviewListTableViewCell.swift
//  ReviewListTableViewCell
//
//  Created by Hyunwoo Jang on 2021/09/02.
//

import UIKit


/// 내가 쓴 리뷰를 표시할 테이블뷰셀 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class ReviewListTableViewCell: UITableViewCell {
    /// 가게 이름을 표시하는 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var placeTitleLabel: UILabel!
    
    /// 날짜를 표시하는 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 작성한 리뷰 텍스트를 표시하는 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 가게 이미지를 표시하는 이미지뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var storeImageView: UIImageView!
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter reviewItem: 표시할 내용을 가진 구조체
    /// - Author: 장현우(heoun3089@gmail.com)
    func configure(with reviewItem: PlaceReviewItem) {
        placeTitleLabel.text = reviewItem.placeName
        dateLabel.text = reviewItem.date.reviewDate
        contentLabel.text = reviewItem.reviewText
        storeImageView.image = reviewItem.image
    }
}
