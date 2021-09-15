//
//  FreeBoardTableViewCell.swift
//  FreeBoardTableViewCell
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit


/// 기본 게시판에 게시글 목록을 나타내는 테이블 뷰 셀
/// - Author: 남정은
class FreeBoardTableViewCell: UITableViewCell {
    /// 게시글 첫번 째 이미지를 나타낼 뷰
    @IBOutlet weak var postImageView: UIImageView!
    
    /// 게시글 제목을 나타내는 레이블
    @IBOutlet weak var postTitle: UILabel!
    
    /// 게시글 내용을 나타내는 레이블
    @IBOutlet weak var postContent: UILabel!
    
    /// 게시글이 작성된 시간을 나타내는 레이블
    @IBOutlet weak var postTime: UILabel!
    
    /// 게시글 작성자를 나타내는 레이블
    @IBOutlet weak var postWriter: UILabel!
    
    /// 게시글 좋아요 수를 나타내는 레이블
    @IBOutlet weak var likeCount: UILabel!
    
    /// 게시글 댓글 수를 나타내는 레이블
    @IBOutlet weak var commentCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// 이미지의 모서리 깎기
        postImageView.layer.cornerRadius = postImageView.frame.height * 0.05
    }
    
    
    /// 게시글 목록 셀 초기화
    /// - Parameter post: 각 cell에 해당하는 게시글
    func configure(post: Post) {
        /// 이미지가 없을 시 표시하지 않음
        postImageView.isHidden = post.images.first == nil ? true : false
        
        /// 포스트에 올린 이미지가 있을 경우 첫번 째 이미지만 게시글 목록에서 표시 
        if post.images.count > 0 {
            postImageView.image = post.images[0]
        }
        
        postTitle.text = post.postTitle
        postContent.text = post.postContent
        postTime.text = post.insertDate.relativeDate
        postWriter.text = post.postWriter
        likeCount.text = "\(post.likeCount)"
        commentCount.text = "\(post.commentCount)"
    }
}
