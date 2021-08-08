//
//  ReCommentTableViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/08/06.
//

import UIKit

class ReCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var btnContainerView: UIView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var rightDownArrowContainerView: UIStackView!
    @IBOutlet weak var reCommentContainerView: UIView!
    @IBOutlet weak var heartButtonImageView: UIImageView!
    
    var selectedReComment: Comment?
    
    // TODO: 공감이 0일때는 안보이게 하고, 공감이 1이상일 때 표시하기 -> stackView.isHidden속성 활용할 것, 버튼의 Tag속성
    @IBAction func userDidLike(_ sender: Any) {
        
        guard let reComment = selectedReComment else { return }
        
        if reComment.isliked {
            heartImageView.image = UIImage(named: "heart2")
            heartButtonImageView.image = UIImage(named: "heart2")
            reComment.isliked = false
            reComment.heartCount -= 1
            heartCountLabel.text = "\(reComment.heartCount)"
        } else {
            heartImageView.image = UIImage(named: "heart2.fill")
            heartButtonImageView.image = UIImage(named: "heart2.fill")
            reComment.isliked = true
            reComment.heartCount += 1
            heartCountLabel.text = "\(reComment.heartCount)"
        }
        
        guard reComment.heartCount > 0 else {
            heartImageView.isHidden = true
            heartCountLabel.isHidden = true
            return
        }
        
        heartImageView.isHidden = false
        heartCountLabel.isHidden = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reCommentContainerView.layer.cornerRadius = 14
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        btnContainerView.layer.cornerRadius = 14
        btnContainerView.layer.borderWidth = 0.5
        btnContainerView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    // TODO: IndexPath로 각각의 댓글에 대댓글 구현
    func configure(with comment: [Comment], indexPath: IndexPath) {
        if indexPath.section == 4 {
            
            #if DEBUG
            print(indexPath)
            #endif
            
            if comment[0].isliked {
                self.heartImageView.image = UIImage(named: "heart2.fill")
            } else {
                self.heartImageView.image = UIImage(named: "heart2")
            }
            
            if comment[0].heartCount == 0 {
                heartImageView.isHidden = true
                heartCountLabel.isHidden = true
            } else {
                heartImageView.isHidden = false
                heartCountLabel.isHidden = false
            }
            
            profileImageView.image = comment[0].image
            userIdLabel.text = comment[0].writer
            commentLabel.text = comment[0].content
            dateTimeLabel.text = comment[0].insertDate.commentDate
            heartCountLabel.text = "\(comment[0].heartCount)"
            
            selectedReComment = comment[0]
        }
    }
}
