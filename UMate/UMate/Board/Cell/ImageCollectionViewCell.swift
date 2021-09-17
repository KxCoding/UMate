//
//  ImageCollectionViewCell.swift
//  UMate
//
//  Created by Chris Kim on 2021/08/10.
//

import UIKit


/// 사진첩에 있는 이미지를 표시하는 컬렉션뷰 셀
/// - Author: 김정민
class ImageCollectionViewCell: UICollectionViewCell {
    
    /// 이미지뷰
    @IBOutlet weak var imageView: UIImageView!
    
    /// 이미지의 선택여부에 따라 뷰를 흐리게할 속성
    @IBOutlet weak var overlayView: UIView!
    
    /// 이미지가 선택됐을 때의 속성
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    /// overlayView의 alpha값을 조절합니다.
    private func showOverlayView() {
        let alpha: CGFloat = isSelected ? 0.5 : 0.0
        overlayView.alpha = alpha
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        showOverlayView()
    }
    
    
    override var isSelected: Bool {
        didSet {
            showOverlayView()
            setNeedsLayout()
        }
    }
}
