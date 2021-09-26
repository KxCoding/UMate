//
//  PostImageCollectionViewCell.swift
//  PostImageCollectionViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 이미지 클릭시 뷰 컨트롤러에서 처리되는 동작에대한 노티피케이션
/// - Author: 남정은
extension Notification.Name {
    static let showImageVC = Notification.Name(rawValue: "showImageVC")
    static let sendImageView = Notification.Name(rawValue: "sendImageView")
}



/// 테이블 뷰 셀안에 포함된 컬렉션 뷰 셀에대한 클래스
/// - Author: 남정은
class PostImageCollectionViewCell: UICollectionViewCell {
   /// 게시물 이미지가 표시되는 이미지 뷰
    @IBOutlet weak var postImageView: UIImageView!
    
    /// 이미지가 담겨있는 컨텐트 뷰
    @IBOutlet weak var imageContentView: UIView!
    
    /// 선택된 게시글
    var selectedPost: Post?
    
    /// 선택된 이미지의 인덱스
    var index: Int?
    
    
    /// 이미지를 클릭시에 처리할 동작
    @IBAction func postNotification(_ sender: Any) {
        /// DetailPostViewController에서 performSegue를 실행하도록 함.
        NotificationCenter.default.post(name: .showImageVC, object: nil)
        
        guard let selectedPost = selectedPost, let index = index else {
            return
        }
        /// ExpandImageViewController에서 컬렉션 뷰에 이미지를 설정하도록 함.
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
