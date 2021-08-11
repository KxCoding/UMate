//
//  ComposeImageCollectionViewCell.swift
//  UMate
//
//  Created by Chris Kim on 2021/08/10.
//

import UIKit

class ComposeImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var composeImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 15.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        imageContainerView.layer.cornerRadius = composeImageView.frame.height * 0.06
        imageContainerView.layer.masksToBounds = true
    }
}
