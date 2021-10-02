//
//  LectureRatingTableViewCell.swift
//  LectureRatingTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import Cosmos
import UIKit


/// 강의에 대한 총평을 보여주는 테이블 뷰 셀
/// - Author: 남정은
class LectureRatingTableViewCell: UITableViewCell {
    /// 별점
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    /// 평가 기준들
    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var groupMeetingLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var testNumberLabel: UILabel!

    /// Count에 key는 각 항목(Enum의 case)의 rawValue이고 value는 빈도수를 나타냄
    typealias Count = (key: Int, value: Int)
    
    
    /// 셀 초기화
    /// - Parameters:
    ///   - resultReview: 종합 강의평에 대한 정보가 담긴 배열
    ///   - lecture: 선택된 강의에 대한 정보
    func configure(resultReview: [[Count]], lecture: LectureInfo) {
        
        // resultReview는 [Assingment, Groupmeeting, Evaluation, Attendance, TestNumer]에 대해서 각각의 항목중 빈도 수 높은 것이 왼쪽에 오도록 정렬되어 있음.
        assignmentLabel.text = LectureReview.Assignment(rawValue: resultReview[0].first?.key ?? 0)?.description
        groupMeetingLabel.text = LectureReview.GroupMeeting(rawValue: resultReview[1].first?.key ?? 0)?.description
        evaluationLabel.text = LectureReview.Evaluation(rawValue: resultReview[2].first?.key ?? 0)?.description
        attendanceLabel.text = LectureReview.Attendance(rawValue: resultReview[3].first?.key ?? 0)?.description
        testNumberLabel.text = LectureReview.TestNumber(rawValue: resultReview[4].first?.key ?? 0)?.description
        
        let ratingSum = lecture.reviews.reduce(0) { partialResult, review in
            return partialResult + review.rating.rawValue
        }
       
        let ratingAvg = Double(ratingSum) / Double(lecture.reviews.count)
        ratingView.rating = ratingAvg.rounded()
        
        // 별점의 평균값
        ratingLabel.text = String(format: "%.1f", ratingAvg)
    }
}
