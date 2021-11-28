//
//  FreeBoardTableViewCell.swift
//  FreeBoardTableViewCell
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit


/// 기본 게시판에 게시글 목록 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class FreeBoardTableViewCell: UITableViewCell {
    /// 게시글 제목 레이블
    @IBOutlet weak var postTitleLabel: UILabel!
    
    /// 게시글 내용 레이블
    @IBOutlet weak var postContentLabel: UILabel!
    
    /// 게시글이 작성된 시간 레이블
    @IBOutlet weak var postTimeLabel: UILabel!
    
    /// 게시글 작성자 레이블
    @IBOutlet weak var postWriterLabel: UILabel!
    
    /// 게시글 좋아요 수 레이블
    @IBOutlet weak var likeCountLabel: UILabel!
    
    /// 게시글 댓글 수 레이블
    @IBOutlet weak var commentCountLabel: UILabel!
    
    /// 게시글 스크랩 레이블
    @IBOutlet weak var scrapCountLabel: UILabel!
    
    
    /// 게시글 목록 셀을 초기화합니다.
    /// - Parameter post: 각 셀에 해당하는 게시글
    func configure(post: PostListDtoResponseData.PostDto) {
        
        postTitleLabel.text = post.title
        postContentLabel.text = post.content
        postTimeLabel.text = post.dateStr
        postWriterLabel.text = post.userName
        likeCountLabel.text = "\(post.likeCnt)"
        commentCountLabel.text = "\(post.commentCnt)"
        scrapCountLabel.text = "\(post.scrapCnt)"
    }
}
