//
//  ButtonTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/09/23.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var adaptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [cancelButton, resetButton].forEach({
            $0?.layer.cornerRadius = 18
            $0?.layer.masksToBounds = true
            $0?.layer.borderWidth = 0.8
            $0?.layer.borderColor = UIColor.systemGray2.cgColor
        })
        
        adaptButton.layer.cornerRadius = 18
        adaptButton.layer.masksToBounds = true
    }

}
