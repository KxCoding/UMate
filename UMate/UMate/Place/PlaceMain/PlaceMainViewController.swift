//
//  PlaceMainViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class PlaceMainViewController: UIViewController {
    
    // 지도를 표시할 배경 뷰
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var searchBtnContainer: UIView!
    
    @IBOutlet weak var nearbyPlaceCollectionView: UICollectionView!
    var selecteditemIndex = 0
    
    var list = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 위치 생성을 위한 세팅
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // 뷰 로드 시점에 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        // 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 업데이트
        locationManager.startUpdatingLocation()
        
        // 위도, 경도 가져오기
        let currentCoor = locationManager.location?.coordinate
        let latitude = (currentCoor?.latitude ?? 37.546489) as Double
        let longitude = (currentCoor?.longitude ?? 126.973707) as Double
        
        //        // 현재 지도가 표시하는 영역을 나타내는 카메라
        //        let camera = GMSCameraPosition.camera(withLatitude: latitude,
        //                                              longitude: longitude,
        //                                              zoom: 16.0)
        //        let map = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        //        mapView.addSubview(map)
        
        // 상단 뷰 초기화
        locationContainer.viewConfig(with: [.pillShape, .lightBorder])
        searchBtnContainer.viewConfig(with: [.pillShape, .lightBorder])
        
        // 컬렉션 뷰 장소 더미데이터
        list.append(contentsOf: Place.dummyData)
        
        nearbyPlaceCollectionView.dataSource = self
        nearbyPlaceCollectionView.delegate = self
        
        nearbyPlaceCollectionView.isScrollEnabled = false
        nearbyPlaceCollectionView.isPagingEnabled = true
        nearbyPlaceCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        // 컬렉션 뷰 pagingCentered 적용
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        // 셀을 움직일 때마다 실행할 코드
        section.visibleItemsInvalidationHandler = ({ [weak self] visibleItems, scrollOffset, layoutEnvironment in
            guard let self = self else { return }
            print("displayed")
            print(scrollOffset)
            
            self.selecteditemIndex = Int((scrollOffset.x + 19) / 337)
            print(self.selecteditemIndex)
            
            let selectedItem = self.list[self.selecteditemIndex]
            print(selectedItem.name)
            
            guard let coord = selectedItem.coordinate else { return }
            print(coord.latitude, coord.longitude)
            
            
        })
        
        // Compositional Layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        nearbyPlaceCollectionView.collectionViewLayout = layout
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? NearbyPlaceCollectionViewCell, let indexPath = nearbyPlaceCollectionView.indexPath(for: cell) {
            if let vc = segue.destination as? PlaceInfoViewController {
                vc.place = list[indexPath.item]   
            }
        }
    }
}

extension PlaceMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyPlaceCollectionViewCell", for: indexPath) as! NearbyPlaceCollectionViewCell
        
        cell.configure(with: list[indexPath.item])
        
        return cell
    }
    
}


extension PlaceMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 48
        let height = CGFloat(120)
        return CGSize(width: width, height: height)
    }
    
}

extension PlaceMainViewController: CLLocationManagerDelegate {
    
}


extension PlaceMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function, scrollView.contentOffset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(targetContentOffset.pointee.x, targetContentOffset.pointee.y)
    }
}
