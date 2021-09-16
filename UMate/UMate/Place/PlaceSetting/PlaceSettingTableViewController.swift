//
//  PlaceSettingTableViewController.swift
//  UMate
//
//  Created by Effie on 2021/09/09.
//

import UIKit


/// Place 관련 설정 메뉴 화면 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
class PlaceSettingTableViewController: UITableViewController {

    // MARK: View Lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: Table view data source
    
    /// 테이블 뷰에 표시할 section의 수
    /// - Parameter tableView: 테이블 뷰
    /// - Returns: 표시할 섹션의 수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    /// 각 섹션에 표시할 열의 수
    /// - Parameters:
    ///   - tableView: 적용할 테이블 뷰
    ///   - section: 각 섹션
    /// - Returns: 해당 섹션에 표시할 열의 수
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
