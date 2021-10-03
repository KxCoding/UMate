//
//  FilterViewController.swift
//  FilterViewController
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit


extension Notification.Name {
    /// 필터 화면에서 취소 버튼이 눌렸을 때 보낼 노티피케이션
    /// - Author: 장현우(heoun3089@gmail.com)
    static let filterWillCancelled = Notification.Name(rawValue: "filterWillCancelled")
    
    /// 필터 화면에서 적용 버튼을 눌렀을 때 보낼 노티피케이션
    /// - Author: 장현우(heoun3089@gmail.com)
    static let filterWillApplied = Notification.Name(rawValue: "filterWillApplied")
}



/// 필터 화면과 관련된 뷰컨트롤러 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class FilterViewController: UIViewController {
    /// 필터 화면을 표시할 테이블뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var filterTableView: UITableView!
    
    /// StoreTypeTableViewCell의 storeTypeFilterArray 배열을 저장할 배열
    /// - Author: 장현우(heoun3089@gmail.com)
    var list = [Place.PlaceType]()
    
    /// 이전 화면에서의 filterList를 받아올 배열
    /// - Author: 장현우(heoun3089@gmail.com)
    var filterList: [Place.PlaceType]?
    
    
    /// 취소 버튼을 누르면 검색화면으로 돌아갑니다.
    /// - Parameter sender: 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        NotificationCenter.default.post(name: .filterWillCancelled, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 필터 적용 버튼을 누르면 필터링할 항목을 이전화면으로 보내고 검색화면으로 돌아갑니다.
    /// - Parameter sender: 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func applyFilterButtonTapped(_ sender: Any) {
        if let cell = filterTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? StoreTypeTableViewCell {
            list = cell.storeTypeFilterArray
            
            NotificationCenter.default.post(name: .filterWillApplied, object: nil, userInfo: ["filterItem": list])
        }
        
        dismiss(animated: true, completion: nil)
    }
}



extension FilterViewController: UITableViewDataSource {
    /// 데이터 소스 객체에게 지정된 섹션에 있는 행의 수를 물어봅니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - section: 테이블뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션에 있는 행의 수
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "AlignmentTableViewCell", for: indexPath)
            
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath)
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTypeTableViewCell", for: indexPath) as! StoreTypeTableViewCell
            
            if let filterList = filterList {
                for filterType in filterList {
                    switch filterType {
                    case .cafe:
                        cell.caffeButtonTapped(self)
                        
                    case .restaurant:
                        cell.restauranteButtonTapped(self)
                        
                    case .bakery:
                        cell.bakeryButtonTapped(self)
                        
                    case .studyCafe:
                        cell.studyCafeButtonTapped(self)
                        
                    case .pub:
                        cell.pubButtonTapped(self)
                        
                    case .dessert:
                        cell.desertButtonTapped(self)
                    }
                }
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    /// 데이터소스 객체에게 지정된 섹션에 아이템 수를 물어봅니다.
    /// - Parameter tableView: 이 메소드를 호출하는 테이블뷰
    /// - Returns: 섹션의 개수
    /// - Author: 장현우(heoun3089@gmail.com)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}
