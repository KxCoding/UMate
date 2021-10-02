//
//  CategoryBoardCollectionViewCell.swift
//  CategoryBoardCollectionViewCell
//
//  Created by 남정은 on 2021/08/03.
//

import UIKit


/// 카테고리 게시판에 있는 카테고리 목록 컬렉션 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class CategoryBoardCollectionViewCell: UICollectionViewCell {
    /// 카테고리명 레이블
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    /// 카테고리 선택여부를 나타내는 언더바 뷰
    @IBOutlet weak var categoryView: UIView!
    
    
    override var isSelected: Bool {
        // 카테고리 선택시에 언더바 색상 변경
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
    
    
    /// 카테고리 셀을 초기화합니다.
    /// - Parameters:
    ///   - categoryNames: 카테고리 이름을 담은 배열
    ///   - indexPath: 카테고리 이름을 나타낼 indexPath
    func configure(categoryNames: [String], indexPath: IndexPath) {
        categoryNameLabel.text = categoryNames[indexPath.row]
    }
}
