//
//  PlaceSearchViewController.swift
//  PlaceSearchViewController
//
//  Created by Hyunwoo Jang on 2021/08/01.
//

import UIKit

class PlaceSearchViewController: UIViewController {
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var dimView: UIView!
    var list = [SearchPlaceItem]()
    var token: NSObjectProtocol?
    
    let dummyData: [SearchPlaceItem] = [
        SearchPlaceItem(image: UIImage(named: "search_00"),
                        placeTitle: "카페 지미스",
                        regionName: "고양",
                        classificationName: "카페"),
        
        SearchPlaceItem(image: UIImage(named: "search_01"),
                        placeTitle: "카페 브리타니",
                        regionName: "부산",
                        classificationName: "카페"),
        
        SearchPlaceItem(image: UIImage(named: "search_00"),
                        placeTitle: "가온",
                        regionName: "청담",
                        classificationName: "카페"),
        
        SearchPlaceItem(image: UIImage(named: "search_01"),
                        placeTitle: "인생밥집",
                        regionName: "제주시 서부",
                        classificationName: "음식점"),
        
        SearchPlaceItem(image: UIImage(named: "search_02"),
                        placeTitle: "인디안썸머",
                        regionName: "제주시 서부",
                        classificationName: "와인바"),
        
        SearchPlaceItem(image: UIImage(named: "search_03"),
                        placeTitle: "인스밀",
                        regionName: "서귀포시 서부",
                        classificationName: "카페"),
        
        SearchPlaceItem(image: UIImage(named: "search_04"),
                        placeTitle: "인셉트",
                        regionName: "대전",
                        classificationName: "카페"),
        
        SearchPlaceItem(image: UIImage(named: "search_05"),
                        placeTitle: "인센스홀",
                        regionName: "대전",
                        classificationName: "카페")
    ]
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 네비게이션바에 백버튼 타이틀 지우고 SearchBar를 추가
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력해주세요."
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        
        token = NotificationCenter.default.addObserver(forName: .filterWillCancelled, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            UIView.animate(withDuration: 0.3) {
                self.dimView.alpha = 0.0
            }
        }
    }
    
    
    /// 다음 화면으로 넘어가기 전에 실행할 작업을 추가합니다.
    /// - Parameters:
    ///   - segue: segue에 관련된 viewController 정보를 가지고 있는 seuge
    ///   - sender: 버튼
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dimView.alpha = 0.4
    }
    
    
    deinit {
        #if DEBUG
        print(#function, self)
        #endif
        
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
}




extension PlaceSearchViewController: UICollectionViewDataSource {
    /// 데이터소스 객체에게 지정된 섹션에 아이템 수를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - section: 컬렉션뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션 아이템의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceSearchCollectionViewCell", for: indexPath) as! PlaceSearchCollectionViewCell
        
        let target = list[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}




extension PlaceSearchViewController: UICollectionViewDelegateFlowLayout {
    /// 델리게이트에게 지정된 아이템의 셀의 사이즈를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - collectionViewLayout: 정보를 요청하는 layout 객체
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 아이템 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let width: CGFloat = ((collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2)
        let height = width * 1.5
        
        return CGSize(width: Int(width), height: Int(height))
    }
    
    
    /// 델리게이트에게 컬렉션 뷰에 표시할 supplementary view 데이터를 요청합니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - kind: supplementary view가 제공하는 종류
    ///   - indexPath: 새로운 헤더의 위치를 지정하는 IndexPath
    /// - Returns: supplementary view 객체
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeaderCollectionViewCell", for: indexPath) as! SearchHeaderCollectionViewCell
    }
    
    
    /// 델리게이트에게 지정된 섹션에 헤더 뷰의 사이즈를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - collectionViewLayout: 정보를 요청하는 레이아웃 객체
    ///   - section: 컬렉션뷰 섹션을 식별하는 Index 번호
    /// - Returns: 헤더 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if list.isEmpty {
            return .zero
        }
        
        return CGSize(width: 0, height: 50)
    }
}




extension PlaceSearchViewController: UISearchBarDelegate {
    /// 델리게이트에게 search 버튼이 클릭되었음을 알립니다.
    /// - Parameter searchBar: 서치바
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /// 버튼을 누르면 list 배열을 초기화
        list = []
        
        guard let text = searchBar.text else { return }
        
        /// 검색한 텍스트로 필터링
        let containData = dummyData.filter { $0.placeTitle.contains(text) }
        
        /// 필터링된 데이터를 장소 이름을 기준으로 오름차순 정렬
        let sortContainData = containData.sorted { $0.placeTitle < $1.placeTitle }
        
        list.append(contentsOf: sortContainData)
        
        #if DEBUG
        print(list)
        #endif
        
        searchBar.resignFirstResponder()
        
        DispatchQueue.main.async {
            self.searchCollectionView.reloadData()
        }
    }
}
