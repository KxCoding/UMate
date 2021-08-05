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
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3) {
                    self.categoryView.backgroundColor = .black
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.categoryView.backgroundColor = .white
                }
            }
        }
    }
    
    func configure(categories: [String], indexPath: IndexPath) {
        categoryName.text = categories[indexPath.row]
    }
}
