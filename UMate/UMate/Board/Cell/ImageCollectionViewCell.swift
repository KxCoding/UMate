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
    @IBOutlet weak var unselectedImageView: UIImageView!
    
    private var showSelectionIcons =  false
    
    
    func configure(with showSelectionIcons: Bool) {
        self.showSelectionIcons = showSelectionIcons
        showOverlayView()
    }
    
    
    private func showOverlayView() {
        let alpha: CGFloat = (isSelected && showSelectionIcons) ? 0.5 : 0.0
        selectedImageView.alpha = alpha
        overlayView.alpha = alpha
        unselectedImageView.alpha = showSelectionIcons ? 0.5 : 0.0
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        showSelectionIcons = false
        showOverlayView()
    }
    
    override var isSelected: Bool {
        didSet {
            showOverlayView()
            setNeedsLayout()
        }
    }
}
