//
//  SelectCategoryBoardCollectionViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/09/29.
//

import UIKit


/// 카테고리 컬렉션뷰 셀
/// - Author: 김정민(kimjm010@icloud.com)
class SelectCategoryBoardCollectionViewCell: UICollectionViewCell {
    
    /// 카테고리 이미지뷰
    @IBOutlet weak var categoryImageView: UIImageView!
    
    /// 카테고리 이름 레이블
    @IBOutlet weak var categoryLabel: UILabel!
    
    /// 카테고리 상태 확인
    /// 
    /// 선택 상태에 따라 다른 이미지를 표시합니다.
    override var isSelected: Bool {
        // 카테고리 선택 상태에 따라 다른 이미지 및 tintColor 표시
        didSet {
            categoryImageView.image = isSelected ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle")
        }
    }
    
    
    /// 카테고리 셀을 초기화합니다.
    /// - Parameters:
    ///   - categoryNames: 카테고리 이름을 저장한 배열
    ///   - indexPath: 카테고리 이름의 indexPath
    func configure(with categoryNames: [String], indexPath: IndexPath) {
        categoryLabel.text = categoryNames[indexPath.item + 1]
    }
}
