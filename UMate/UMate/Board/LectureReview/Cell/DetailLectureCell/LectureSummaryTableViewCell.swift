//
//  LectureSummaryTableViewCell.swift
//  LectureSummaryTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit


/// 강의 정보를 나타내는 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class LectureSummaryTableViewCell: UITableViewCell {
    /// 교수명을 나타내는 레이블
    @IBOutlet weak var professorNameLabel: UILabel!
    
    /// 개설학기를 나타내는 레이블
    @IBOutlet weak var openingSemesterLabel: UILabel!
    
    /// 강의 정보를 간단히 나타내는 셀을 초기화합니다.
    /// - Parameter lecture: 선택된 강의
    func configure(lecture: LectureInfo){
        professorNameLabel.text = lecture.professor.replacingOccurrences(of: "/", with: ",")
        openingSemesterLabel.text = lecture.openingSemester.replacingOccurrences(of: "/", with: ",")
    }
}
