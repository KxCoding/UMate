//
//  NearbyPlaceCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import UIKit

class NearbyPlaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var keywordLabel1: UILabel!
    @IBOutlet weak var keywordContainer1: UIView!
    @IBOutlet weak var keywordLabel2: UILabel!
    @IBOutlet weak var keywordContainer2: UIView!
    @IBOutlet weak var placeImageView: UIImageView!
    
    var target: Place!
    
    /// 각 뷰들이 표시하는 content 초기화
    /// - Parameter content: 뷰에 표시할 내용을 담은 Place 객체
    func configure(with content: Place) {
        target = content
        
        placeNameLabel.text = target.name
        districtLabel.text = target.district
        keywordLabel1.text = target.keywords.first
        
        if target.keywords.count > 1 {
            keywordLabel2.text = target.keywords[1]
        } else {
            keywordContainer2.isHidden = true
        }
        
        if let image = target.images.first {
            placeImageView.image = image
        } else {
            placeImageView.image = UIImage(named: "dummy-image-landscape")
        }
        
    }
    
    /// 셀 내부 UI 초기화
    override func awakeFromNib() {
        self.configureStyle(with: [.squircleBig, .lightShadow])
        keywordContainer1.configureStyle(with: [.squircleSmall])
        keywordContainer2.configureStyle(with: [.squircleSmall])
    }
}
