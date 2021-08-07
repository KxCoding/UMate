//
//  CommentTableViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/08/04.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var btnContainerView: UIView!
    @IBOutlet weak var heartImageView: UIImageView!
    
    // TODO: 공감이 0일때는 안보이게 하고, 공감이 1이상일 때 표시하기 -> stackView.isHidden속성 활용할 것
    @IBAction func likeBtn(_ sender: Any) {
        
        #if DEBUG
        print("공감합니다, HeartCount +1")
        #endif
        
        if let heart = heartCountLabel.text, let heartCount = Int(heart) {
            heartImageView.image = UIImage(named: "heart2.fill")
            heartCountLabel.text = "\(heartCount + 1)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        btnContainerView.layer.cornerRadius = 14
        btnContainerView.layer.borderColor = UIColor.lightGray.cgColor
        btnContainerView.layer.borderWidth = 0.5
        
        //heartCount가 0일때는 하트이미지 숨기는 기능 구현
    }
    
    func configure(with comment: Comment) {
        profileImageView.image = comment.image
        userIdLabel.text = comment.writer
        commentLabel.text = comment.content
        dateTimeLabel.text = comment.insertDate.commentDate
        heartCountLabel.text = comment.heartCount.description
    }
}
