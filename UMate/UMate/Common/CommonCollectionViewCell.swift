//
//  CommonCollectionViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/12/01.
//

import UIKit


/// 홈화면 공통적으로 콜렉션 셀 모양을 초기화합니다.
/// - Author: 황신택 (sinadsl1457@gmail.com)
class CommonCollectionViewCell: UICollectionViewCell {
    /// 셀 바운드를 둥글게 만들어줍니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func makeCollectionCellRounded() {
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
    }
}
