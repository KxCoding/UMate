//
//  SectionTitleCollectionViewCell.swift
//  SectionTitleCollectionViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit


/// 강의정보 섹션에 해당하는 것을 컬렉션 뷰로 강의 정보 위에 표시하는 셀
/// - Author: 남정은(dlsl7080@gamil.com)
class SectionTitleCollectionViewCell: UICollectionViewCell {
    /// 섹션의 이름을 나타내는 레이블
    @IBOutlet weak var sectionTtileLabel: UILabel!
    
    
    /// 카테고리 선택시에 타이틀 색상 변경
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3) {
                    self.sectionTtileLabel.textColor = UIColor.init(named: "blackSelectedColor")
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.sectionTtileLabel.textColor = .lightGray
                }
            }
        }
    }
}
