//
//  PlaceMainViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import AVFoundation
import CoreLocation
import MapKit
import UIKit


/// Place 탭 메인 화면
/// - Author: 박혜정(mailmelater11@gmail.com)
class PlaceMainViewController: UIViewController {
    
    // MARK: Outlets
    
    /// 지도 뷰
    @IBOutlet weak var mapView: MKMapView!
    
    /// 사용자 위치 레이블 컨테이너
    @IBOutlet weak var locationContainer: UIView!
    
    /// 사용자 위치 레이블
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    /// 검색 버튼 컨테이너
    @IBOutlet weak var searchBtnContainer: UIView!
    
    /// 목록 보기 버튼 컨테이너
    @IBOutlet weak var listViewBtnContainer: UIView!
    
    /// 주변 상점 컬렉션 뷰
    @IBOutlet weak var nearbyPlaceCollectionView: UICollectionView!
    
    
    // MARK: Properties
    
    /// Data Manager
    lazy var dataManager = PlaceDataManager.shared
    
    /// Location Manager
    lazy var locationManager: CLLocationManager = { [weak self] in
        
        let m = CLLocationManager()
        guard let self = self else { return m }
        
        m.desiredAccuracy = kCLLocationAccuracyBest
        m.delegate = self
        
        return m
    }()
    
    /// 위치 권한 알림 관련 플래그
    ///
    /// 위치 권한 알림이 이미 표시되었다면 true, 아직 표시되지 않았다면 false를 저장합니다.
    var locationAlertHasShownAlready = false
    
    /// 사용자
    var user = PlaceUser.tempUser
    
    /// 상점 배열
    ///
    /// 상점 데이터는 정렬되지 않은 상태로 저장됩니다.
    var list = [Place]() {
        willSet {
            mapView.removeAnnotations(allAnnotations)
            allAnnotations.removeAll()
        }
        didSet {
            let newAnnots = list.map { $0.annotation }
            allAnnotations = newAnnots
            mapView.addAnnotations(allAnnotations)
            registerMapAnnotationViews()
        }
    }
    
    /// 학교 좌표
    /// 기본값은 임시 학교의 좌표입니다.
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
    
    
    // MARK: Actions
    
    /// 목록 보기 화면을 표시합니다.
    ///
    /// 목록 화면 공통 view controller를 사용합니다.
    /// - Parameter sender: 목록 보기 버튼
    @IBAction func showListView(_ sender: Any) {
        guard let placeListVC = UIStoryboard(name: "PlaceList", bundle: nil).instantiateViewController(identifier: "PlaceListWithSimpleCell") as? PlaceListViewController else { return }
        
        placeListVC.navigationItem.title = "상점 목록"
        placeListVC.viewType = .all
        placeListVC.entireItems = list
        
        if let nav = self.navigationController {
            nav.show(placeListVC, sender: nil)
        } else {
            self.present(UINavigationController(rootViewController: placeListVC),
                         animated: true,
                         completion: nil)
        }
    }
    
    
    // MARK: Methods
    
    /// 장소 정보를 다운로드합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func getPlaces() {
        let urlString = "https://umateapi.azurewebsites.net/api/place/university/108"
        guard let getUrl = URL(string: urlString) else { return }
        
        dataManager.get(with: getUrl, on: self) { [weak self] (response: PlaceListResponse) in
            guard let self = self else { return }

            guard let responsePlaces = response.places else { return }
            
            let places = responsePlaces.map { Place(simpleDto: $0) }.sorted { $0.coordinate.longitude < $1.coordinate.longitude }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.list = places
                self.nearbyPlaceCollectionView.reloadData()
            }
        }
    }
    
    
    /// 지도에서 사용할 annotation view 타입을 등록합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func registerMapAnnotationViews() {
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: NSStringFromClass(PlaceAnnotation.self))
    }
    
    
    /// 플로팅 컬렉션 뷰를 위한 lauout을 제공합니다.
    ///
    /// 기본적인 레이아웃 정보와 컬렉션 뷰를 움직일 때 마다 실행할 handler를 설정합니다.
    /// - Returns: UICollectionViewCompositionalLayout 객체
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func configureLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                     leading: 5,
                                                     bottom: 0,
                                                     trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        // modification handler - 컬렉션 뷰를 움직일 때마다 실행할 작업 설정
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, scrollOffset, layoutEnvironment in
            guard let self = self else { return }
            
            // 선택된 아이템 계산
            #warning("리터럴을 대체할 데이터가 필요합니다")
            let selectedItemIndex = Int((scrollOffset.x + 20.7) / 337)
            let selectedItem = self.list[selectedItemIndex]
            
            // 아이템의 좌표를 지도 중앙에 표시
            self.mapView.setCenter(selectedItem.coordinate, animated: true)
            
            // 셀을 움직이면 같은 상점을 표시하는 annotation을 검색
            guard let selectedAnnotation = self.mapView.annotations.first(where: { annot in
                if let annot = annot as? PlaceAnnotation {
                    return annot.placeId == selectedItem.id
                } else { return false }
            }) else { return }
            
            // annotation을 선택
            self.mapView.selectAnnotation(selectedAnnotation, animated: true)
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    
    /// 위치 서비스 사용 가능 여부 및 권한을 확인합니다.
    ///
    /// os 버전, 권한 상태을 확인하고 알맞은 작업을 수행합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func checkLocationAuth() {
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus
            
            if #available(iOS 14.0, *) {
                status = locationManager.authorizationStatus
            } else {
                status = CLLocationManager.authorizationStatus()
            }
            
            #if DEBUG
            print(status.description)
            #endif
            
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
            if locationAlertHasShownAlready { return }
            alert(message: "위치 서비스 권한이 제한되어\n현재 위치를 표시할 수 없습니다")
            locationAlertHasShownAlready = true
        }
    }
    
    
    
    // MARK: View Liftcycle Method
    
    /// 뷰가 메모리에 로드되었을 때 데이터나 UI를 초기화합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPlaces()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        registerMapAnnotationViews()
        
        let initialCenterCoor = list.first?.coordinate ?? universityCoordinate
        let region = MKCoordinateRegion(center: initialCenterCoor,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotations(allAnnotations)
        
        locationContainer.configureStyle(with: [.pillShape, .lightBorder, .lightShadow])
        searchBtnContainer.configureStyle(with: [.pillShape, .lightBorder, .lightShadow])
        listViewBtnContainer.configureStyle(with: [.smallRoundedRect, .lightBorder, .lightShadow])
        
        nearbyPlaceCollectionView.dataSource = self
        nearbyPlaceCollectionView.delegate = self
        
        nearbyPlaceCollectionView.isScrollEnabled = false
        nearbyPlaceCollectionView.isPagingEnabled = true
        nearbyPlaceCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        nearbyPlaceCollectionView.collectionViewLayout = configureLayout()
        
        setTapBarAppearanceAsDefault()
    }
    
    /// 뷰가 화면에 표시되기 직전에 위치 권한을 요청합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationAuth()
        
        getPlaces()
    }
    
    
    /// segue가 실행되기 전에 다음 화면에 대한 초기화를 수행합니다.
    ///
    /// 선택한 상점의 인덱스로 상점 상세 정보 화면에 표시할 상점을 초기화합니다.
    /// - Parameters:
    ///   - segue: 선택한 상점의 상세 정보 화면으로 연결되는 segue
    ///   - sender: segue를 실행시킨 객체. 상점을 표시하는 컬렉션 뷰 셀입니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? NearbyPlaceCollectionViewCell,
           let indexPath = nearbyPlaceCollectionView.indexPath(for: cell) {
            if let vc = segue.destination as? PlaceInfoViewController {
                // 상점 정보 다운로드
                var urlString = "https://umateapi.azurewebsites.net/api/place/\(list[indexPath.row].id)"
                guard let getUrl = URL(string: urlString) else { return }
                
                dataManager.get(with: getUrl, on: vc) { [weak vc] (response: PlaceResponse) in
                    guard let vc = vc else { return }
                    if let places = response.place { vc.place = Place(dto: places) }
                }
                
                // 북마크 정보 다운로드
                urlString = "https://umateapi.azurewebsites.net/api/place/bookmark/place/\(list[indexPath.row].id)"
                guard let bookmarkInfoUrl = URL(string: urlString) else { return }
                
                dataManager.get(with: bookmarkInfoUrl, on: vc) { [weak vc] (response: PlaceBookmarkCheckResponse) in
                    guard let vc = vc else { return }
                    vc.isBookmarked = response.isBookmarked
                }
            }
        }
        
        if let cell = segue.destination as? PlaceSearchViewController {
            cell.userLocation = locationManager.location
        }
    }
}




// MARK: - Map View Delegation

extension PlaceMainViewController: MKMapViewDelegate {
    
    /// 해당 anntation 객체에 알맞은 annotation view를 제공합니다.
    ///
    /// annotation의 타입에 따라 실행할 작업을 분리합니다.
    ///
    /// - Parameters:
    ///   - mapView: 해당 annotaion이 포함된 map view
    ///   - annotation: view를 필요로 하는 annotation
    /// - Returns: annotation에서 표시할 annotation view, 메소드가 nil을 리턴하면 표준 view를 표시.
    ///
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? MKClusterAnnotation {
            let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
            clusterView.markerTintColor = UIColor.systemGray5
            return clusterView
        }
        
        let tempColor = UIColor.systemRed
        let tempImage = UIImage(systemName: "mappin.circle")
        
        if let annotation = annotation as? PlaceAnnotation {
            let tintColor = UIColor(named: annotation.placeType.rawValue) ?? tempColor
            let glyphImage = tempImage
            annotationView = setupPlaceAnnotationView(for: annotation,
                                                         on: mapView,
                                                         tintColor: tintColor,
                                                         image: glyphImage)
        }
        
        return annotationView
        
    }
    
    
    /// 전달된 annotation에 대해 지도에 표시될 view를 제공합니다.
    ///
    /// 제네릭 메소드로, 특정 annotation의 타입으로 전달되며, view는 재사용됩니다.
    ///
    /// - Parameters:
    ///   - annotation: annotation view의 annotation (place annotation)
    ///   - mapView: annotation을 표시하는 map view
    ///   - tintColor: marker의 tint color
    ///   - image: marker의 glyph image
    /// - Returns: annotation view
    ///
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func setupPlaceAnnotationView<AnnotationType: PlaceAnnotation>(for annotation: AnnotationType, on mapView: MKMapView, tintColor: UIColor, image: UIImage? = nil) -> MKAnnotationView {
        let identifier = NSStringFromClass(PlaceAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier,
                                                         for: annotation)
        
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = tintColor
            markerAnnotationView.glyphImage = image
            
            // callout 표시
            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }
        
        return view
    }
    
    
    /// callout이 선택되었을 때 상점 상세 정보 화면를 표시합니다.
    /// - Parameters:
    ///   - mapView: annotation view가 표시된 map view
    ///   - view: callout의 annotation view
    ///   - control: tap 이벤트가 발생한 컨트롤
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // 작업 수행의 조건을 PlaceAnnotation으로 제한합니다.
        if let annot = view.annotation as? PlaceAnnotation {
            guard let placeInfoVC = UIStoryboard(name: "PlaceInfo", bundle: nil).instantiateInitialViewController() as? PlaceInfoViewController else { return }
            
            let urlString = "https://umateapi.azurewebsites.net/api/place/\(annot.placeId)"
            
            guard let getUrl = URL(string: urlString) else { return }
            
            let place = dataManager.get(with: getUrl, on: placeInfoVC) { (response: PlaceResponse) in
                if let places = response.place { placeInfoVC.place = Place(dto: places) }
            }
            
            self.navigationController?.pushViewController(placeInfoVC, animated: true)
        }
    }
    
}




// MARK: - Collection View Delegation

extension PlaceMainViewController: UICollectionViewDataSource {
    
    /// 지정된 섹션에서 표시할 아이템의 개수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 포함되는 아이템의 개수
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /// 지정된 컬렉션 뷰, 지정된 index path에 표시할 셀을 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 아이템의 index path
    /// - Returns: 표시할 셀
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyPlaceCollectionViewCell", for: indexPath) as! NearbyPlaceCollectionViewCell
        
        cell.configure(with: list[indexPath.item])
        
        return cell
    }
    
}




extension PlaceMainViewController: UICollectionViewDelegateFlowLayout {
    
    /// 지정된 indexPath에 표시할 셀의 크기를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - collectionViewLayout: layout 객체
    ///   - indexPath: 아이템의 index path
    /// - Returns: 셀 사이즈
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    /// 위치 업데이트를 시작합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    /// [iOS 14 이후 버전] 위치 사용 권한 변경 시 호출되어 알맞은 작업을 수행합니다.
    ///
    /// 제한 상태에서는 경고창 표시, 허가 상태일 때는 위치 검색을 시작합니다.
    /// - Parameter manager: location manager
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    
    /// [iOS 14 이전 버전] 위치 사용 권한 변경 시 호출되어 알맞은 작업을 수행합니다.
    /// - Parameters:
    ///   - manager: location manager
    ///   - status: 변경된 권한 상태
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    
    /// 위치 검색에 실패하면 알림창을 표시하고 UI를 업데이트 합니다.
    /// - Parameters:
    ///   - manager: location manager
    ///   - error: 실패 이유를 포함하고 있는 에러 객체
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if DEBUG
        print("위치 가져오기 실패", error)
        #endif
        
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        
        alert(message: "현재 위치를 불러올 수 없습니다")
        
        currentLocationLabel.text = user.university?.name ?? "위치 서비스 사용불가"
    }
    
    
    /// 위치가 업데이트 되면 UI를 업데이트하고 즉시 위치 검색을 중단합니다.
    ///
    /// 위치 관련 작업은 모두 메인 스레드에서 실행됩니다.
    /// - Parameters:
    ///   - manager: location manager
    ///   - locations: 검색된 위치. 가장 최신 데이터가 가장 마지막에 저장되어 있습니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = locations.last {
            updateAddress(with: currentLocation)
        } else {
            alert(message: "현재 위치를 불러올 수 없습니다")
        }
        
        // 위치는 한 번만 검색 (검색 즉시 종료)
        manager.stopUpdatingLocation()
    }
    
    
    /// 리버스 지오코딩으로 좌표에 해당하는 주소를 생성하고, 주소 레이블을 업데이트합니다.
    ///
    /// 사용하는 단위 주소가 모두 공백일 경우 알맞은 문자열을 표시합니다.
    ///
    /// - Parameter location: CLLocation 객체
    /// - Returns: 간단한 문자열 주소. 역 지오코딩 실패시 nil 리턴.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func updateAddress(with location: CLLocation) {
        
        let geocoder = CLGeocoder()
        
        // 역지오코딩 (위치 > 주소)
        geocoder.reverseGeocodeLocation(location,
                                        preferredLocale: Locale(identifier: "ko_kr"))
        { [weak self] placeMarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
                self.currentLocationLabel.text = "주소를 찾을 수 없습니다"
            }
            
            // placeMarks는 역지오코딩 결과(주소 정보) 중 현재 좌표와 인접한 순으로 아이템을 저장하고 있습니다.
            if let place = placeMarks?.first {
                let si = place.administrativeArea ?? ""
                let gu = place.locality ?? ""
                let dong = place.thoroughfare ?? ""
                let number = place.subThoroughfare ?? ""
                
                // 모두 공백일 때는 적절한 문구를 표시합니다.
                if [si, gu, dong, number].allSatisfy({ $0.count == 0 }) {
                    self.currentLocationLabel.text = "주소를 찾을 수 없습니다"
                } else {
                    self.currentLocationLabel.text = "\(si) \(gu) \(dong) \(number)"
                }
            }
        }
    }
    
}




// MARK: - CLAuthorizationStatus extension

extension CLAuthorizationStatus: CustomStringConvertible {
    
    /// 디버깅을 위한 authorization description
    /// - Author: 박혜정(mailmelater11@gmail.com)
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


