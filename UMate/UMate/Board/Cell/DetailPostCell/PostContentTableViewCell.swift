//
//  PostContentTableViewCell.swift
//  PostContentTableViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 스크랩에대한 노티피케이션
/// - Author: 남정은(dlsl7080@gmail.com)
extension  Notification.Name {
    static let postDidScrap = Notification.Name("postDidScrap")
    static let postCancelScrap = Notification.Name("postCancelScrap")
}



/// 게시글 작성자, 제목, 내용에 관한 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class PostContentTableViewCell: UITableViewCell {
    /// 작성자 프로필 이미지를 나타낼 이미지 뷰
    @IBOutlet weak var userImageView: UIImageView!
    
    /// 작성자 이름을 나타낼 레이블
    @IBOutlet weak var userNameLabel: UILabel!
    
    /// 작성일을 나타낼 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 게시글 제목 레이블
    @IBOutlet weak var postTitleLabel: UILabel!
    
    /// 게시글 내용 레이블
    @IBOutlet weak var postContentLabel: UILabel!
    
    /// 선택된 게시글
    var selectedPost: Post?
    
    
    // MARK: 공감 버튼
    /// 하트 이미지 뷰
    @IBOutlet weak var likeImageView: UIImageView!
    
    /// 좋아요 버튼
    @IBAction func toggleLikeButton(_ sender: UIButton) {
    
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
    /// 스크랩 이미지 뷰
    @IBOutlet weak var scrapImageView: UIImageView!
    
    /// 스크랩 버튼
    @IBAction func toggleScrapButton(_ sender: UIButton) {
       
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
    
    
    /// 신고 혹은 게시글 수정, 삭제를 actionSheet으로 나타냅니다.
    /// - Parameter sender: 햄버거 버튼
    @IBAction func showMenu(_ sender: Any) {
        NotificationCenter.default.post(name: .sendAlert, object: nil)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 사용자 이미지 모서리 깎기
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
    
    /// 작성자, 제목, 내용을 나타내는 셀을 초기화합니다.
    /// - Parameter post: 선택된 post
    func configure(post: Post) {
        // 좋아요 버튼
        if post.isliked {
            likeImageView.image = UIImage(named: "heart2.fill")
            likeImageView.tintColor = UIColor.init(named: "blackSelectedColor")
        } else {
            likeImageView.image = UIImage(named: "heart2")
            likeImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
        }
        
        // 스크랩 버튼
        if post.isScrapped {
            scrapImageView.image = UIImage(named: "bookmark64.fill")
            scrapImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            scrapImageView.alpha = 1
        } else {
            scrapImageView.image = UIImage(named: "bookmark64")
            scrapImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
            scrapImageView.alpha = 0.9
        }
        
        // 사용자 이름
        userNameLabel.text = post.postWriter
        
        // 작성일
        dateLabel.text = post.insertDate.detailPostDate
        
        // 게시글 제목
        postTitleLabel.text = post.postTitle
        
        // 게시글 내용
        postContentLabel.text = post.postContent
    
        // 게시글을 셀 클래스에서 사용하기위해 저장
        selectedPost = post 
    }
}
