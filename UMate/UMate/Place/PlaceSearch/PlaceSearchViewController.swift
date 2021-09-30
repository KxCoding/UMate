//
//  PlaceSearchViewController.swift
//  PlaceSearchViewController
//
//  Created by Hyunwoo Jang on 2021/08/01.
//

import UIKit


/// 가게 검색탭과 관련된 뷰컨트롤러 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class PlaceSearchViewController: RemoveObserverViewController {
    /// 검색한 결과를 표시할 컬렉션뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    /// 필터링된 가게 정보를 담을 배열
    /// - Author: 장현우(heoun3089@gmail.com)
    var list = [Place]()
    
    /// 가게 이미지
    /// - Author: 장현우(heoun3089@gmail.com)
    var images = [UIImage?]()
    
    /// 필터링할 항목을 담은 배열
    /// 필터 화면에서 이전에 선택한 필터링 항목은 이미 선택되어 있게 하기 위해서 만든 배열입니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    var filterList = [Place.PlaceType]()
    
    
    /// window에 추가할 DimView
    /// - Author: 장현우(heoun3089@gmail.com)
    lazy var dimView: UIView = {
        let v = UIView()
        v.frame = self.view.bounds
        v.backgroundColor = .black
        v.alpha = 0.4
        
        return v
    }()
    
    
    /// 네비게이션아이템에 searchBar를 추가합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    func addSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력해주세요."
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }
    
    
    /// window에 추가된 DimView를 제거합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    func removeViewFromWindow() {
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
        
        for view in window.subviews as [UIView] where view == dimView {
            view.removeFromSuperview()
            break
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for image in 0...5 {
            images.append(UIImage(named: "search_0\(image)"))
        }
        
        // 네비게이션바에 백버튼 타이틀 지우고 SearchBar를 추가
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        addSearchBar()
        
        var token = NotificationCenter.default.addObserver(forName: .filterWillCancelled, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            // DimView 제거
            UIView.animate(withDuration: 0.3) {
                self.removeViewFromWindow()
            }
        }
        
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: .filterWillApplied, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            // DimView 제거
            UIView.animate(withDuration: 0.3) {
                self.removeViewFromWindow()
            }
            
            // 필터 화면에서 보낸 필터링할 열거형 타입 배열을 가져옵니다.
            if let filterList = noti.userInfo?["filterItem"] as? [Place.PlaceType] {
                self.filterList = filterList
                
                if !self.filterList.isEmpty {
                    var data = [Place]()
                    
                    // 더미데이터에 속한 각 데이터의 placeType과 filterList의 placeType이 같다면 data배열에 추가합니다.
                    for filterItem in self.filterList {
                        for item in Place.dummyData {
                            if item.placeType == filterItem {
                                data.append(item)
                            }
                        }
                    }
                    
                    var containData = [Place]()
                    // 현재 화면에 표시하고 있는 list에서 필터링합니다.
                    for currentItem in self.list {
                        for filterItem in data {
                            if currentItem.name == filterItem.name {
                                containData.append(filterItem)
                            }
                        }
                    }
                    
                    self.list = containData
                    self.searchCollectionView.reloadData()
                }
            }
        }
        
        tokens.append(token)
    }
    
    
    /// 다음 화면으로 넘어가기 전에 실행할 작업을 추가합니다.
    /// - Parameters:
    ///   - segue: segue에 관련된 viewController 정보를 가지고 있는 seuge
    ///   - sender: 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// window에 dimming View를 추가
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
        
        if let vc = segue.destination as? FilterViewController {
            window.addSubview(self.dimView)
            vc.filterList = filterList
        }
        
        if let cell = sender as? UICollectionViewCell,
           let indexPath = searchCollectionView.indexPath(for: cell) {
            if let vc = segue.destination as? PlaceInfoViewController {
                vc.place = list[indexPath.item]
            }
        }
    }
}



extension PlaceSearchViewController: UICollectionViewDataSource {
    /// 데이터소스 객체에게 지정된 섹션에 아이템 수를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - section: 컬렉션뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션 아이템의 수
    /// - Author: 장현우(heoun3089@gmail.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceSearchCollectionViewCell", for: indexPath) as! PlaceSearchCollectionViewCell
        
        let target = list[indexPath.row]
        let image = images[indexPath.row]
        cell.configure(with: target, image: image)
        
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
    /// - Author: 장현우(heoun3089@gmail.com)
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
    /// - Author: 장현우(heoun3089@gmail.com)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeaderCollectionViewCell", for: indexPath) as! SearchHeaderCollectionViewCell
    }
    
    
    /// 델리게이트에게 지정된 섹션에 헤더 뷰의 사이즈를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - collectionViewLayout: 정보를 요청하는 레이아웃 객체
    ///   - section: 컬렉션뷰 섹션을 식별하는 Index 번호
    /// - Returns: 헤더 사이즈
    /// - Author: 장현우(heoun3089@gmail.com)
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
    /// - Author: 장현우(heoun3089@gmail.com)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 버튼을 누르면 list 배열을 초기화
        list = []
        
        // 버튼을 누르면 필터 리스트 초기화
        filterList = []
        
        guard let text = searchBar.text else { return }
        
        // 검색한 텍스트로 필터링
        let containData = Place.dummyData.filter { $0.name.contains(text) }
        
        // 필터링된 데이터를 장소 이름을 기준으로 오름차순 정렬
        let sortContainData = containData.sorted { $0.name < $1.name }
        list.append(contentsOf: sortContainData)
        
        searchBar.resignFirstResponder()
        
        DispatchQueue.main.async {
            self.searchCollectionView.reloadData()
        }
    }
}
