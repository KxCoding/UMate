//
//  DegreeTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/09/23.
//

import UIKit

class CareerTableViewCell: UITableViewCell {

    @IBOutlet weak var allLabel: UILabel!
    
    @IBOutlet weak var newLabel: UILabel!
    
    @IBOutlet weak var careerLabel: UILabel!
    
    
    @IBAction func toggleAllLabel(_ sender: Any) {
        allLabel.isHighlighted.toggle()
    }
    
    @IBAction func toggleNewLabel(_ sender: Any) {
        newLabel.isHighlighted.toggle()
    }
    @IBAction func toggleCareerLabel(_ sender: Any) {
        careerLabel.isHighlighted.toggle()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [allLabel, newLabel, careerLabel].forEach({
            $0?.textColor = .lightGray
            $0?.highlightedTextColor = .systemBlue
        })
    }

   
}
