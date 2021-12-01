//
//  ContestCollectionViewCell.swift
//  ContestCollectionViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

/// 홈 화면 대외활동 / 공모전 탭을 표시할 콜렉션 뷰 셀
/// - Author: 황신택 (sinadsl1457@gmail.com)
class ContestCollectionViewCell: CommonCollectionViewCell {
    /// 공모전 대외활동 타이틀 레이블
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 공모전 대외활동 플레이스 홀더 레이블
    @IBOutlet weak var detailLabel: UILabel!
    
    /// 공모전 대외활동 이미지 뷰
    @IBOutlet weak var contestImageView: UIImageView!
    
    
    /// 공모전 대외활동 콜렉션 셀 바운드를 둥글게 초기화합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        makeCollectionCellRounded()
    }
}
