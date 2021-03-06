//
//  PostImageCollectionViewCell.swift
//  PostImageCollectionViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 이미지 클릭 시 뷰 컨트롤러에서 처리되는 동작에 대한 노티피케이션
/// - Author: 남정은(dlsl7080@gmail.com)
extension Notification.Name {
    static let showImageVC = Notification.Name(rawValue: "showImageVC")
    static let sendImageView = Notification.Name(rawValue: "sendImageView")
}



/// 테이블 뷰 셀 안에 포함된 컬렉션 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class PostImageCollectionViewCell: UICollectionViewCell {
   /// 게시물 이미지가 표시되는 이미지 뷰
    @IBOutlet weak var postImageView: UIImageView!
    
    /// 이미지가 담겨있는 컨텐트 뷰
    @IBOutlet weak var imageContentView: UIView!
    
    /// 선택된 게시글
    var selectedPost: PostDtoResponseData.Post?
    
    /// 선택된 이미지의 인덱스
    var index: Int?
    
    
    /// 이미지를 클릭 시에 이미지를 확대해서 보여줍니다.
    /// - Parameter sender: UIButton. 사진크기의 버튼입니다.
    @IBAction func postNotification(_ sender: UIButton) {
        // DetailPostViewController에서 performSegue를 실행하도록 함
        NotificationCenter.default.post(name: .showImageVC, object: nil)
        
        guard let index = index else { return }
        // ExpandImageViewController에서 컬렉션 뷰에 이미지를 설정하도록 함
        NotificationCenter.default.post(name: .sendImageView, object: nil,
                                        userInfo: ["index": index])
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 이미지 그림자 설정
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            layer.cornerRadius = postImageView.frame.height * 0.05
            imageContentView.layer.cornerRadius = postImageView.frame.height * 0.05
            layer.shadowOffset = CGSize(width: 2, height: 2)
        } else {
            layer.cornerRadius = postImageView.frame.height * 0.03
            imageContentView.layer.cornerRadius = postImageView.frame.height * 0.03
            layer.shadowOffset = CGSize(width: 1, height: 1)
        }
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        
        imageContentView.layer.masksToBounds = true
        layer.masksToBounds = false
    }
}
