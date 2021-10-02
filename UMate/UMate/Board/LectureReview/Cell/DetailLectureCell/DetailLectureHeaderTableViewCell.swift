//
//  DetailLectureHeaderTableViewCell.swift
//  DetailLectureHeaderTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit


/// 강의 정보의 섹션을 나누는 헤더 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class DetailLectureHeaderTableViewCell: UITableViewCell {
    /// 섹션이름 레이블
    @IBOutlet weak var sectionNameLabel: UILabel!
    
    /// 작성버튼
    @IBOutlet weak var writeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        writeButton.setToEnabledButtonTheme()
    }
}
