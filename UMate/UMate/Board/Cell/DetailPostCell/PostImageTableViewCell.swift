//
//  PostImageTableViewCell.swift
//  PostImageTableViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit

class PostImageTableViewCell: UITableViewCell {
    
    var selectedPost: Post?
    
    @IBOutlet weak var postImageCollectionView: UICollectionView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        postImageCollectionView.dataSource = self
    }
    
    
    func configure(post: Post) {
        selectedPost = post
        postImageCollectionView.isHidden = post.images.isEmpty
        postImageCollectionView.reloadData()
    }
}




extension PostImageTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPost?.images.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as! PostImageCollectionViewCell
        
        if let image = selectedPost?.images[indexPath.item] {
            cell.postImageView.image = image
        }
        
        return cell
    }
}
