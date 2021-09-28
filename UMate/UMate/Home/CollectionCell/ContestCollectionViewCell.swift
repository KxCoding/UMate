//
//  ContestCollectionViewCell.swift
//  ContestCollectionViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

/// 공모전/ 대외활동 셀을 구성하는 클래스
/// Author: 황신택
class ContestCollectionViewCell: UICollectionViewCell {
    /// 공모전 대외활동 타이틀
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 공모전 대외활동 플레이스홀더 내용
    @IBOutlet weak var detailLabel: UILabel!
    
    /// 공모전 대외활동 이미지
    @IBOutlet weak var contestImageView: UIImageView!
    
    /// 공모전 대외활동 콜렉션뷰 둥글게 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
    }
}
