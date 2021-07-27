//
//  PostContentTableViewCell.swift
//  PostContentTableViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit

class PostContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func likeButton(_ sender: UIButton) {
        //공감 버튼
        print("+1 like")
    }
    @IBAction func scrapButton(_ sender: UIButton) {
        //스크랩 버튼
        print("+1 scrap")
    }
    
    @IBOutlet weak var likeContainerView: UIView!
    @IBOutlet weak var scrapContainerView: UIView!
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scarpLabel: UILabel!
  
    @IBOutlet weak var postImageCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeContainerView.layer.borderColor = UIColor.darkGray.cgColor
        likeContainerView.layer.borderWidth = 1.0
        likeContainerView.layer.cornerRadius = 5
        scrapContainerView.layer.borderColor = UIColor.darkGray.cgColor
        scrapContainerView.layer.borderWidth = 1.0
        scrapContainerView.layer.cornerRadius = 5
    }
    
    func configure(post: Post) {
        userNameLabel.text = post.postWriter
        dateLabel.text = post.insertDate.string
        postTitleLabel.text = post.postTitle
        postContentLabel.text = post.postContent
        likeLabel.text = post.likeCount.description
        commentLabel.text = post.commentCount.description
    }
}
