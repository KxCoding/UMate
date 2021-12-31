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
    
    /// 뷰가 메모리에 로드되었을 때 데이터나 UI를 초기화합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTapBarAppearanceAsDefault()
    }
    
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
            return 2
        default:
            return 0
        }
    }
    
    
    /// 북마크 관리 메뉴가 선택되면 북마크 관리 화면을 표시합니다.
    /// 
    /// 목록 화면 공통 view controller를 사용합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 선택된 셀의 index path
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            guard let placeListVC = UIStoryboard(name: "PlaceList", bundle: nil).instantiateViewController(identifier: "PlaceListWithSimpleCell") as? PlaceListViewController else { return }
            
            placeListVC.navigationItem.title = "북마크 관리"
            placeListVC.viewType = .bookmark
            
            PlaceDataManager.shared.fetchBoomarkList(vc: placeListVC) { places in
                placeListVC.entireItems = places
                placeListVC.placeListTableView.reloadData()
            }
            
            if let nav = self.navigationController {
                nav.show(placeListVC, sender: nil)
            } else {
                self.present(UINavigationController(rootViewController: placeListVC), animated: true, completion: nil)
            }
        }
    }
}
