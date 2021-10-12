//
//  MainCollectionViewCell.swift
//  MainCollectionViewCell
//
//  Created by 황신택 on 2021/09/11.
//

import UIKit
/// 홈화면
/// - Author: 황신택 (sinadsl1457@gmail.com)
class MainCollectionViewCell: UICollectionViewCell {
    /// 카테고리 이름
    @IBOutlet weak var title: UILabel!
    
    /// 카테고리 이미지 뷰
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    
    /// 홈 화면 컬렉션 셀 바운드를 둥글게 초기화합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
    }
}
