//
//  PostImageCollectionViewCell.swift
//  PostImageCollectionViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit

class PostImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var imageContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //postImageView.layer.cornerRadius = postImageView.frame.height * 0.1
        
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowRadius = postImageView.frame.height * 0.1
//        layer.shadowOpacity = 0.5
        
        layer.cornerRadius = 15.0
        //layer.borderWidth = 0.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        imageContentView.layer.cornerRadius = postImageView.frame.height * 0.1
        imageContentView.layer.masksToBounds = true
       
    }
}
