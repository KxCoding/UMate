//
//  EmploymentCollectionViewCell.swift
//  EmploymentCollectionViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

class EmploymentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var classification: UILabel!
    
    /// 직업 조건 콜렉션뷰 둥글게 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
    }
    
    func configure(with model: Classification) {
        major.text = model.title
        classification.text = model.detail
    }
}



