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
  
    var firstPlatFormData: String?
    var secondPlatFormData: String?
    
    @IBAction func toggleFirstLabel(_ sender: Any) {
        firstPlatFormLabel.isHighlighted.toggle()
        firstPlatFormData = firstPlatFormLabel.text
        NotificationCenter.default.post(name: .selectedPlatForm, object: nil, userInfo: [UserInfoIdentifires.platFormData: firstPlatFormData ?? "전체"])
    }
    
    @IBAction func toggleSecondLabel(_ sender: Any) {
        secondPlatFormLabel.isHighlighted.toggle()
        secondPlatFormData = secondPlatFormLabel.text
        NotificationCenter.default.post(name: .selectedPlatForm, object: nil, userInfo: [UserInfoIdentifires.platFormData: secondPlatFormData ?? "전체"])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [firstPlatFormLabel, secondPlatFormLabel].forEach({
            $0?.highlightedTextColor = .systemBlue
            $0?.textColor = .lightGray
        })
    }

    

}
