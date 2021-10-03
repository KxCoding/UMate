//
//  CommentTableViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/08/04.
//

import UIKit


/// 댓글 및 대댓글을 표시하는 테이블뷰 셀
/// - Author: 김정민(kimjm010@icloud.com)
class CommentTableViewCell: UITableViewCell {
    
    /// 댓글 및 대댓글 저장을 위한 아울렛
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var btnContainerView: UIView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var heartButtonImageView: UIImageView!
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var commentSeparationView: UIView!
    @IBOutlet weak var reCommentContainerView: UIStackView!
    
    /// 선택된 댓글을 담을 속성
    var selectedComment: Comment?
    
    
    /// 좋아요 버튼 클릭시 처리할 동작입니다.
    /// 좋아요 버튼을 클릭할 때 좋아요 갯수와 이미지 뷰의 상태가 바뀝니다.
    /// - Parameter sender: 좋아요 Button
    @IBAction func toggleLike(_ sender: Any) {
        
        guard var comment = selectedComment else { return }
        
        if comment.isliked {
            heartImageView.image = UIImage(named: "heart2")
            heartButtonImageView.image = UIImage(named: "heart2")
            comment.isliked = false
            comment.heartCount -= 1
            heartCountLabel.text = "\(comment.heartCount)"
            
        } else {
            heartImageView.image = UIImage(named: "heart2.fill")
            heartButtonImageView.image = UIImage(named: "heart2.fill")
            comment.isliked = true
            comment.heartCount += 1
            heartCountLabel.text = "\(comment.heartCount)"
        }
        
        
        // 좋아요 수가 0인경우 하트 이미지를 표시하지 않습니다.
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
    
    
    /// 게시글에 추가될 Comment셀을 초기화 합니다.
    func configure(with comment: Comment) {
        
        heartImageView.image = comment.isliked ? UIImage(named: "heart2") : UIImage(named: "heart2.fill")
        
        if comment.heartCount == 0 {
            heartImageView.isHidden = true
            heartCountLabel.isHidden = true
        } else {
            heartImageView.isHidden = false
            heartCountLabel.isHidden = false
        }
        
        heartImageView.image = comment.isliked ? UIImage(named: "heart2.fill") : UIImage(named: "heart2")
        
        reCommentContainerView.isHidden = !(comment.isReComment) ? true : false
        profileImageView.image = comment.image
        userIdLabel.text = comment.writer
        commentLabel.text = comment.content
        dateTimeLabel.text = comment.insertDate.commentDate
        heartCountLabel.text = comment.heartCount.description
        commentSeparationView.isHidden = !(comment.isReComment) ? false : true
        commentContainerView.backgroundColor = !(comment.isReComment) ? UIColor.systemBackground : UIColor.systemGray6
        commentContainerView.layer.cornerRadius = !(comment.isReComment) ? 0 : 10
        
        selectedComment = comment
    }
}
