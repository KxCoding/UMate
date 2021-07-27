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
    
    @IBAction func likeButton(_ sender: UIButton) {
        //공감 버튼
        print("+1 like")
    }
    
    @IBOutlet weak var scrapImageView: UIImageView!
    @IBOutlet weak var scrapLabel: UILabel!
    @IBAction func scrapButton(_ sender: UIButton) {
        //스크랩 버튼
        print("+1 scrap")
        
        guard let post = selectedPost else {
            return
        }
        
        if post.isScrapped {
            scrapContainerView.layer.borderColor = UIColor.lightGray.cgColor
            scrapImageView.tintColor = .lightGray
            scrapLabel.textColor = .lightGray
            
            post.isScrapped = false
            NotificationCenter.default.post(name: .postCancelScrap, object: nil, userInfo: ["unscrappedPost": post])
    
        } else {
            scrapContainerView.layer.borderColor = UIColor.systemBlue.cgColor
            scrapImageView.tintColor = .systemBlue
            scrapLabel.textColor = .systemBlue
            
            post.isScrapped = true
            NotificationCenter.default.post(name: .postDidScrap, object: nil, userInfo: ["scrappedPost": post])
        }
    }
    
    @IBOutlet weak var likeContainerView: UIView!
    @IBOutlet weak var scrapContainerView: UIView!
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scarpLabel: UILabel!
  

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
        if post.isScrapped {
            //스크랩 되어 있으면 파랑색
            scrapContainerView.layer.borderColor = UIColor.systemBlue.cgColor
            scrapImageView.tintColor = .systemBlue
            scrapLabel.textColor = .systemBlue
        } else {
            //안 되어 있으면 회색
            scrapContainerView.layer.borderColor = UIColor.lightGray.cgColor
            scrapImageView.tintColor = .lightGray
            scrapLabel.textColor = .lightGray
        }
        
        userNameLabel.text = post.postWriter
        dateLabel.text = post.insertDate.string
        postTitleLabel.text = post.postTitle
        postContentLabel.text = post.postContent
        likeLabel.text = post.likeCount.description
        commentLabel.text = post.commentCount.description
        selectedPost = post 
    }
}
