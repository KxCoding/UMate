//
//  LectureRatingTableViewCell.swift
//  LectureRatingTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import Cosmos
import UIKit


/// 강의에 대한 총평을 보여주는 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class LectureRatingTableViewCell: UITableViewCell {
    /// 별점 뷰
    @IBOutlet weak var ratingView: CosmosView!
    
    /// 별점 점수 레이블
    @IBOutlet weak var ratingLabel: UILabel!
  
    
    // MARK: 평가 기준
    /// 과제빈도 레이블
    @IBOutlet weak var assignmentLabel: UILabel!
    
    /// 조모임 빈도 레이블
    @IBOutlet weak var groupMeetingLabel: UILabel!
    
    /// 평가 기준 레이블
    @IBOutlet weak var evaluationLabel: UILabel!
    
    /// 출결 방법 레이블
    @IBOutlet weak var attendanceLabel: UILabel!
    
    /// 시험 횟수 레이블
    @IBOutlet weak var testNumberLabel: UILabel!

    /// Count의 key는 각 항목(Enum의 case)의 rawValue이고 value는 빈도수를 나타냄
    typealias Count = (key: Int, value: Int)
    
    
    /// 강의의 총평 셀을 초기화 합니다.
    /// - Parameters:
    ///   - resultReview: 종합 강의평에 대한 정보가 담긴 배열
    ///   - ratingAvg: 강의평점 평균
    ///   - Author: 남정은(dlsl7080@gmail.com)
    func configure(resultReview: [Int], ratingAvg: Double) {
        assignmentLabel.text = LectureReview.Assignment(rawValue: resultReview[0])?.description
        groupMeetingLabel.text = LectureReview.GroupMeeting(rawValue: resultReview[1])?.description
        evaluationLabel.text = LectureReview.Evaluation(rawValue: resultReview[2])?.description
        attendanceLabel.text = LectureReview.Attendance(rawValue: resultReview[3])?.description
        testNumberLabel.text = LectureReview.TestNumber(rawValue: resultReview[4])?.description
        
        ratingView.rating = ratingAvg
        
        // 별점의 평균값
        ratingLabel.text = BoardDataManager.shared.numberFormatter.string(for: ratingAvg)
    }
}
