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
    
    
    // MARK: 공감 버튼
    @IBOutlet weak var likeImageView: UIImageView!
    @IBAction func likeButton(_ sender: UIButton) {
    
        guard let post = selectedPost else { return }
        
        if post.isliked {
            likeImageView.image = UIImage(named: "heart2")
            likeImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
            
            post.isliked = false
            post.likeCount -= 1
        } else {
            likeImageView.image = UIImage(named: "heart2.fill")
            likeImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            
            post.isliked = true
            post.likeCount += 1
        }
    }
    
    
    // MARK: 스크랩 버튼
    @IBOutlet weak var scrapImageView: UIImageView!
    @IBAction func scrapButton(_ sender: UIButton) {
       
        guard let post = selectedPost else { return }
        
        if post.isScrapped {
            scrapImageView.image = UIImage(named: "bookmark64")
            scrapImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
            scrapImageView.alpha = 0.9
            
            post.isScrapped = false
            post.scrapCount -= 1
            NotificationCenter.default.post(name: .postCancelScrap, object: nil, userInfo: ["unscrappedPost": post])
    
        } else {
            scrapImageView.image = UIImage(named: "bookmark64.fill")
            scrapImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            scrapImageView.alpha = 1
            
            post.isScrapped = true
            post.scrapCount += 1
            NotificationCenter.default.post(name: .postDidScrap, object: nil, userInfo: ["scrappedPost": post])
        }
    }
   
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
  

    override func awakeFromNib() {
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
    
    /// PostContent Cell 초기화하는 메소드
    /// - Parameter post: 선택된 post
    func configure(post: Post) {
        /// 좋아요 버튼
        if post.isliked {
            likeImageView.image = UIImage(named: "heart2.fill")
            likeImageView.tintColor = UIColor.init(named: "blackSelectedColor")
        } else {
            likeImageView.image = UIImage(named: "heart2")
            likeImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
        }
        
        /// 스크랩 버튼
        if post.isScrapped {
            scrapImageView.image = UIImage(named: "bookmark64.fill")
            scrapImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            scrapImageView.alpha = 1
        } else {
            scrapImageView.image = UIImage(named: "bookmark64")
            scrapImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
            scrapImageView.alpha = 0.9
        }
        
        userNameLabel.text = post.postWriter
        dateLabel.text = post.insertDate.string
        postTitleLabel.text = post.postTitle
        postContentLabel.text = post.postContent
    
        selectedPost = post 
    }
}
