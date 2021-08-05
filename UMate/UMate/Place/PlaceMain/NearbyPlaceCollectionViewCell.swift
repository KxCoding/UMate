//
//  NearbyPlaceCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import UIKit

class NearbyPlaceCollectionViewCell: UICollectionViewCell {
    
    var target: Place!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var keywordLabel1: UILabel!
    @IBOutlet weak var keywordLabel2: UILabel!
    @IBOutlet weak var keywordContainer2: UIView!
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    
    func configure(with content: Place) {
        target = content
        
        placeNameLabel.text = target.name
        districtLabel.text = target.district
        keywordLabel1.text = target.keywords.first
        
        if target.keywords.count > 1 {
            keywordLabel2.text = target.keywords[1]
        } else {
            keywordContainer2.isHidden = true
        }
        
        if let image = target.images.first {
            placeImageView.image = image
        }
        
    }
    
    override func awakeFromNib() {
        self.setViewSquircle()
    }
}

