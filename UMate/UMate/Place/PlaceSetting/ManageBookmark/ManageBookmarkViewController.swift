//
//  ManageBookmarkViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import UIKit

class ManageBookmarkViewController: UIViewController {
    
    /// 화면에 표시되는 테이블 뷰
    @IBOutlet weak var bookmarkListTableView: UITableView!
    
    /// 현재 선택된 가게 타입
    var selectedPlaceType: Place.PlaceType? = nil
    
    /// 북마크된 데이터
    var bookmarkedItems: [Place] {
        /// 일단 전체 데이터 - 수정 예정
        return Place.dummyData
    }
    
    /// 테이블에 표시할 가게 데이터
    var list: [Place] {
        let entire = bookmarkedItems
        if let type = selectedPlaceType {
            return entire.filter { $0.type == type }
        } else {
            return entire
        }
    }
    
    // MARK: View Lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// table view delegation
        bookmarkListTableView.dataSource = self
        bookmarkListTableView.delegate = self
        
        /// 카테고리 선택 상태를 팔로우하는 옵저버 추가
        NotificationCenter.default.addObserver(forName: .selectedPlaceTypeHasBeenChanged, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            guard let selectedType = noti.userInfo?["selectedPlaceType"] as? Place.PlaceType else { return }
            
            print(selectedType.rawValue, "has selected")
            
            self.selectedPlaceType = selectedType
            
        }
    }
    
}




// MARK: TableView Delegation

extension ManageBookmarkViewController: UITableViewDataSource {

    /// 테이블 뷰에 표시할 섹션의 수를 제공하는 메소드
    /// - Parameter tableView: 테이블 뷰
    /// - Returns: 테이블 뷰에 표시할 섹션의 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    /// 각 섹션에 표시할 항목의 수를 제공하는 메소드
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - section: 해당 섹션
    /// - Returns: 각 섹션에 표시될 항목의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }

    
    /// 각 항목에 표시할 셀을 제공하는 메소드
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 해당 항목의 indexPath
    /// - Returns: 각 항목에 표시할 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "PlaceTypeSelectionTableViewCell", for: indexPath) as! PlaceTypeSelectionTableViewCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkListTableViewCell", for: indexPath) as! BookmarkListTableViewCell
            
//            cell.configure(with: <#T##Place#>)
            return cell
        }
    }
    
    

}




extension ManageBookmarkViewController: UITableViewDelegate {
    
    /// 각 항목이 표시할 셀의 높이를 제공하는 메소드
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 항목의 indexPath
    /// - Returns: 각 항목이 표시할 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            print(tableView.frame.width / 3)
            return tableView.frame.height / 5
        } else {
            return tableView.frame.width / 3
        }
    }
    
    
    /// 항목이 선택되면 작업을 실행하는 메소드 - 선택 상태를 즉시 해제
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 선택된 항목의 indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

