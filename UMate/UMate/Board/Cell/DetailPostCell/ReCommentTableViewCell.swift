//
//  ReCommentTableViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/08/06.
//

import UIKit

class ReCommentTableViewCell: UITableViewCell {

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
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var rightDownArrowContainerView: UIStackView!
    @IBOutlet weak var reCommentContainerView: UIView!
    
    @IBAction func likeBtn(_ sender: Any) {
        print("공감합니다, HeartCount +1")
        //공감이 0일때는 안보이게 하고, 공감이 1이상일 때 표시하기 -> stackView.isHidden속성 활용할 것
        if let heart = heartCountLabel.text, let heartCount = Int(heart) {
            heartCountLabel.text = "\(heartCount + 1)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reCommentContainerView.layer.cornerRadius = 14
        
        btnContainerView.layer.cornerRadius = 14
        btnContainerView.layer.borderWidth = 2
        btnContainerView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //indexPath: IndexPath
    func configure(with comment: [Comment]) {
        profileImageView.image = comment[0].image
        userIdLabel.text = comment[0].writer
        commentLabel.text = comment[0].content
        dateTimeLabel.text = formatter.string(from: comment[0].insertDate)
        heartCountLabel.text = "\(comment[0].heartCount)"
        
    }
}
