//
//  PlaceSettingTableViewController.swift
//  UMate
//
//  Created by Effie on 2021/09/09.
//

import UIKit


/// Place 설정 메뉴 화면
/// - Author: 박혜정(mailmelater11@gmail.com)
class PlaceSettingTableViewController: UITableViewController {
    
    /// 테이블 뷰에서 표시할 섹션의 개수를 리턴합니다.
    /// - Parameter tableView: 테이블 뷰
    /// - Returns: 섹션의 개수
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    /// 지정된 섹션에서 표시할 항목의 개수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 포함되는 항목의 개수
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 0
        }
    }
}
