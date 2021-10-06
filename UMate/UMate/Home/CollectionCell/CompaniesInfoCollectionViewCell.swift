//
//  PromotionCollectionViewCell.swift
//  PromotionCollectionViewCell
//
//  Created by 황신택 on 2021/09/13.
//

import UIKit

/// 구인 정보 화면
/// Author: 황신택(sinadsl1457@gmail.com)
class CompaniesInfoCollectionViewCell: UICollectionViewCell {
    /// 구인 카테고리 이미지뷰
    @IBOutlet weak var companyCategoryImageView: UIImageView!
    
    /// 구인 카테고리 레이블
    @IBOutlet weak var companyCategoryLabel: UILabel!
    
    /// 상세내용
    @IBOutlet weak var detailLabel: UILabel!
    
    /// 구인정보 콜렉션 셀 바운드를 둥글게 초기화 합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
    }

}
