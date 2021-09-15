//
//  PromotionCollectionViewCell.swift
//  PromotionCollectionViewCell
//
//  Created by 황신택 on 2021/09/13.
//

import UIKit

class PromotionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var promotionImageView: UIImageView!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    /// 채용정보 콜렉션뷰 둥글게 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
    }

}
