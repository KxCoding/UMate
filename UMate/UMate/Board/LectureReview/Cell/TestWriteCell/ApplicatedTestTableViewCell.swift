//
//  ApplicatedTestTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/08/30.
//

import UIKit

class ApplicatedTestTableViewCell: UITableViewCell {

    @IBOutlet weak var selectSemesterView: UIView!
    @IBOutlet weak var selectTestView: UIView!
    
    
    @IBAction func selectSemester(_ sender: Any) {
        /// 수강학기 선택
    }
    
    
    @IBAction func selectTest(_ sender: Any) {
        /// 시험 종류 선택
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectSemesterView.layer.cornerRadius = 5
        selectTestView.layer.cornerRadius = 5
    }
}
