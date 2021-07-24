//
//  DetailPostImageCollectionViewCell.swift
//  DetailPostImageCollectionViewCell
//
//  Created by 남정은 on 2021/07/25.
//

import UIKit

class DetailPostImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postImageView.layer.cornerRadius = postImageView.frame.height * 0.1
    }
    
    
    func configure(image: UIImage?) {
        postImageView.isHidden = image == nil ? true : false
        postImageView.image = image
    }
}
