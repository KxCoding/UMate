//
//  CountLabelTableViewCell.swift
//  CountLabelTableViewCell
//
//  Created by 남정은 on 2021/08/07.
//

import UIKit

class CountLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var scrapCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    /// 좋아요 수, 댓글 수, 스크랩 수 초기화
    func configure(post: Post) {
        likeCountLabel.text = post.likeCount.description
        commentCountLabel.text = post.commentCount.description
        scrapCountLabel.text = post.scrapCount.description
    }
}
