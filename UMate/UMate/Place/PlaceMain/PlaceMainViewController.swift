//
//  PlaceMainViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import UIKit
import CoreLocation

class PlaceMainViewController: UIViewController {
    
    
    /// 지도를 표시할 뷰
    @IBOutlet weak var mapView: UIView!
    
    /// 상단 플로팅 뷰
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var searchBtnContainer: UIView!
    
    /// 하단 플로팅 컬렉션
    @IBOutlet weak var nearbyPlaceCollectionView: UICollectionView!
    
    /// 컬렉션 뷰가 현재 표시하는 아이템의 인덱스
    var selecteditemIndex = 0
    
    /// 위치에 따라 컬렉션 뷰에 리스팅할 가게 배열
    var list = [Place]()
    
    
    /// 화면 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI 초기화
        locationContainer.configureStyle(with: [.pillShape, .lightBorder])
        searchBtnContainer.configureStyle(with: [.pillShape, .lightBorder])
        
        // 더미데이터 저장
        list.append(contentsOf: Place.dummyData)
        
        // 델리게이션
        nearbyPlaceCollectionView.dataSource = self
        nearbyPlaceCollectionView.delegate = self
        
        // 컬렉션 뷰 세팅
        nearbyPlaceCollectionView.isScrollEnabled = false
        nearbyPlaceCollectionView.isPagingEnabled = true
        nearbyPlaceCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        nearbyPlaceCollectionView.collectionViewLayout = compositionalLayout()
    }
    
    
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
        
        // 컬렉션 뷰를 움직일 때마다 실행할 작업
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, scrollOffset, layoutEnvironment in
            guard let self = self else { return }
            
            
            print("displayed")
            print(scrollOffset)
            
            self.selecteditemIndex = Int((scrollOffset.x + 19) / 337)
            
            let selectedItem = self.list[self.selecteditemIndex]
            
            guard let coord = selectedItem.coordinate else { return }
            
            #if DEBUG
            print(self.selecteditemIndex)
            print(selectedItem.name)
            print(coord.latitude, coord.longitude)
            #endif
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
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

