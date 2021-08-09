//
//  PlaceMainViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import UIKit
import CoreLocation
import MapKit

class PlaceMainViewController: UIViewController {
    
    
    /// Location Manager
    lazy var locationManager: CLLocationManager = { [weak self] in
        
        let m = CLLocationManager()
        guard let self = self else { return m }
        
        m.desiredAccuracy = kCLLocationAccuracyBest
        m.delegate = self
        
        return m
    }()
    
    // MARK: outlets
    
    /// 지도를 표시할 뷰
    @IBOutlet weak var mapView: MKMapView!
    
    /// 상단 플로팅 뷰
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var searchBtnContainer: UIView!
    
    /// 하단 플로팅 컬렉션
    @IBOutlet weak var nearbyPlaceCollectionView: UICollectionView!
    
    
    // MARK: 기타 속성
    
    /// 컬렉션 뷰가 현재 표시하는 아이템의 인덱스
    var selecteditemIndex = 0
    
    /// 위치에 따라 컬렉션 뷰에 리스팅할 가게 배열
    var list = [Place]()
    
    /// 컬렉션 뷰 데이터에 따라 지도에 표시할 마커
    lazy var allAnnotations: [MKAnnotation] = { [weak self] in
        var arr = [MKAnnotation]()
        
        guard let self = self else { return arr }
        
        for place in self.list {
            guard let coor = place.coordinate else { continue }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coor
            annotation.title = place.name
            
            arr.append(annotation)
            
        }
        
        return arr
    }()
    
    
    /// 플로팅 뷰를 위한 lauout을 설정해서 리턴하는 메소드
    /// - Returns: layout 객체
    func compositionalLayout() -> UICollectionViewLayout {
        
        /// item 생성 및 설정
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        /// item을 포함하는 group 생성 및 설정
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        /// group을 포함하는 section 생성 및 설정
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        /// modification handler
        /// 컬렉션 뷰를 움직일 때마다 실행할 작업
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, scrollOffset, layoutEnvironment in
            guard let self = self else { return }
            
            //print(scrollOffset)
            
            self.selecteditemIndex = Int((scrollOffset.x + 19) / 337)
            
            let selectedItem = self.list[self.selecteditemIndex]
            
            guard let coord = selectedItem.coordinate else { return }
            
            //            #if DEBUG
            //            if
            //            print("------------------------", "\n",
            //                  "index-----", self.selecteditemIndex, "\n",
            //                  "선택된 가게--", selectedItem.name, "\n",
            //                  "좌표-------", coord.latitude, "/", coord.longitude,
            //                  separator: "")
            //            #endif
            
            /// 아이템의 좌표를 지도 중앙에 표시
            self.mapView.setCenter(coord, animated: true)
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: VC lifecycle method
    
    /// 탭의 메인 화면이 표시되기 전에 처리할 작업을 수행합니다. - 위치 관련 권한 요청
    /// - Parameter animated: 애니메이션 사용 여부
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus
            
            if #available(iOS 14.0, *) {
                status = locationManager.authorizationStatus
                
                #if DEBUG
                print(status.description)
                #endif
            } else {
                status = CLLocationManager.authorizationStatus()
            }
            
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                tempAlert(title: "위치 서비스 권한 제한",
                          msg: "현재 위치를 표시할 수 없을 거예요",
                          actionMsg: "오케이")
                break
            case .authorizedWhenInUse, .authorizedAlways:
                updateLocation()
                break
            default:
                break
            }
        } else {
            tempAlert(title: "위치 서비스 권한 제한",
                      msg: "현재 위치를 표시할 수 없을 거예요",
                      actionMsg: "오케이")
        }
    }
    
    
    
    /// 화면 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// map view 초기화
        /// 첫 번째 아이템 or 학교 대표 좌표
        let initialCenterCoor = list.first?.coordinate ?? CLLocationCoordinate2D(latitude: 37.545621, longitude: 126.965011)
        let region = MKCoordinateRegion(center: initialCenterCoor,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        /// UI 초기화
        locationContainer.configureStyle(with: [.pillShape, .lightBorder])
        searchBtnContainer.configureStyle(with: [.pillShape, .lightBorder])
        
        /// 더미데이터 저장
        list.append(contentsOf: Place.dummyData)
        
        /// 델리게이션
        nearbyPlaceCollectionView.dataSource = self
        nearbyPlaceCollectionView.delegate = self
        
        /// 컬렉션 뷰 세팅
        nearbyPlaceCollectionView.isScrollEnabled = false
        nearbyPlaceCollectionView.isPagingEnabled = true
        nearbyPlaceCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        nearbyPlaceCollectionView.collectionViewLayout = compositionalLayout()
        
        /// 지도에 컬렉션 아이템을 마커로 표시
        mapView.addAnnotations(allAnnotations)
        
    }
    
    
    /// VC에게 segue가 곧 실행됨을 알리는 메소드
    /// - Parameters:
    ///   - segue: segue에 포함된 vc 정보(desination)를 포함하고 있는 segue
    ///   - sender: segue를 실행시키는 트리거 객체
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? NearbyPlaceCollectionViewCell, let indexPath = nearbyPlaceCollectionView.indexPath(for: cell) {
            if let vc = segue.destination as? PlaceInfoViewController {
                vc.place = list[indexPath.item]   
            }
        }
    }
    
}




// MARK: TableView Delegation

extension PlaceMainViewController: UICollectionViewDataSource {
    
    /// 지정된 섹션에서 몇 개의 item을 표시할 건지 data source에게 묻는 메소드
    /// - Parameters:
    ///   - collectionView: 이 정보를 요청하는 collection view
    ///   - section: 컬렉션 뷰의 특정 섹션을 가리키는 index number
    /// - Returns: 섹션에 포함되는 아이템의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /// data source에게 컬렉션 뷰에서 특정 indexpath의 아이템에 응하는 셀을 요청하는 메소드
    /// - Parameters:
    ///   - collectionView: 이 정보를 요청하는 collection view
    ///   - indexPath: 아이템의 위치를 가리키는 indexpath
    /// - Returns: 완성된 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyPlaceCollectionViewCell", for: indexPath) as! NearbyPlaceCollectionViewCell
        
        cell.configure(with: list[indexPath.item])
        
        return cell
    }
}




extension PlaceMainViewController: UICollectionViewDelegateFlowLayout {
    
    /// 지정된 셀의 크기를 delegate에게 요청하는 메소드
    /// - Parameters:
    ///   - collectionView: 이 정보를 요청하는 collection view
    ///   - collectionViewLayout: 이 정보를 요청하는 layout 객체
    ///   - indexPath: 아이템의 위치를 가리키는 indexpath
    /// - Returns: 높이와 너비
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 48
        let height = CGFloat(120)
        return CGSize(width: width, height: height)
    }
}



// MARK: Location Manager Delegate
extension PlaceMainViewController: CLLocationManagerDelegate {
    
    /// 위치 업데이트
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    /// [iOS 14 이후 버전] 권한이 변경되면 수행할 작업
    /// - Parameter manager: location manager
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            tempAlert(title: "위치 서비스 권한 제한",
                      msg: "현재 위치를 표시할 수 없을 거예요",
                      actionMsg: "오케이")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocation()
            break
        default:
            break
        }
    }
    
    
    /// [iOS 14 이전 버전] 권한이 변경되면 수행할 작업
    /// - Parameters:
    ///   - manager: location manager
    ///   - status: 변경된 권한 상태
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            tempAlert(title: "위치 서비스 권한 제한",
                      msg: "현재 위치를 표시할 수 없을 거예요",
                      actionMsg: "오케이")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocation()
            break
        default:
            break
        }
    }
    
    
    /// 위치가 업데이트 되면 수행할 작업 (위치 관련 작업은 모두 메인 스레드에서 실행됨)
    /// - Parameters:
    ///   - manager: location manager
    ///   - locations: 업데이트 된 위치
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let current = locations.last {
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(current,
                                            preferredLocale: Locale(identifier: "ko_kr"))
            { [weak self] placeMarks, error in
                guard let self = self else { return }
                
                if let error = error {
                    print(error)
                }
                
                if let place = placeMarks?.first {
                    let si = place.administrativeArea ?? ""
                    let gu = place.locality ?? ""
                    let dong = place.thoroughfare ?? ""
                    let number = place.subThoroughfare ?? ""
                    
                    self.currentLocationLabel.text = si + " " + gu + " " + dong + " " + number
                }
            }
        }
        
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
    
    
}



// MARK: Temp VC extension
extension UIViewController {
    
    func tempAlert(title: String, msg: String, actionMsg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionMsg, style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}




// MARK: CLAuthorizationStatus extension
extension CLAuthorizationStatus: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        @unknown default:
            return ""
        }
    }
}
