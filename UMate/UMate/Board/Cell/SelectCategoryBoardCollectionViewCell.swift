//
//  SelectCategoryBoardCollectionViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/09/29.
//

import UIKit

class SelectCategoryBoardCollectionViewCell: UICollectionViewCell {
    
    /// 게시판 카테고리를 선택할 수 있는 버튼
    /// 버튼의 선택 상테에 따라 버튼의 상태가 달라집니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    override var isSelected: Bool {
        /// 카테고리 선택시에 언더바 색상 변경
        didSet {
            if isSelected {
                selectCategoryButton.imageView?.image = UIImage(systemName: "circle.inset.filled")
                selectCategoryButton.tintColor = .systemRed
            } else {
                selectCategoryButton.imageView?.image = UIImage(systemName: "circle")
                selectCategoryButton.tintColor = .black
            }
        }
    }
}
