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
    
    
    /// 이미지를 클릭시에 처리할 동작
    @IBAction func postNotification(_ sender: Any) {
        
        /// DetailPostViewController에서 performSegue를 실행하도록 함.
        NotificationCenter.default.post(name: .showImageVC, object: nil)
        
        guard let selectedPost = selectedPost, let index = index else {
            return
        }
        /// ExpandImageViewController에서 collectionView에 이미지를 설정하도록 함.
        NotificationCenter.default.post(name: .sendImageView, object: nil,
                                        userInfo: ["post": selectedPost, "index": index])
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// 이미지 그림자 설정
        layer.cornerRadius = postImageView.frame.height * 0.03
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        imageContentView.layer.cornerRadius = postImageView.frame.height * 0.03
        imageContentView.layer.masksToBounds = true
    }
}
