//
//  ImageCollectionViewCell.swift
//  UMate
//
//  Created by Chris Kim on 2021/08/10.
//

import UIKit


/// 사진첩에 있는 이미지를 표시하는 컬렉션 뷰 셀
/// - Author: 김정민(kimjm010@icloud.com)
class ImageCollectionViewCell: UICollectionViewCell {
    
    /// 이미지뷰 아울렛
    @IBOutlet weak var imageView: UIImageView!
    
    /// 이미지의 선택여부에 따라 이미지 뷰를 흐리게할 Overlay View
    @IBOutlet weak var overlayView: UIView!
    
    /// 이미지가 선택됐을 때 체크마크를 표시하기 위한 이미지 뷰
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    /// overlayView의 alpha값을 조절합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    private func showOverlayView() {
        let alpha: CGFloat = isSelected ? 0.5 : 0.0
        overlayView.alpha = alpha
    }
    
    
    /// 셀의 선택 상태 및 alpha값을 리셋합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        showOverlayView()
    }
    
    
    /// 이미지 뷰 셀의 선택 상태 확인
    override var isSelected: Bool {
        didSet {
            showOverlayView()
            setNeedsLayout()
        }
    }
}
