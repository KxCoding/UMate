//
//  SelectCategoryBoardCollectionViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/09/29.
//

import UIKit

class SelectCategoryBoardCollectionViewCell: UICollectionViewCell {
    
    /// 게시판 카테고리를 표시할 레이블
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var selectCategoryLabel: UILabel!
    
    /// 선택된 카테고리를 표시할 이미지뷰
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    
    
    override var isSelected: Bool {
        /// 카테고리 선택시에 언더바 색상 변경
        didSet {
            if isSelected {
                selectedCategoryImageView.isHighlighted = true
                selectedCategoryImageView.tintColor = .systemRed
                selectCategoryLabel.textColor = .systemRed
            } else {
                selectedCategoryImageView.isHighlighted = false
                selectedCategoryImageView.tintColor = .black
                selectCategoryLabel.textColor = .black
            }
        }
    }
}
