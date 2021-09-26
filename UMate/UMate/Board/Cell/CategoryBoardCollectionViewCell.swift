//
//  CategoryBoardCollectionViewCell.swift
//  CategoryBoardCollectionViewCell
//
//  Created by 남정은 on 2021/08/03.
//

import UIKit


/// 카테고리 게시판에서 카테고리 목록을 나타내는 컬렉션 뷰 셀
/// - Author: 남정은
class CategoryBoardCollectionViewCell: UICollectionViewCell {
    /// 카테고리명
    @IBOutlet weak var categoryName: UILabel!
    
    /// 카테고리 선택여부를 나타내는 언더바
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
    
    
    /// 컬렉션 뷰 셀 초기화
    func configure(categoryNames: [String], indexPath: IndexPath) {
        categoryName.text = categoryNames[indexPath.row]
    }
}
