//
//  PlaceSearchViewController.swift
//  PlaceSearchViewController
//
//  Created by Hyunwoo Jang on 2021/08/01.
//

import CoreLocation
import NSObject_Rx
import RxSwift
import UIKit


/// 상점 검색 화면
/// - Author: 장현우(heoun3089@gmail.com)
class PlaceSearchViewController: CommonViewController {
    
    /// 검색 결과 컬렉션뷰
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    /// 전체 상점 목록
    var list = [Place]()
    
    /// 필터링된 상점 정보
    var filteredPlacelist = [Place]()
    
    /// 필터링 된 항목
    ///
    /// 필터 화면에서 이전에 선택한 필터링 항목은 이미 선택되어 있게 합니다.
    var filteredList = [Place.PlaceType.RawValue]()
    
    /// 사용자 위치
    ///
    /// 이전 화면에서 전달됩니다.
    var userLocation: CLLocation?
    
    /// 거리 필터 활성화 플래그
    ///
    /// 활성화 되어 있다면 필터 화면에서 거리순 버튼이 선택되어 있게 합니다.
    var distanceFilterOn = false
    
    /// window에 추가할 DimView
    ///
    /// 새로운 화면 뒤에 깔리는 화면을 어둡게 보이게 하기 위해서 만든 속성입니다.
    lazy var dimView: UIView = {
        let v = UIView()
        v.frame = self.view.bounds
        v.backgroundColor = .black
        v.alpha = 0.4
        
        return v
    }()
    
    
    /// 네비게이션 아이템에 SearchBar를 추가합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    func addSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력해주세요."
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// window에 추가된 DimView를 제거합니다.
    /// 필터 화면에서 가져온 정보를 가지고 필터링합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBar()
        
//        guard let getUrl = URL(string: "https://umate-api.azurewebsites.net/api/place") else { return }
//
//        PlaceDataManager.shared.get(with: getUrl, on: self) { [weak self] (response: PlaceListResponse) in
//            guard let self = self else { return }
//
//            guard let responsePlaces = response.places else { return }
//            let places = responsePlaces.map { Place(simpleDto: $0) }
//
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//
//                self.list = places
//            }
//        }
        
        NotificationCenter.default.rx.notification(.filterWillCancelled, object: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.dimView.removeFromSuperview()
            })
            .disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(.filterWillApplied, object: nil)
            .subscribe(onNext: { [weak self] noti in
                guard let self = self else { return }
                
                UIView.animate(withDuration: 0.3) {
                    self.dimView.removeFromSuperview()
                }
                
                // 필터 화면에서 보낸 필터링할 열거형 타입 배열을 가져옵니다.
                if let filteredList = noti.userInfo?[filterWillAppliedNotificationFilteredPlaceList] as? [Place.PlaceType.RawValue] {
                    self.filteredList = filteredList
                    
                    if !self.filteredList.isEmpty {
                        var data = [Place]()
                        
                        // 더미데이터에 속한 각 데이터의 placeType과 filterList의 placeType이 같다면 data배열에 추가합니다.
                        for filteredItem in self.filteredList {
                            for item in self.list {
                                if item.type == filteredItem {
                                    data.append(item)
                                }
                            }
                        }
                        
                        var containedData = [Place]()
                        // 현재 화면에 표시하고 있는 list에서 필터링합니다.
                        for currentItem in self.filteredPlacelist {
                            for filteredItem in data {
                                if currentItem.name == filteredItem.name {
                                    containedData.append(filteredItem)
                                }
                            }
                        }
                        
                        self.filteredPlacelist = containedData
                        self.searchCollectionView.reloadData()
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(.sortByDistanceButtonSeleted, object: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] noti in
                guard let self = self else { return }
                
                if let sortedPlaceList = noti.userInfo?[sortByDistanceButtonSeletedNotificationSortedPlaceList] as? [Place] {
                    self.distanceFilterOn = true
                    self.filteredPlacelist = sortedPlaceList
                    
                    let indexPaths = (0 ..< self.filteredPlacelist.count).map {
                        IndexPath(item: $0, section: 0)
                    }
                    
                    self.searchCollectionView.reloadItems(at: indexPaths)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 다음 화면으로 넘어가기 전에 실행할 작업을 추가합니다.
    ///
    /// FilterViewController로 이동시: window에 DimView를 추가하고 필터링과 관련된 정보를 보냅니다.
    /// PlaceInfoViewController로 이동시: 선택된 상점 정보를 보냅니다.
    /// - Parameters:
    ///   - segue: viewController 정보를 가지고 있는 seuge
    ///   - sender: 필터 버튼, 검색 결과 컬렉션뷰 셀
    ///   FilterViewController로 이동시 센더는 필터 버튼입니다.
    ///   PlaceInfoViewController로 이동시 센더는 검색 결과 컬렉션뷰 셀입니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // window에 dimming View를 추가
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
        
        if let vc = segue.destination as? FilterViewController {
            window.addSubview(self.dimView)
            vc.filteredList = filteredList
            vc.placeList = filteredPlacelist
            vc.userLocation = userLocation
            vc.distanceFilterOn = distanceFilterOn
        }
        
        if let cell = sender as? UICollectionViewCell,
           let indexPath = searchCollectionView.indexPath(for: cell) {
            if let vc = segue.destination as? PlaceInfoViewController {
                let targetId = filteredPlacelist[indexPath.item].id
                
                // 상점 정보 다운로드
                PlaceDataManager.shared.fetchPlaceInfo(placeId: targetId, vc: vc) { place in
                    vc.place = place
                }
                
                // 북마크 정보 다운로드
                PlaceDataManager.shared.fetchIfBookmarked(placeId: targetId, vc: vc) { isBookmarked in
                    vc.isBookmarked = isBookmarked
                }
                
            }
        }
    }
}



/// 검색 결과 컬렉션뷰 데이터 관리
extension PlaceSearchViewController: UICollectionViewDataSource {
    
    /// 섹션의 아이템 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 검색 결과 컬렉션뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 아이템 수
    /// - Author: 장현우(heoun3089@gmail.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPlacelist.count
    }
    
    
    /// 검색 결과로 셀을 구성합니다.
    /// - Parameters:
    ///   - collectionView: 검색 결과 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 상점 검색 결과 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceSearchCollectionViewCell", for: indexPath) as! PlaceSearchCollectionViewCell
        
        let target = filteredPlacelist[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}



/// 셀 사이즈를 지정하기 위해 추가
extension PlaceSearchViewController: UICollectionViewDelegateFlowLayout {
    
    /// 셀 사이즈를 리턴합니다.
    ///
    /// 셀의 너비를 2등분, 높이는 너비의 150%로 지정합니다.
    /// - Parameters:
    ///   - collectionView: 검색 결과 컬렉션뷰
    ///   - collectionViewLayout: layout 객체
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 아이템 사이즈
    /// - Author: 장현우(heoun3089@gmail.com)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let width: CGFloat = ((collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2)
        let height = width * 1.5
        
        return CGSize(width: Int(width), height: Int(height))
    }
    
    
    /// 헤더 뷰를 구성합니다.
    /// - Parameters:
    ///   - collectionView: 검색 결과 컬렉션뷰
    ///   - kind: 헤더 뷰
    ///   - indexPath: 새로운 헤더의 위치를 지정하는 IndexPath
    /// - Returns: 구성한 검색 화면 헤더 뷰 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeaderCollectionViewCell", for: indexPath) as! SearchHeaderCollectionViewCell
    }
    
    
    /// 헤더 뷰의 사이즈를 리턴합니다.
    ///
    /// 검색 결과가 없는 경우에는 높이를 0으로 설정하고, 있는 경우에는 높이를 50으로 설정합니다.
    /// - Parameters:
    ///   - collectionView: 검색 결과 컬렉션뷰
    ///   - collectionViewLayout: layout 객체
    ///   - section: 섹션 인덱스
    /// - Returns: 헤더 사이즈
    /// - Author: 장현우(heoun3089@gmail.com)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if filteredPlacelist.isEmpty {
            return .zero
        }
        
        return CGSize(width: 0, height: 50)
    }
}



/// 검색 버튼을 클릭했을 때 발생하는 이벤트 처리
extension PlaceSearchViewController: UISearchBarDelegate {
    
    /// 검색 버튼을 클릭한 다음 호출됩니다.
    ///
    /// 필터링된 데이터를 장소 이름을 기준으로 오름차순 정렬합니다.
    /// - Parameter searchBar: 서치바
    /// - Author: 장현우(heoun3089@gmail.com)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 버튼을 누르면 list 배열을 초기화
        filteredPlacelist = []
        
        // 버튼을 누르면 필터 리스트 초기화
        filteredList = []
        
        distanceFilterOn = false
        
        guard let text = searchBar.text else { return }
        
        // 검색한 텍스트로 필터링
        let containData = list.filter { $0.name.contains(text) }
        
        // 필터링된 데이터를 장소 이름을 기준으로 오름차순 정렬
        let sortContainData = containData.sorted { $0.name < $1.name }
        filteredPlacelist.append(contentsOf: sortContainData)
        
        searchBar.resignFirstResponder()
        
        DispatchQueue.main.async {
            self.searchCollectionView.reloadData()
        }
    }
}
