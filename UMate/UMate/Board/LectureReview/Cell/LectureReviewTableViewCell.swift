//
//  LectureReviewTableViewCell.swift
//  LectureReviewTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import Cosmos
import UIKit


/// 강의평 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class LectureReviewTableViewCell: UITableViewCell {
    /// 교과목명 레이블
    @IBOutlet weak var lectureTitleLabel: UILabel!
    
    /// 강의평의 별점을 보여주는 뷰
    @IBOutlet weak var ratingView: CosmosView!
    
    /// 수강학기 레이블
    @IBOutlet weak var semesterLabel: UILabel!
    
    /// 리뷰내용 레이블
    @IBOutlet weak var reviewContentLabel: UILabel!
    
    
    /// 강의평 셀을 초기화합니다.
    /// - Parameter lecture: 선택된 강의
    /// - Author: 남정은(dlsl7080@gmail.com)
    func configure(lecture: LectureInfoListResponseData.LectureInfo) {
        lectureTitleLabel.text = lecture.title + " : " + lecture.professor
        
        if let rating = lecture.rating, let semester = lecture.semester {
            semesterLabel.text = "\(semester) 수강자"
            reviewContentLabel.text = lecture.content
            ratingView.settings.emptyBorderColor = .yellow
            ratingView.rating = Double(rating)
        } else {
            // 강의평이 등록되지 않은 강의
            semesterLabel.text = "강의평을 달아주세요!"
            reviewContentLabel.text = "등록된 강의평이 없습니다."
            ratingView.settings.emptyBorderColor = UIColor.init(named: "lightGrayNonSelectedColor") ?? .lightGray
            ratingView.rating = 0
        }
    }
}
