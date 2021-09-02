//
//  LectureSummaryTableViewCell.swift
//  LectureSummaryTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit

class LectureSummaryTableViewCell: UITableViewCell {
    /// 교수명
    @IBOutlet weak var professorNameLabel: UILabel!
    /// 개설학기
    @IBOutlet weak var openingSemesterLabel: UILabel!
    
    func configure(lecture: LectureInfo){
   
        professorNameLabel.text = lecture.professor.replacingOccurrences(of: "/", with: ",")
        openingSemesterLabel.text = lecture.openingSemester.replacingOccurrences(of: "/", with: ",")
    }
}
