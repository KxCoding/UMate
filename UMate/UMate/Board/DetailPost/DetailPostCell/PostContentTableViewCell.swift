//
//  PostContentTableViewCell.swift
//  PostContentTableViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


extension  Notification.Name {
    static let postDidScrap = Notification.Name("postDidScrap")
    static let postCancelScrap = Notification.Name("postCancelScrap")
}

class PostContentTableViewCell: UITableViewCell {
    
    var selectedPost: Post?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var likeContainerView: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeButtonLabel: UILabel!
    @IBAction func likeButton(_ sender: UIButton) {
        //공감 버튼
        print("+1 like")
        
        guard let post = selectedPost else { return }
        
        if post.isliked {
            likeContainerView.backgroundColor = .white
            likeImageView.image = UIImage(systemName: "heart")
            likeImageView.tintColor = .lightGray
            likeButtonLabel.textColor = .lightGray
            
            post.isliked = false
            post.likeCount -= 1
        } else {
            likeContainerView.backgroundColor = .black
            likeImageView.image = UIImage(systemName: "heart.fill")
            likeImageView.tintColor = .white
            likeButtonLabel.textColor = .white
            
            post.isliked = true
            post.likeCount += 1
        }
        
        likeCountLabel.text = "\(post.likeCount)"
    }
    
    
    @IBOutlet weak var scrapContainerView: UIView!
    @IBOutlet weak var scrapImageView: UIImageView!
    @IBOutlet weak var scrapButtonLabel: UILabel!
    @IBAction func scrapButton(_ sender: UIButton) {
        //스크랩 버튼
        print("+1 scrap")
        
        guard let post = selectedPost else { return }
        
        if post.isScrapped {
            scrapContainerView.backgroundColor = .white
            scrapImageView.image = UIImage(systemName: "bookmark")
            scrapImageView.tintColor = .lightGray
            scrapButtonLabel.textColor = .lightGray
            
            post.isScrapped = false
            post.scrapCount -= 1
            NotificationCenter.default.post(name: .postCancelScrap, object: nil, userInfo: ["unscrappedPost": post])
    
        } else {
            scrapContainerView.backgroundColor = .black
            scrapImageView.image = UIImage(systemName: "bookmark.fill")
            scrapImageView.tintColor = .white
            scrapButtonLabel.textColor = .white
            
            post.isScrapped = true
            post.scrapCount += 1
            NotificationCenter.default.post(name: .postDidScrap, object: nil, userInfo: ["scrappedPost": post])
        }
        
        scrapCountLabel.text = "\(post.scrapCount)"
    }
   
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var scrapCountLabel: UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeContainerView.layer.borderColor = UIColor.lightGray.cgColor
        likeContainerView.layer.borderWidth = 1.0
        likeContainerView.layer.cornerRadius = 5
        scrapContainerView.layer.borderColor = UIColor.lightGray.cgColor
        scrapContainerView.layer.borderWidth = 1.0
        scrapContainerView.layer.cornerRadius = 5
    }
    
    func configure(post: Post) {
        if post.isliked {
            likeContainerView.backgroundColor = .black
            likeImageView.image = UIImage(systemName: "heart.fill")
            likeImageView.tintColor = .white
            likeButtonLabel.textColor = .white
        } else {
            likeContainerView.backgroundColor = .white
            likeImageView.image = UIImage(systemName: "heart")
            likeImageView.tintColor = .lightGray
            likeButtonLabel.textColor = .lightGray
        }
        
        if post.isScrapped {
            scrapContainerView.backgroundColor = .black
            scrapImageView.image = UIImage(systemName: "bookmark.fill")
            scrapImageView.tintColor = .white
            scrapButtonLabel.textColor = .white
        } else {
            scrapContainerView.backgroundColor = .white
            scrapImageView.image = UIImage(systemName: "bookmark")
            scrapImageView.tintColor = .lightGray
            scrapButtonLabel.textColor = .lightGray
        }
        
        userNameLabel.text = post.postWriter
        dateLabel.text = post.insertDate.string
        postTitleLabel.text = post.postTitle
        postContentLabel.text = post.postContent
        likeCountLabel.text = post.likeCount.description
        commentCountLabel.text = post.commentCount.description
        scrapCountLabel.text = post.scrapCount.description
        selectedPost = post 
    }
}
