//
//  CommentTableViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/08/04.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    //댓글 및 대댓글 저장을 위한 아울렛
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var btnContainerView: UIView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var hearButtonImageView: UIImageView!
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var commentSeparationView: UIView!
    @IBOutlet weak var reCommentContainerView: UIStackView!
    
    var selectedComment: Comment?
    
    
    /// 사용자가 좋아요 버튼을 눌럿을 때 좋아요 수 및 좋아요 이미지 변경 메소드
    /// - Parameter sender: 좋아요 Button
    @IBAction func userDidLike(_ sender: Any) {
        
        guard let comment = selectedComment else { return }
        
        if comment.isliked {
            heartImageView.image = UIImage(named: "heart2")
            hearButtonImageView.image = UIImage(named: "heart2")
            comment.isliked = false
            comment.heartCount -= 1
            heartCountLabel.text = "\(comment.heartCount)"
            
        } else {
            heartImageView.image = UIImage(named: "heart2.fill")
            hearButtonImageView.image = UIImage(named: "heart2.fill")
            comment.isliked = true
            comment.heartCount += 1
            heartCountLabel.text = "\(comment.heartCount)"
        }
        
        
        guard comment.heartCount > 0 else {
            heartImageView.isHidden = true
            heartCountLabel.isHidden = true
            return
        }
        
        heartImageView.isHidden = false
        heartCountLabel.isHidden = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        btnContainerView.layer.cornerRadius = 14
        btnContainerView.layer.borderColor = UIColor.init(named: "lightGrayNonSelectedColor")?.cgColor
        btnContainerView.layer.borderWidth = 0.5
    }
    
    
    func configure(with comment: Comment) {
        if comment.isliked {
            self.heartImageView.image = UIImage(named: "heart2.fill")
        } else {
            self.heartImageView.image = UIImage(named: "heart2")
        }
        
        if comment.heartCount == 0 {
            heartImageView.isHidden = true
            heartCountLabel.isHidden = true
        } else {
            heartImageView.isHidden = false
            heartCountLabel.isHidden = false
        }
        
        if !comment.isReComment {
            reCommentContainerView.isHidden = true
            profileImageView.image = comment.image
            userIdLabel.text = comment.writer
            commentLabel.text = comment.content
            dateTimeLabel.text = comment.insertDate.commentDate
            heartCountLabel.text = comment.heartCount.description
            
        } else {
            reCommentContainerView.isHidden = false
            commentSeparationView.isHidden = true
            commentContainerView.backgroundColor = UIColor.systemGray5
            commentContainerView.layer.cornerRadius = 10
            profileImageView.image = comment.image
            userIdLabel.text = comment.writer
            commentLabel.text = comment.content
            dateTimeLabel.text = comment.insertDate.commentDate
            heartCountLabel.text = comment.heartCount.description
        }
        
        selectedComment = comment
    }
}
