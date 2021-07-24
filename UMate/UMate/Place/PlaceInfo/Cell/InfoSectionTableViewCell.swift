//
//  InfoSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit

class InfoSectionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var placeTypeImage: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var bookmarkImage: UIButton!
    
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    func configure(with content: Place) {
        
        placeTypeImage.image = content.typeIconImage
        placeNameLabel.text = content.name
        
        universityLabel.text = content.university
        districtLabel.text = content.district
        
        keywordLabel.text = content.keywords.first
        placeTypeLabel.text = content.type.rawValue
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
