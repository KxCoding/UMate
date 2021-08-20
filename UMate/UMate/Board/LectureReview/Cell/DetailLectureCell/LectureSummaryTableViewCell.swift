//
//  LectureSummaryTableViewCell.swift
//  LectureSummaryTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit

class LectureSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var professorNameLabel: UILabel!

    
    func configure(lecture: LectureInfo){
   
        professorNameLabel.text = lecture.professor.replacingOccurrences(of: "-", with: ",")
    }
}
