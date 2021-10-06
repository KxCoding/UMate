//
//  FilterViewController.swift
//  FilterViewController
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import CoreLocation
import UIKit


extension Notification.Name {
    /// 필터 화면에서 취소 버튼이 눌렸을 때 보낼 노티피케이션
    static let filterWillCancelled = Notification.Name(rawValue: "filterWillCancelled")
    
    /// 필터 화면에서 적용 버튼을 눌렀을 때 보낼 노티피케이션
    static let filterWillApplied = Notification.Name(rawValue: "filterWillApplied")
    
    /// 거리순 정렬 버튼이 눌렸을 때 보낼 노티피케이션
    static let sortByDistanceButtonSeleted = Notification.Name(rawValue: "sortByDistanceButtonSeleted")
}



/// 필터 화면
/// - Author: 장현우(heoun3089@gmail.com)
class FilterViewController: UIViewController {
    
    /// 필터 화면  테이블뷰
    @IBOutlet weak var filterTableView: UITableView!
    
    /// 가게 종류 배열
    ///
    /// 셀에 저장되어 있는 가게 종류 타입을 저장하기 위한 배열입니다.
    var list = [Place.PlaceType]()
    
    /// 이전 화면의 필터링된 항목을 받아올 배열
    var filterList: [Place.PlaceType]?
    
    /// 이전 화면의 가게 목록을 받아올 배열
    var placeList = [Place]()
    
    /// 이전 화면에서 위치 정보를 받아오기 위한 속성
    var userLocation: CLLocation?
    
    /// 이전 화면에서 거리순 필터링 활성화 정보를 받아오기 위한 속성
    var distanceFilterOn: Bool?
    
    
    /// 취소 버튼을 누르면 검색화면으로 돌아갑니다.
    /// - Parameter sender: 취소 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        NotificationCenter.default.post(name: .filterWillCancelled, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 거리순으로 정렬합니다.
    ///
    /// 가게 목록을 거리를 기준으로 오름차순 정렬합니다.
    /// - Parameter sender: 거리순 정렬 버튼
    @IBAction func sortByDistance(_ sender: Any) {
        guard let userLocation = userLocation else {
            return
        }
        
        placeList.sort { firstPlace, secondPlace in
            let firstPlaceCLLocation = CLLocation(latitude: firstPlace.latitude, longitude: firstPlace.longitude)
            let secondPlaceCLLocation = CLLocation(latitude: secondPlace.latitude, longitude: secondPlace.longitude)
            
            return userLocation.distance(from: firstPlaceCLLocation) < userLocation.distance(from: secondPlaceCLLocation)
        }
        
        NotificationCenter.default.post(name: .sortByDistanceButtonSeleted, object: nil, userInfo: ["list": placeList])
    }
    
    
    /// 필터링할 항목을 이전화면으로 보내고 검색화면으로 돌아갑니다.
    /// - Parameter sender: 필터 적용 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func applyFilterButtonTapped(_ sender: Any) {
        if let cell = filterTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? StoreTypeTableViewCell {
            list = cell.storeTypeFilterArray
            
            NotificationCenter.default.post(name: .filterWillApplied, object: nil, userInfo: ["filterItem": list])
        }
        
        dismiss(animated: true, completion: nil)
    }
}



/// 필터 화면  테이블뷰 데이터 관리
extension FilterViewController: UITableViewDataSource {
    /// 섹션 행의 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 필터 화면  테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 행의 수
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    /// 섹션에 따라 셀을 구성합니다.
    ///
    /// 첫번째 섹션에는 정렬 관련 버튼을 표시하는 셀을 구성합니다.
    /// 두번째 섹션에는 카테고리 관련 버튼을 표시하는 셀을 구성합니다.
    /// 세번째 섹션에는 가게종류 관련 버튼을 표시하는 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 필터 화면  테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 구성한 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlignmentTableViewCell", for: indexPath) as! AlignmentTableViewCell
            
            guard let _ = userLocation else {
                cell.distanceButton.isEnabled = false
                cell.distanceButton.layer.opacity = 0.5
                
                return cell
            }
            
            if let distanceFilterOn = distanceFilterOn {
                if distanceFilterOn {
                    cell.alignmentSelectLineButtonTapped(cell.distanceButton)
                }
            }
            
            return cell
            
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
    
    
    /// 섹션의 개수를 리턴합니다.
    /// - Parameter tableView: 필터 화면  테이블뷰
    /// - Returns: 섹션의 개수
    /// - Author: 장현우(heoun3089@gmail.com)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}
