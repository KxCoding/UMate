//
//  PlatFormTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/09/23.
//

import UIKit

class PlatFormTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstPlatFormLabel: UILabel!
    
    @IBOutlet weak var secondPlatFormLabel: UILabel!
  
    
    @IBAction func toggleFirstLabel(_ sender: Any) {
        firstPlatFormLabel.isHighlighted.toggle()
    }
    
    @IBAction func toggleSecondLabel(_ sender: Any) {
        secondPlatFormLabel.isHighlighted.toggle()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [firstPlatFormLabel, secondPlatFormLabel].forEach({
            $0?.highlightedTextColor = .systemBlue
            $0?.textColor = .lightGray
        })
    }

    

}
