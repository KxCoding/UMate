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
    
    /// 프로필 이미지뷰
    @IBOutlet weak var profileImageView: UIImageView!
    
    /// 사용자 아이디
    @IBOutlet weak var userIdLabel: UILabel!
    
    /// 댓글내용
    @IBOutlet weak var commentLabel: UILabel!
    
    /// 댓글의 날짜 및 시각
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    /// 좋아요 수
    @IBOutlet weak var heartCountLabel: UILabel!
    
    /// 좋아요, 쪽지보내기 버튼을 포함한 컨테이버 뷰
    @IBOutlet weak var btnContainerView: UIView!
    
    /// 좋아요 이미지뷰
    @IBOutlet weak var heartImageView: UIImageView!
    
    /// 좋아요 버튼의 이미지뷰
    @IBOutlet weak var heartButtonImageView: UIImageView!
    
    /// 댓글 컨테이너 뷰
    /// 댓글, 대댓글에 따라 다른 background 색상을 표시합니다.
    @IBOutlet weak var commentContainerView: UIView!
    
    /// 댓글 separator뷰
    /// 각 댓글을 나누기 위한 뷰입니다.
    @IBOutlet weak var commentSeparationView: UIView!
    
    /// 대댓글 컨테이너뷰
    /// 대댓글을 포함한 컨테이너뷰입니다.
    @IBOutlet weak var reCommentContainerView: UIStackView!
    
    /// 선택된 댓글
    var selectedComment: Comment?
    
    
    /// 좋아요 버튼 클릭시 처리할 동작입니다.
    /// 좋아요 버튼을 클릭할 때 좋아요 갯수와 이미지 뷰의 상태가 바뀝니다.
    /// - Parameter sender: 좋아요 Button
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func toggleLike(_ sender: Any) {
        
        guard var comment = selectedComment else { return }
        
        if comment.isliked {
            comment.isliked = false
            heartImageView.image = UIImage(named: "heart2")
            heartButtonImageView.image = UIImage(named: "heart2")
            comment.heartCount -= 1
            heartCountLabel.text = "\(comment.heartCount)"
        } else {
            comment.isliked = true
            heartImageView.image = UIImage(named: "heart2.fill")
            heartButtonImageView.image = UIImage(named: "heart2.fill")
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
    
    
    /// 셀이 로드되면 UI를 초기화합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        btnContainerView.layer.cornerRadius = 14
        btnContainerView.layer.borderColor = UIColor.init(named: "lightGrayNonSelectedColor")?.cgColor
        btnContainerView.layer.borderWidth = 0.5
    }
    
    
    /// 게시글에 추가될 Comment셀을 초기화 합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func configure(with comment: Comment) {
        
        heartImageView.isHidden = comment.heartCount == 0
        heartCountLabel.isHidden = heartImageView.isHidden
        
        reCommentContainerView.isHidden = !(comment.isReComment) ? true : false
        commentSeparationView.isHidden = !(comment.isReComment) ? false : true
        commentContainerView.backgroundColor = !(comment.isReComment) ? UIColor.systemBackground : UIColor.systemGray6
        commentContainerView.layer.cornerRadius = !(comment.isReComment) ? 0 : 10
        
        profileImageView.image = comment.image
        userIdLabel.text = comment.writer
        commentLabel.text = comment.content
        dateTimeLabel.text = comment.insertDate.commentDate
        heartCountLabel.text = comment.heartCount.description
        selectedComment = comment
    }
}
