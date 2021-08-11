//
//  FilterViewController.swift
//  FilterViewController
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit

class FilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    /// 취소 버튼을 누르면 검색화면으로 돌아갑니다.
    /// - Parameter sender: 버튼
    @IBAction func cancel(_ sender: Any) {
        NotificationCenter.default.post(name: .filterWillCancelled, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func applyFilterButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .filterWillCancelled, object: nil)
        dismiss(animated: true, completion: nil)
    }
}




extension Notification.Name {
    static let filterWillCancelled = Notification.Name(rawValue: "filterWillCancelled")
}




extension FilterViewController: UITableViewDataSource {
    /// 데이터소스 객체에게 지정된 섹션에 아이템 수를 물어봅니다.
    /// - Parameter tableView: 이 메소드를 호출하는 테이블뷰
    /// - Returns: 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    /// 데이터 소스 객체에게 지정된 섹션에 있는 행의 수를 물어봅니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - section: 테이블뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션에 있는 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "AlignmentTableViewCell", for: indexPath)
            
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath)
            
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "StoreTypeTableViewCell", for: indexPath)
            
        default:
            return UITableViewCell()
        }
    }
}
