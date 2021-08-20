//
//  LectureRatingTableViewCell.swift
//  LectureRatingTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit
import Cosmos


class LectureRatingTableViewCell: UITableViewCell {
    
    typealias Count = (key: Int, value: Int)
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var groupMeetingLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var testNumberLabel: UILabel!

    
    func configure(resultReview: [[Count]], lecture: LectureInfo) {
        assignmentLabel.text = LectureReview.Assignment(rawValue: resultReview[0].first?.key ?? 0)?.description
        groupMeetingLabel.text = LectureReview.GroupMeeting(rawValue: resultReview[1].first?.key ?? 0)?.description
        evaluationLabel.text = LectureReview.Evaluation(rawValue: resultReview[2].first?.key ?? 0)?.description
        attendanceLabel.text = LectureReview.Attendance(rawValue: resultReview[3].first?.key ?? 0)?.description
        testNumberLabel.text = LectureReview.TestNumber(rawValue: resultReview[4].first?.key ?? 0)?.description
        
        let ratingSum = lecture.reviews.reduce(0) { partialResult, review in
            return partialResult + review.rating.rawValue
        }
       
        let ratingAvg = ratingSum / lecture.reviews.count
        ratingView.rating = Double(ratingAvg)
        ratingLabel.text = "\(ratingAvg)"
    }
}
