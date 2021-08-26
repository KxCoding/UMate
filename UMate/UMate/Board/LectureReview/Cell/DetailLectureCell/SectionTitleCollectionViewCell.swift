//
//  SectionTitleCollectionViewCell.swift
//  SectionTitleCollectionViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit

class SectionTitleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sectionTtileLabel: UILabel!
    
    
    override var isSelected: Bool {
        /// 카테고리 선택시에 타이틀 색상 변경
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3) {
                    self.sectionTtileLabel.textColor = UIColor.init(named: "blackSelectedColor")
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.sectionTtileLabel.textColor = .lightGray
                }
            }
        }
    }
}
