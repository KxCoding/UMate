//
//  CommentTableViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/08/04.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd"
        f.timeStyle = .short
        
        return f
    }()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var btnContainerView: UIView!
    
    @IBAction func reCommentBtn(_ sender: Any) {
        print("대댓글을 작성합니다.")
    }
    
    @IBAction func likeBtn(_ sender: Any) {
        print("공감합니다")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnContainerView.layer.cornerRadius = 14
    }
    
    func configure(with comment: Comment) {
        profileImageView.image = comment.image
        userIdLabel.text = comment.writer
        commentLabel.text = comment.content
        dateTimeLabel.text = formatter.string(from: comment.insertDate)
    }
}
