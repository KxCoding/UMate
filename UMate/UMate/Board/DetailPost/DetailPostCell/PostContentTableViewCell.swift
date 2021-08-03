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
            likeContainerView.layer.borderColor = UIColor.lightGray.cgColor
            likeImageView.tintColor = .lightGray
            likeButtonLabel.textColor = .lightGray
            
            post.isliked = false
            post.likeCount -= 1
        } else {
            likeContainerView.layer.borderColor = UIColor.systemRed.cgColor
            likeImageView.tintColor = .systemRed
            likeButtonLabel.textColor = .systemRed
            
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
            scrapContainerView.layer.borderColor = UIColor.lightGray.cgColor
            scrapImageView.tintColor = .lightGray
            scrapButtonLabel.textColor = .lightGray
            
            post.isScrapped = false
            post.scrapCount -= 1
            NotificationCenter.default.post(name: .postCancelScrap, object: nil, userInfo: ["unscrappedPost": post])
    
        } else {
            scrapContainerView.layer.borderColor = UIColor.systemYellow.cgColor
            scrapImageView.tintColor = .systemYellow
            scrapButtonLabel.textColor = .systemYellow
            
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
        
        likeContainerView.layer.borderWidth = 1.0
        likeContainerView.layer.cornerRadius = 5
       
        scrapContainerView.layer.borderWidth = 1.0
        scrapContainerView.layer.cornerRadius = 5
    }
    
    func configure(post: Post) {
        if post.isliked {
            likeContainerView.layer.borderColor = UIColor.systemRed.cgColor
            likeImageView.tintColor = .systemRed
            likeButtonLabel.textColor = .systemRed
        } else {
            likeContainerView.layer.borderColor = UIColor.lightGray.cgColor
            likeImageView.tintColor = .lightGray
            likeButtonLabel.textColor = .lightGray
        }
        
        if post.isScrapped {
            //스크랩 되어 있으면 파랑색
            scrapContainerView.layer.borderColor = UIColor.systemYellow.cgColor
            scrapImageView.tintColor = .systemYellow
            scrapButtonLabel.textColor = .systemYellow
        } else {
            //안 되어 있으면 회색
            scrapContainerView.layer.borderColor = UIColor.lightGray.cgColor
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
