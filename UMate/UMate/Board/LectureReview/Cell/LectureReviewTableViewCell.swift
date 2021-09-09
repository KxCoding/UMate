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
    
    
    func configure(lecture: LectureInfo) {
        /// 최근 강의평이니까 무조건 첫번째
        guard let recentReview = lecture.reviews.first else { return }
        
        lectureTitleLabel.text = lecture.lectureTitle + " : " + lecture.professor
        semesterLabel.text = "\(recentReview.semester)학기 수강자"
        reviewContentLabel.text = recentReview.reviewContent
        
        /// 종합 리뷰
        let ratingSum = lecture.reviews.reduce(0) { partialResult, review in
            return partialResult + review.rating.rawValue
        }
       
        let ratingAvg = Double(ratingSum) / Double(lecture.reviews.count)
        ratingView.rating = ratingAvg.rounded()
    }
}
