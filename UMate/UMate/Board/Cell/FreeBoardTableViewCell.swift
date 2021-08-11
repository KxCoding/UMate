//
//  FreeBoardTableViewCell.swift
//  FreeBoardTableViewCell
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit


class FreeBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var postWriter: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postImageView.layer.cornerRadius = postImageView.frame.height * 0.05
    }
    
    
    func configure(post: Post) {
        
        postImageView.isHidden = post.images.first == nil ? true : false
        
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
