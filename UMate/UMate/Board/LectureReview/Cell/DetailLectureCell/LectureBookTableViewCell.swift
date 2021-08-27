//
//  LectureBookTableViewCell.swift
//  LectureBookTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit

class LectureBookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookStoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookStoreButton.setButtonTheme()
    }
}
