//
//  ContestCollectionViewCell.swift
//  ContestCollectionViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

class ContestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
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
