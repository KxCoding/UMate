//
//  LectureSummaryTableViewCell.swift
//  LectureSummaryTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit


/// 강의 정보 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class LectureSummaryTableViewCell: UITableViewCell {
    /// 교수명 레이블
    @IBOutlet weak var professorNameLabel: UILabel!
    
    /// 개설학기 레이블
    @IBOutlet weak var openingSemesterLabel: UILabel!
    
    
    /// 강의 정보를 간단히 나타내는 셀을 초기화합니다.
    /// - Parameters:
    ///   - lecture: 선택된 강의
    ///   - professor: 교수명
    ///   - Author: 남정은(dlsl7080@gmail.com)
    func configure(lecture: LectureInfoDetailResponse.LectrueInfo, professor: String){
        professorNameLabel.text = professor
        openingSemesterLabel.text = lecture.semesters.replacingOccurrences(of: "/", with: ",")
    }
}
