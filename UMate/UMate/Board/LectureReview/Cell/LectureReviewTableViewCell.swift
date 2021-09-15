//
//  LectureReviewTableViewCell.swift
//  LectureReviewTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import Cosmos
import UIKit


/// 강의평 테이블 뷰 셀
/// - Author: 남정은
class LectureReviewTableViewCell: UITableViewCell {
    /// 교과목명을 나타내는 레이블
    @IBOutlet weak var lectureTitleLabel: UILabel!
    
    /// 강의평의 별점을 보여주는 뷰
    @IBOutlet weak var ratingView: CosmosView!
    
    /// 수강학기를 나타내는 레이블
    @IBOutlet weak var semesterLabel: UILabel!
    
    /// 리뷰내용을 나타내는 레이블
    @IBOutlet weak var reviewContentLabel: UILabel!
    
    
    /// 셀을 초기화
    /// - Parameter lecture: 선택된 강의
    func configure(lecture: LectureInfo) {
        /// 최근 강의평이니까 무조건 첫번째
        guard let recentReview = lecture.reviews.first else { return }
        
        lectureTitleLabel.text = lecture.lectureTitle + " : " + lecture.professor
        semesterLabel.text = "\(recentReview.semester) 수강자"
        reviewContentLabel.text = recentReview.reviewContent
        
        /// 종합 리뷰
        let ratingSum = lecture.reviews.reduce(0) { partialResult, review in
            return partialResult + review.rating.rawValue
        }
       
        let ratingAvg = Double(ratingSum) / Double(lecture.reviews.count)
        ratingView.rating = ratingAvg.rounded()
    }
}
