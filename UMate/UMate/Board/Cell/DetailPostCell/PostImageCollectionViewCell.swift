//
//  PostImageCollectionViewCell.swift
//  PostImageCollectionViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


extension Notification.Name {
    static let showImageVC = Notification.Name(rawValue: "showImageVC")
    static let sendImageView = Notification.Name(rawValue: "sendImageView")
}

class PostImageCollectionViewCell: UICollectionViewCell {
    
    var selectedPost: Post?
    var index: Int?
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var imageContentView: UIView!
    
    @IBOutlet weak var imageButton: UIButton!
    
    //indexPath와 post를 imageViewController에 전달해야함. 
    @IBAction func imagebtn(_ sender: Any) {
 
        NotificationCenter.default.post(name: .showImageVC, object: nil)
        
        guard let selectedPost = selectedPost, let index = index else {
            return
        }

        NotificationCenter.default.post(name: .sendImageView, object: nil,
                                        userInfo: ["post": selectedPost, "index": index])
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = postImageView.frame.height * 0.05
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        imageContentView.layer.cornerRadius = postImageView.frame.height * 0.03
        imageContentView.layer.masksToBounds = true
        
//        guard let index = index else { return }
//        imageButton.tag = index
    }
}
