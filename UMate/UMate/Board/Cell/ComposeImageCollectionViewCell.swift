//
//  ComposeImageCollectionViewCell.swift
//  UMate
//
//  Created by Chris Kim on 2021/08/10.
//

import UIKit


/// 게시글에 선택한 이미지를 표시하는 컬렉션 뷰 셀
/// - Author: 김정민(kimjm010@icloud.com)
class ComposeImageCollectionViewCell: UICollectionViewCell {
    
    /// 게시글에 추가할 이미지뷰
    @IBOutlet weak var composeImageView: UIImageView!
    
    /// 이미지 컨테이너 뷰
    @IBOutlet weak var imageContainerView: UIView!
    
    
    /// 셀이 로드되면 UI를 초기화합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 15.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        imageContainerView.layer.cornerRadius = composeImageView.frame.height * 0.06
        imageContainerView.layer.masksToBounds = true
    }
}
