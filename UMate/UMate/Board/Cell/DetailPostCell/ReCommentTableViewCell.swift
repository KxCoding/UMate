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
    
    
    // TODO: 공감이 0일때는 안보이게 하고, 공감이 1이상일 때 표시하기 -> stackView.isHidden속성 활용할 것, 버튼의 Tag속성
    @IBAction func likeBtn(_ sender: Any) {
        
        #if DEBUG
        print("공감합니다, HeartCount +1")
        #endif
        
        if let heart = heartCountLabel.text, let heartCount = Int(heart) {
            heartCountLabel.text = "\(heartCount + 1)"
        }
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
    func configure(with comment: [Comment]) {
        profileImageView.image = comment[0].image
        userIdLabel.text = comment[0].writer
        commentLabel.text = comment[0].content
        dateTimeLabel.text = comment[0].insertDate.commentDate
        heartCountLabel.text = "\(comment[0].heartCount)"
    }
}
