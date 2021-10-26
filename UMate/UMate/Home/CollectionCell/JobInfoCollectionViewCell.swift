//
//  JobInfoCollectionViewCell.swift
//  JobInfoCollectionViewCell
//
//  Created by 황신택 on 2021/09/13.
//

import UIKit

/// 홈 화면 구인정보 탭을 나타내는 콜렉션 뷰 셀
/// - Author: 황신택 (sinadsl1457@gmail.com)
class JobInfoCollectionViewCell: UICollectionViewCell {
    /// 구인 카테고리 이미지 뷰
    @IBOutlet weak var jobCategoryImageView: UIImageView!
    
    /// 구인 카테고리 레이블
    @IBOutlet weak var jobCategoryLabel: UILabel!
    
    /// 상세 내용 레이블
    @IBOutlet weak var detailLabel: UILabel!
    
    
    /// 구인정보 콜렉션 셀 바운드를 둥글게 초기화합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
    }
}
