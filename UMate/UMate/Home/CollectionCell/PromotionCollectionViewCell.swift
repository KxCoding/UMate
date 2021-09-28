//
//  PromotionCollectionViewCell.swift
//  PromotionCollectionViewCell
//
//  Created by 황신택 on 2021/09/13.
//

import UIKit

/// 채용정보 셀을 구성하는 클래스
/// Author: 황신택
class PromotionCollectionViewCell: UICollectionViewCell {

    /// 프로모션 카테고리 이미지
    @IBOutlet weak var promotionImageView: UIImageView!
    
    /// 프로모션 카테고리 레이블
    @IBOutlet weak var promotionLabel: UILabel!
    
    /// 프로모션 카테고리 플레이스홀더
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
