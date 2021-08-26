//
//  CategoryBoardCollectionViewCell.swift
//  CategoryBoardCollectionViewCell
//
//  Created by 남정은 on 2021/08/03.
//

import UIKit

class CategoryBoardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryView: UIView!
    
    
    override var isSelected: Bool {
        /// 카테고리 선택시에 언더바 색상 변경 
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3) {
                    self.categoryView.backgroundColor = UIColor.init(named: "blackSelectedColor")
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.categoryView.backgroundColor = UIColor.init(named: "barColor")
                }
            }
        }
    }
    
    
    func configure(categoryNames: [String], indexPath: IndexPath) {
        categoryName.text = categoryNames[indexPath.row]
    }
}
