//
//  CountLabelTableViewCell.swift
//  CountLabelTableViewCell
//
//  Created by 남정은 on 2021/08/07.
//

import UIKit


/// 좋아요 수, 댓글 수, 스크랩 수를 나타내는 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class CountLabelTableViewCell: UITableViewCell {
    /// 좋아요 수 레이블
    @IBOutlet weak var likeCountLabel: UILabel!
    
    /// 댓글 수 레이블
    @IBOutlet weak var commentCountLabel: UILabel!
    
    /// 스크랩 수 레이블
    @IBOutlet weak var scrapCountLabel: UILabel!
    

    /// 좋아요 수, 댓글 수, 스크랩 수를 초기화합니다.
    /// - Parameter post: 선택된 게시글
    func configure(post: Post) {
        likeCountLabel.text = post.likeCount.description
        commentCountLabel.text = post.commentCount.description
        scrapCountLabel.text = post.scrapCount.description
    }
}
