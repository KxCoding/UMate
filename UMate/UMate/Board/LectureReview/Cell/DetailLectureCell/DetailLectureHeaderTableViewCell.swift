//
//  DetailLectureHeaderTableViewCell.swift
//  DetailLectureHeaderTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit


/// 강의정보의 섹션을 나누는 헤더 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gamil.com)
class DetailLectureHeaderTableViewCell: UITableViewCell {
    /// 섹션이름을 나타내는 레이블
    @IBOutlet weak var sectionNameLabel: UILabel!
    
    /// 작성버튼을 나타내는 뷰
    @IBOutlet weak var writeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        writeButton.setToEnabledButtonTheme()
    }
}
