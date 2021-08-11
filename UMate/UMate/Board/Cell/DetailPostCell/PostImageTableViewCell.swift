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
        postImageCollectionView.delegate = self
    }
    
    
    func configure(post: Post) {
        selectedPost = post
        postImageCollectionView.isHidden = post.images.isEmpty
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
        cell.selectedPost = selectedPost
        cell.index = indexPath.row
        return cell
    }
}




extension PostImageTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }

        let width = (UIScreen.main.bounds.size.width - (flowLayout.minimumInteritemSpacing * 2 + 10)) * 0.4

        return CGSize(width: width, height: width)
    }
}





