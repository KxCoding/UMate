//
//  ReviewContentTableViewCell.swift
//  ReviewContentTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import Cosmos
import UIKit
import RxSwift


/// 강의평 신고
/// - Author: 남정은(dlsl7080@gmail.com)
extension Notification.Name {
    static let lectureReviewDidReported = Notification.Name("lectureReviewDidReported")
}



/// 강의에대한 개별 리뷰를 나타내는 테이블 뷰 셀
/// - Author: 장현우(heoun3089@gmail.com)), 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
class ReviewContentTableViewCell: UITableViewCell {
    /// 별점 뷰
    @IBOutlet weak var ratingView: CosmosView!
    
    /// 총평 레이블
    @IBOutlet weak var ratingLabel: UILabel!
    
    /// 신고 버튼
    @IBOutlet weak var reportButton: UIButton!
    
    /// 수강학기 레이블
    @IBOutlet weak var semesterLabel: UILabel!
    
    /// 개별 리뷰 내용 레이블
    @IBOutlet weak var reviewContentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reportButton.layer.cornerRadius = 5
        
        // 신고 알림을 보냅니다.
        // - Author: 남정은(dlsl7080@gmail.com)
        reportButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                NotificationCenter.default.post(name: .lectureReviewDidReported, object: nil)
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 개별 강의평을 나타냅니다.
    /// - Parameter review: 개별 강의평
    /// - Author: 김정민(kimjm010@icloud.com)
    func configure(review: LectureReviewListResponse.LectureReview) {
        reviewContentLabel.text = review.content
        ratingView.rating = Double(review.rating)
        ratingLabel.text = "\(review.rating)"
        semesterLabel.text = "\(review.semester) 수강자"
    }
}
