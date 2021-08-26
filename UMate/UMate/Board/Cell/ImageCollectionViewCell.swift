//
//  ImageCollectionViewCell.swift
//  UMate
//
//  Created by Chris Kim on 2021/08/10.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    /// overlayView의 alpha값을 조절하는 메소드
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
