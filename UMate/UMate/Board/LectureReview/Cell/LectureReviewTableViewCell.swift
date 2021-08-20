//
//  LectureReviewTableViewCell.swift
//  LectureReviewTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit
import Cosmos

class LectureReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var lectureTitleLabel: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var semesterLabel: UILabel!
    
    @IBOutlet weak var reviewContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    /// 최근 강의평이니까 무조건 첫번째
    func configure(lecture: LectureInfo) {
        guard let recentReview = lecture.reviews.first else { return }
        
        lectureTitleLabel.text = lecture.lectureTitle
        semesterLabel.text = "\(recentReview.semester) 수강자"
        reviewContentLabel.text = recentReview.reviewContent
        
        let ratingSum = lecture.reviews.reduce(0) { partialResult, review in
            return partialResult + review.rating.rawValue
        }
       
        ratingView.rating = Double(ratingSum / lecture.reviews.count)
    }
}
