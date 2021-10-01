//
//  SelectCategoryBoardCollectionViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/09/29.
//

import UIKit


/// 게시판의 카테고리를 컬레션뷰 셀
/// - Author: 김정민(kimjm010@icloud.com)
class SelectCategoryBoardCollectionViewCell: UICollectionViewCell {
    
    /// 게시판 카테고리를 선택할 수 있는 버튼
    /// 버튼의 선택 상테에 따라 버튼의 상태가 달라집니다.
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    override var isSelected: Bool {
        // 카테고리 선택 상태에 따라 다른 이미지 및 tintColor 표시
        didSet {
            selectCategoryButton.imageView?.image = isSelected ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle")
            selectCategoryButton.tintColor = isSelected ? .systemRed : .black
        }
    }
}
