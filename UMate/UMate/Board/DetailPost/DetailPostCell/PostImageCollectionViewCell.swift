//
//  PostImageCollectionViewCell.swift
//  PostImageCollectionViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit

class PostImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postImageView.layer.cornerRadius = postImageView.frame.height * 0.11
    }
}
