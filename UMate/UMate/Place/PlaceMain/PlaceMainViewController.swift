//
//  PlaceMainViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import UIKit
import CoreLocation
import MapKit
import AVFoundation

class PlaceMainViewController: UIViewController {
    
    // MARK: Outlets
    
    /// 지도를 표시할 뷰
    @IBOutlet weak var mapView: MKMapView!
    
    /// 상단 플로팅 뷰
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var searchBtnContainer: UIView!
    
    /// 하단 플로팅 컬렉션
    @IBOutlet weak var nearbyPlaceCollectionView: UICollectionView!
    
    
    // MARK: 기타 속성
    
    /// Location Manager
    lazy var locationManager: CLLocationManager = { [weak self] in
        
        let m = CLLocationManager()
        guard let self = self else { return m }
        
        m.desiredAccuracy = kCLLocationAccuracyBest
        m.delegate = self
        
        return m
    }()
    
    /// 위치 관련 알림을 제어할 플래그
    var locationAlertHasShownAlready = false
    
    /// 컬렉션 뷰가 현재 표시하는 아이템의 인덱스
    var selectedListItemIndex = 0
    
    /// collection view cell과 annotation selection의 순환 호출을 방지할 플래그
    var isAnnotationSelected = false /// deprecated
    
    /// 사용자
    var user = PlaceUser.tempUser
    
    /// 위치에 따라 컬렉션 뷰에 리스팅할 가게 배열
    var list = [Place]()
    
    /// 학교 좌표 - 현재는 임시값 저장
    var universityCoordinate: CLLocationCoordinate2D {
        return user.university?.coordinate ?? University.tempUniversity.coordinate
    }
    
    /// 컬렉션 뷰 데이터에 따라 지도에 표시할 마커
    lazy var allAnnotations: [MKAnnotation] = { [weak self] in
        var arr = [MKAnnotation]()
        
        guard let self = self else { return arr }
        
        list.forEach { arr.append($0.annotation) }
        
        return arr
    }()
    
    
    /// annotation view 타입 등록
    private func registerMapAnnotationViews() {
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: NSStringFromClass(PlaceAnnotation.self))
    }
    
    
    /// 플로팅 뷰를 위한 lauout을 설정해서 리턴하는 메소드
    /// - Returns: layout 객체
    private func configureLayout() -> UICollectionViewLayout {
        
        /// item 생성 및 설정
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5,
                                                     bottom: 0, trailing: 5)
        
        /// item을 포함하는 group 생성 및 설정
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        
        /// group을 포함하는 section 생성 및 설정
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        /// modification handler
        /// 컬렉션 뷰를 움직일 때마다 실행할 작업
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, scrollOffset, layoutEnvironment in
            guard let self = self else { return }
            
            /// 선택된 아이템의 인덱스
            let selectedItemIndex = Int((scrollOffset.x + 20.7) / 337)
            
            /// 선택된 place
            let selectedItem = self.list[selectedItemIndex]
            
            /// 아이템의 좌표를 지도 중앙에 표시
            self.mapView.setCenter(selectedItem.coordinate, animated: true)
            
            /// 셀을 움직이면 같은 가게를 표시하는 annotation을 검색
            guard let selectedAnnotation = self.mapView.annotations.first(where: { annot in
                if let annot = annot as? PlaceAnnotation {
                    return annot.placeId == selectedItem.id
                } else { return false }
            }) else { return }
            
            /// annotation을 선택
            self.mapView.selectAnnotation(selectedAnnotation, animated: true)
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    
    // MARK: View Liftcycle method
    
    /// 화면 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 데이터 로드
        guard let result = DataManager.shared.getObjectFromBundle(fileName: "places.json", type: PlaceList.self) else { return }
        
        /// 사용자 데이터에 추가 (수정 예정)
        user.university?.places = result.places
        user.university?.name = result.university
        
        /// 더미 데이터에 추가 (수정 예정)
        Place.dummyData = result.places
        
        /// 화면에 표시할 리스트에 추가 [좌표 순으로 정렬 - 좌 -> 우]
        list = result.places.sorted(by: { return $0.coordinate.longitude < $1.coordinate.longitude })
        
        
        /// map view 설정
        mapView.delegate = self
        mapView.showsUserLocation = true
        registerMapAnnotationViews()
        
        /// 첫 번째 아이템 or 학교 대표 좌표
        let initialCenterCoor = list.first?.coordinate ?? universityCoordinate
        let region = MKCoordinateRegion(center: initialCenterCoor,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        /// annotation 추가
        mapView.addAnnotations(allAnnotations)
        
        /// 상단 UI 초기화
        locationContainer.configureStyle(with: [.pillShape, .lightBorder, .lightShadow])
        searchBtnContainer.configureStyle(with: [.pillShape, .lightBorder, .lightShadow])
        
        /// collectionview 델리게이션
        nearbyPlaceCollectionView.dataSource = self
        nearbyPlaceCollectionView.delegate = self
        
        /// 컬렉션 뷰 세팅
        nearbyPlaceCollectionView.isScrollEnabled = false
        nearbyPlaceCollectionView.isPagingEnabled = true
        nearbyPlaceCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        nearbyPlaceCollectionView.collectionViewLayout = configureLayout()
        
    }
    
    
    /// 탭의 메인 화면이 표시되기 전에 처리할 작업을 수행합니다 - 위치 관련 권한 요청
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
                if locationAlertHasShownAlready { break }
                alert(message: "위치 서비스 권한이 제한되어\n현재 위치를 표시할 수 없습니다")
                locationAlertHasShownAlready = true
                
            case .authorizedWhenInUse, .authorizedAlways:
                updateLocation()
                break
                
            default:
                break
            }
        } else {
//            if locationAlertHasShownAlready { return }
            alert(message: "위치 서비스 권한이 제한되어\n현재 위치를 표시할 수 없습니다")
            locationAlertHasShownAlready = true
        }
    }
    
    
    /// VC에게 segue가 곧 실행됨을 알리는 메소드
    /// - Parameters:
    ///   - segue: segue에 포함된 vc 정보(desination)를 포함하고 있는 segue
    ///   - sender: segue를 실행시키는 트리거 객체
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? NearbyPlaceCollectionViewCell,
           let indexPath = nearbyPlaceCollectionView.indexPath(for: cell) {
            if let vc = segue.destination as? PlaceInfoViewController {
                vc.place = list[indexPath.item]
            }
        }
    }
    
}




// MARK: - Map View Delegation

extension PlaceMainViewController: MKMapViewDelegate {
    
    /// annotation view가 선택되었을 때  작업을 실행하는 메소드. annotation의 타입에 따라 실행할 작업을 분리합니다.
    /// - Parameters:
    ///   - mapView: 선택된 annotaion이 포함된 map view
    ///   - view: 선택된 annotation view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        /*
         /// annotation 선택 상태를 저장
         isAnnotationSelected = true
         
         
         if let annotation = view.annotation as? CafeAnnotation,
         let id = annotation.id {
         nearbyPlaceCollectionView.selectItem(at: IndexPath(item: id, section: 0),
         animated: true,
         scrollPosition: .centeredHorizontally)
         }
         
         
         isAnnotationSelected = false
         */
    }
    
    
    /// 해당 anntation 객체에 알맞은 annotation view를 리턴해줍니다. annotation의 타입에 따라 실행할 작업을 분리합니다.
    /// - Parameters:
    ///   - mapView: 해당 annotaion이 포함된 map view
    ///   - annotation: view를 필요로 하는 annotation
    /// - Returns: annotation에서 표시할 annotation view, 메소드가 nil을 리턴하면 표준 view를 표시.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? MKClusterAnnotation {
            let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                                                                    for: annotation) as! MKMarkerAnnotationView
            clusterView.markerTintColor = UIColor.systemGray5
            return clusterView
        }
        
        let tempColor = UIColor.systemRed
        let tempImage = UIImage(systemName: "mappin.circle")
        
        if let annotation = annotation as? PlaceAnnotation {
            let tintColor = UIColor(named: annotation.placeType.rawValue) ?? tempColor
            let glyphImage = tempImage // 수정 예정
            annotationView = setupPlaceAnnotationView(for: annotation, on: mapView, tintColor: tintColor, image: glyphImage)
        }
        
        return annotationView
        
    }
    
    
    /// place annotation의 annotation view를 설정하는 제네릭 메소드 - 가게 타입에 따라 다른 annotation을 설정할 수 있습니다.
    ///  - Parameters:
    ///   - annotation: annotation view의 annotation (place annotation)
    ///   - mapView: annotation을 표시하는 map view
    ///   - tintColor: marker의 tint color
    ///   - image: marker의 glyph image
    /// - Returns: annotation view
    private func setupPlaceAnnotationView<AnnotationType: PlaceAnnotation>(for annotation: AnnotationType, on mapView: MKMapView, tintColor: UIColor, image: UIImage? = nil) -> MKAnnotationView {
        let identifier = NSStringFromClass(PlaceAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier,
                                                         for: annotation)
        
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = tintColor
            markerAnnotationView.glyphImage = image
            
            /// callout 표시
            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }
        
        return view
    }
    
    
    /// callout이 선택되었을 때 가게 정보 페이지를 표시합니다.
    /// - Parameters:
    ///   - mapView: annotation view가 표시된 map view
    ///   - view: callout의 annotation view
    ///   - control: tap 이벤트가 발생한 컨트롤
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        /// Place Annotation일 때 - 가게 정보 페이지으로 이동
        guard let placeInfoVC = UIStoryboard(name: "PlaceInfo", bundle: nil).instantiateInitialViewController() as? PlaceInfoViewController else { return }
        placeInfoVC.place = list.first(where: { place in
            return place.name == view.annotation?.title
        })
        self.navigationController?.pushViewController(placeInfoVC, animated: true)
    }
    
}




// MARK: - Collection View Delegation

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
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 48
        let height = CGFloat(120)
        return CGSize(width: width, height: height)
    }
    
}




// MARK: - Location Manager Delegate

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
            alert(message: "위치 서비스 권한이 제한되어\n현재 위치를 표시할 수 없습니다")
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
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            alert(message: "위치 서비스 권한이 제한되어\n현재 위치를 표시할 수 없습니다")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocation()
            break
        default:
            break
        }
    }
    
    
    /// 위치 검색에 실패했을 때 호출됩니다.
    /// - Parameters:
    ///   - manager: location manager
    ///   - error: 실패 이유를 포함하고 있는 에러 객체
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if DEBUG
        print("위치 가져오기 실패", error)
        #endif
        
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        
        alert(message: "현재 위치를 불러올 수 없습니다")
        
        currentLocationLabel.text = user.university?.name ?? "위치 서비스 사용불가"
    }
    
    
    /// 위치가 업데이트 되면 수행할 작업 (위치 관련 작업은 모두 메인 스레드에서 실행됨)
    /// - Parameters:
    ///   - manager: location manager
    ///   - locations: 업데이트 된 위치
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = locations.last {
            updateAddress(with: currentLocation)
        } else {
            alert(message: "현재 위치를 불러올 수 없습니다")
        }
        
        manager.stopUpdatingLocation()
    }
    
    
    /// CLLocation 객체를 문자열 주소로 변환하는 메소드
    /// - Parameter location: CLLocation 객체
    /// - Returns: 간단한 문자열 주소. 역 지오코딩 실패시 nil 리턴.
    func updateAddress(with location: CLLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location,
                                        preferredLocale: Locale(identifier: "ko_kr"))
        { [weak self] placeMarks, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print(error)
                self.currentLocationLabel.text = "주소를 찾을 수 없습니다"
            }
            
            if let place = placeMarks?.first {
                let si = place.administrativeArea ?? "ㅎㅎ"
                let gu = place.locality ?? ""
                let dong = place.thoroughfare ?? ""
                let number = place.subThoroughfare ?? ""
                
                self.currentLocationLabel.text = "\(si) \(gu) \(dong) \(number)"
            }
        }
    }
    
}




// MARK: CLAuthorizationStatus extension

extension CLAuthorizationStatus: CustomStringConvertible {
    
    
    /// 디버깅을 위한 authorization description
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


