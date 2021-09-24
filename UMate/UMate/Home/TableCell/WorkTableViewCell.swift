//
//  ConfigureTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/09/22.
//

import UIKit

class WorkTableViewCell: UITableViewCell {
    /// 직업 분류 레이블 1
    @IBOutlet weak var classificationLabel: UILabel!
    
    ///직업 분류 레이블 2
    @IBOutlet weak var classificationLabel2: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    var job1: String?
    var job2: String?

    
    @IBAction func toggleWorkItem1(_ sender: Any) {
        classificationLabel.isHighlighted.toggle()
        job1 = classificationLabel.text
        print(job1)
        NotificationCenter.default.post(name: .selectedJob, object: nil, userInfo: [UserInfoIdentifires.workData: job1 ?? "전체"])
        
        print("sent")
    }
    
    
    @IBAction func toggleWorkItem2(_ sender: Any) {
        classificationLabel2.isHighlighted.toggle()
        job2 = classificationLabel2.text
        print(job2)
        NotificationCenter.default.post(name: .selectedJob, object: nil, userInfo: [UserInfoIdentifires.workData: job2 ?? "전체"])
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [classificationLabel, classificationLabel2].forEach{
            $0?.textColor = .lightGray
            $0?.highlightedTextColor = .systemBlue
            $0?.isHighlighted = false
        }
    }
    
}
