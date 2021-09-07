//
//  TestInfoTableViewCell.swift
//  TestInfoTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit

class TestInfoTableViewCell: UITableViewCell {

    /// 시험정보 란
    @IBOutlet weak var kindOfTestLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var testStrategyLabel: UILabel!
    @IBOutlet weak var questionType: UILabel!
    @IBOutlet weak var exaplesStackView: UIStackView!
    

    func configure(lecture: LectureInfo, indexPath: IndexPath) {
        let target = lecture.testInfoList[indexPath.row]
        kindOfTestLabel.text = target.testType
        semesterLabel.text = target.semester + "학기 수강자"
        testStrategyLabel.text = target.testStrategy
        questionType.text = target.questionTypes.map{ $0.trimmingCharacters(in: .whitespaces) }.joined(separator: ",")
        
        for ex in target.examples {
            let label = UILabel()
            let mutable = NSMutableAttributedString(string: ex)
            mutable.addAttribute(.backgroundColor, value: UIColor.init(named: "systemGray6BackgroundColor") ?? .lightGray, range: NSRange(ex.startIndex..<ex.endIndex, in: ex))
            label.attributedText = mutable
            exaplesStackView.addArrangedSubview(label)
        }
    }
}
