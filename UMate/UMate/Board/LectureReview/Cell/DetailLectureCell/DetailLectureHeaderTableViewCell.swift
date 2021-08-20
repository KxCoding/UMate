//
//  DetailLectureHeaderTableViewCell.swift
//  DetailLectureHeaderTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit

class DetailLectureHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!
    
    @IBOutlet weak var writeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        writeButton.setButtonTheme()
    }
}
