//
//  LectureInfoCustomHeaderView.swift
//  UMate
//
//  Created by 남정은 on 2021/11/04.
//

import UIKit


/// 작성화면으로 이동
/// - Author: 남정은(dlsl7080@gmail.com)
extension Notification.Name {
    static let performSegueToWrite = Notification.Name("performSegueToWrite")
}



/// 강의정보 헤더뷰
/// - Author: 남정은(dlsl7080@gmail.com)
class LectureInfoCustomHeaderView: UITableViewHeaderFooterView {
    /// 배경색 뷰
    @IBOutlet weak var backView: UIView!
    
    /// 섹션이름 레이블
    @IBOutlet weak var sectionNameLabel: UILabel!
    
    /// 작성버튼
    @IBOutlet weak var writeButton: UIButton!
    
    
    /// DetailLectureReviewViewController에서 perfromSegue를 실행합니다.
    /// - Parameter sender: 작성버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func performSegueToWrite(_ sender: UIButton) {
        NotificationCenter.default.post(name: .performSegueToWrite, object: nil, userInfo: ["tag": sender.tag])
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        writeButton.setToEnabledButtonTheme()
    }
}
