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
    
    var allLabelData: String?
    var newLabelData: String?
    var careerLabelData: String?
    
    
    @IBAction func toggleAllLabel(_ sender: Any) {
        allLabel.isHighlighted.toggle()
        allLabelData = allLabel.text
        NotificationCenter.default.post(name: .selectedCareer, object: nil, userInfo: [UserInfoIdentifires.careerData: allLabelData ?? "전체"])
    }
    
    
    @IBAction func toggleNewLabel(_ sender: Any) {
        newLabel.isHighlighted.toggle()
        newLabelData = newLabel.text
        NotificationCenter.default.post(name: .selectedCareer, object: nil, userInfo: [UserInfoIdentifires.careerData: newLabelData ?? "전체"])
    }
    
    
    @IBAction func toggleCareerLabel(_ sender: Any) {
        careerLabel.isHighlighted.toggle()
        careerLabelData = careerLabel.text
        NotificationCenter.default.post(name: .selectedCareer, object: nil, userInfo: [UserInfoIdentifires.careerData: careerLabelData ?? "전체"])
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [allLabel, newLabel, careerLabel].forEach({
            $0?.textColor = .lightGray
            $0?.highlightedTextColor = .systemBlue
        })
    }

   
}
