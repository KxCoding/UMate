//
//  CountLabelTableViewCell.swift
//  CountLabelTableViewCell
//
//  Created by 남정은 on 2021/08/07.
//

import UIKit


/// 좋아요 수, 댓글 수, 스크랩 수를 나타내는 테이블 뷰 셀
class CountLabelTableViewCell: UITableViewCell {
    /// 좋아요 수를 나타내는 레이블
    @IBOutlet weak var likeCountLabel: UILabel!
    
    /// 댓글 수를 나타내는 레이블
    @IBOutlet weak var commentCountLabel: UILabel!
    
    /// 스크랩 수를 나타내는 레이블
    @IBOutlet weak var scrapCountLabel: UILabel!
    

    /// 좋아요 수, 댓글 수, 스크랩 수 초기화
    func configure(post: Post) {
        likeCountLabel.text = post.likeCount.description
        commentCountLabel.text = post.commentCount.description
        scrapCountLabel.text = post.scrapCount.description
    }
}
