//
//  PlaceListViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import Loaf
import UIKit


/// 상점 목록 화면
///
/// 상점 목록 보기 화면과 북마크 관리 화면의 공통 view controller 입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
class PlaceListViewController: CommonViewController {
    
    /// 목록 유형
    ///
    /// 리스트가 표시하는 데이터의 유형과 일부 동작을 결정합니다.
    enum ViewType {
        
        /// 전체 상점 목록
        case all
        
        /// 북마크된 상점 목록
        ///
        /// 상점이 표시된 테이블 뷰를 편집할 수 있습니다.
        case bookmark
    }
    
    
    
    // MARK: Outlets
    
    /// 타입 필터링용 컬렉션 뷰
    @IBOutlet weak var typeSelectionCollectionView: UICollectionView!
    
    /// 상점 리스트 테이블 뷰
    @IBOutlet weak var placeListTableView: UITableView!
    
    
    // MARK: Properties
    
    /// Data Manager
    let dataManager = PlaceDataManager.shared
    
    /// 목록 유형
    ///
    /// 유형에 따라 리스트가 표시하는 데이터의 유형과 일부 동작이 결정됩니다.
    var viewType: ViewType = .all
    
    /// 컬렉션 뷰가 표시할 상점 타입
    var types: [PlaceTypePattern] = [.all, .cafe, .restaurant, .bakery, .dessert, .pub, .studyCafe]
    
    /// 현재 선택된 상점 타입
    var selectedPlaceType: PlaceTypePattern = .all
    
    /// 리스트에 표시할 전체 상점
    var entireItems: [Place] = []
    
    /// 테이블에 표시할 상점
    ///
    /// 현재 선택된 상점 타입에 따라 적절한 데이터에 접근합니다.
    var listedItems: [Place] {
        if selectedPlaceType == .all {
            return entireItems
        } else {
            guard let selected = selectedPlaceType.matchedPlaceType else { return entireItems }
            return entireItems.filter { $0.placeType == selected }
        }
    }
    
    /// 북마크가 삭제되었을 때 표시할 토스트
    lazy var bookmarkDeletedLoaf: Loaf = Loaf("북마크가 삭제되었습니다",
                                              state: .success,
                                              location: .top,
                                              presentingDirection: .vertical,
                                              dismissingDirection: .vertical,
                                              sender: self)
    
    
    
    // MARK: Methods
    
    /// 검색 화면으로 이동합니다.
    /// - Parameter sender: 검색 바 버튼
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @objc func showSearchVC(_ sender: Any) {
        guard let searchVC = UIStoryboard(name: "PlaceSearch", bundle: nil).instantiateInitialViewController() as? PlaceSearchViewController else { return }
        
        // TODO: 검색 화면 데이터 초기화 (검색 화면 구현 수정 요망)
        
        if let navigationController = self.navigationController {
            navigationController.show(searchVC, sender: sender)
        } else {
            self.present(searchVC, animated: true, completion: nil)
        }
    }
    
    
    // MARK: View Lifecycle method
    
    /// 뷰가 메모리에 로드된 후 화면을 초기화합니다.
    ///
    /// viewType에 따라 다른 추가 작업을 수행합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeSelectionCollectionView.dataSource = self
        typeSelectionCollectionView.delegate = self
        
        placeListTableView.dataSource = self
        placeListTableView.delegate = self
        
        placeListTableView.rowHeight = UITableView.automaticDimension
        
        selectedPlaceType = .all
        let first = IndexPath(row: 0, section: 0)
        typeSelectionCollectionView.selectItem(at: first, animated: false, scrollPosition: .left)
        
        switch viewType {
        case .all:
            // navigation bar에 검색 버튼을 추가합니다.
            if let _ = self.navigationController {
                let searchButton = UIBarButtonItem(barButtonSystemItem: .search,
                                                   target: self,
                                                   action: #selector(showSearchVC(_:)))
                
                navigationItem.rightBarButtonItem = searchButton
            }
        case .bookmark:
            // 북마크 삭제 이벤트를 감시합니다.
            let token = NotificationCenter.default.addObserver(forName: .bookmarkListUpdated,
                                                               object: nil,
                                                               queue: .main) { [weak self] noti in
                guard let self = self else { return }
                
                let urlString = "https://umateapi.azurewebsites.net/api/place/bookmark"
                guard let getUrl = URL(string: urlString) else { return }
                
                PlaceDataManager.shared.get(with: getUrl, on: self) { [weak self] (response: PlaceListResponse) in
                    guard let self = self else { return }
                    
                    guard let responsePlaces = response.places else { return }
                    let places = responsePlaces.map { Place(simpleDto: $0) }
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        self.entireItems = places
                        self.placeListTableView.reloadData()
                    }
                }
            }
            
            tokens.append(token)
        }
        
        setTapBarAppearanceAsDefault()
    }
    
    
    /// segue가 실행되기 전에 다음 화면에 대한 초기화를 수행합니다.
    ///
    /// 선택한 상점의 Id로 상점 상세 정보 화면에 표시할 상점을 초기화합니다.
    /// - Parameters:
    ///   - segue: 선택한 상점의 상세 정보 화면으로 연결되는 segue
    ///   - sender: segue를 실행시킨 객체. 북마크된 상점을 표시하는 테이블 뷰 셀입니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? PlaceListTableViewCell {
            if let vc = segue.destination as? PlaceInfoViewController {
                // 상점 정보 다운로드
                var urlString = "https://umateapi.azurewebsites.net/api/place/\(cell.target.id)"
                guard let placeInfoUrl = URL(string: urlString) else { return }
                
                PlaceDataManager.shared.get(with: placeInfoUrl, on: vc) { [weak vc] (response: PlaceResponse) in
                    guard let vc = vc else { return }
                    if let places = response.place { vc.place = Place(dto: places) }
                }
                
                // 북마크 정보 다운로드
                urlString = "https://umateapi.azurewebsites.net/api/place/bookmark/place/\(cell.target.id)"
                guard let bookmarkInfoUrl = URL(string: urlString) else { return }
                
                PlaceDataManager.shared.get(with: bookmarkInfoUrl, on: vc) { [weak vc] (response: PlaceBookmarkCheckResponse) in
                    guard let vc = vc else { return }
                    vc.isBookmarked = response.isBookmarked
                }
                
            }
        }
        
    }
}



// MARK: CollectionView Delegation

extension PlaceListViewController: UICollectionViewDataSource {
    
    /// 지정된 섹션에서 표시할 아이템의 개수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 포함되는 아이템의 개수
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    
    /// 지정된 컬렉션 뷰, 지정된 index path에 표시할 셀을 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 아이템의 index path
    /// - Returns: 표시할 셀
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimplePlaceTypeCollectionViewCell", for: indexPath) as! SimplePlaceTypeCollectionViewCell
        
        let typeForDisplaying = types[indexPath.item]
        cell.configure(type: typeForDisplaying,
                       isSelected: typeForDisplaying == selectedPlaceType)
        
        return cell
    }
}



extension PlaceListViewController: UICollectionViewDelegate {
    
    /// 타입이 선택되었을 때 리스트를 업데이트 합니다.
    /// - Parameters:
    ///   - collectionView: 아이템이 포함된 컬렉션 뷰
    ///   - indexPath: 아이템의 index path
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPlaceType = types[indexPath.item]
        
        placeListTableView.reloadData()
    }
    
}



extension PlaceListViewController: UICollectionViewDelegateFlowLayout {
    
    /// 지정된 section의 line 간격의 크기를 리턴합니다.
    ///
    /// 수평 스크롤에서는 line 간격 셀 간격으로 적용됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - collectionViewLayout: layout 객체
    ///   - section: 섹션의 인덱스
    /// - Returns: line 간격의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}



// MARK: TableView Delegation

extension PlaceListViewController: UITableViewDataSource {
    
    /// 테이블 뷰에서 표시할 섹션의 개수를 리턴합니다.
    /// - Parameter tableView: 테이블 뷰
    /// - Returns: 섹션의 개수
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /// 지정된 섹션에서 표시할 항목의 개수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 포함되는 항목의 개수
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listedItems.count
    }
    
    
    /// 지정된 indexpath에서 표시할 셀을 리턴합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 셀의 index path
    /// - Returns: 완성된 셀
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkListTableViewCell", for: indexPath) as! PlaceListTableViewCell
        
        cell.configure(with: listedItems[indexPath.item])
        return cell
    }
    
    
    
    /// 테이블 뷰 편집 허용 여부를 결정합니다.
    /// - Parameters:
    ///   - tableView: 편집 여부를 결정할 테이블 뷰
    ///   - indexPath: 편집 여부를 결정할 셀의 index path
    /// - Returns: 해당 테이블 뷰 셀의 편집 여부
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}



extension PlaceListViewController: UITableViewDelegate {
    
    /// 우측 contextual action menu를 제공합니다.
    ///
    /// 북마크 모드일 때 해당 항목을 사용자의 북마크 목록에서 해제할 수 있습니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 항목의 index path
    /// - Returns: 셀의 우측에 표시되는 contextual menu
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard viewType == .bookmark else { return nil }
        
        let selectedPlace = listedItems[indexPath.row]
        
        var conf = UISwipeActionsConfiguration(actions: [])
        
        let deleteBookmarkMenu = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            
            let urlString = "https://umateapi.azurewebsites.net/api/place/bookmark/place/\(selectedPlace.id)"
            guard let url = URL(string: urlString) else { return }
            
            self.dataManager.delete(with: url, on: self) { response in
                if response.code == PlaceResultCode.ok.rawValue {
                    #if DEBUG
                    print(">>>> 북마크 삭제됨 - \(selectedPlace.name)")
                    #endif
                    
                    DispatchQueue.main.async {
                        if let targetIndex = self.entireItems.firstIndex { $0.id == selectedPlace.id } {
                            self.entireItems.remove(at: targetIndex)
                            
                            self.placeListTableView.beginUpdates()
                            self.placeListTableView.deleteRows(at: [indexPath], with: .automatic)
                            self.placeListTableView.endUpdates()
                        } else {
                            NotificationCenter.default.post(name: .bookmarkListUpdated, object: nil)
                        }
                        
                        self.bookmarkDeletedLoaf.show(.custom(1.2))
                    }
                }
            }
            
            completion(true)
        }
        
        deleteBookmarkMenu.backgroundColor = .systemRed
        deleteBookmarkMenu.image = UIImage(systemName: "bookmark.slash.fill")
        
        conf.performsFirstActionWithFullSwipe = false
        
        conf = UISwipeActionsConfiguration(actions: [deleteBookmarkMenu])
        
        return conf
    }
    
    
    /// 항목이 선택되면 선택 상태를 즉시 해제합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 선택된 항목의 index path
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

