//
//  ManageBookmarkViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import Loaf
import UIKit


/// 북마크 관리 화면
/// - Author: 박혜정(mailmelater11@gmail.com)
class BookmarkManagingViewController: UIViewController {
    
    // MARK: Outlets
    
    /// 필터링할 타입을 선택할 수 있는 컬렉션 뷰
    @IBOutlet weak var typeSelectionCollectionView: UICollectionView!
    
    /// 북마크 리스트 테이블 뷰
    @IBOutlet weak var bookmarkListTableView: UITableView!
    
    
    // MARK: Properties
    
    /// 컬렉션 뷰가 표시할 가게 타입
    var types: [PlaceTypePattern] = [.all, .cafe, .restaurant, .bakery, .dessert, .pub, .studyCafe]
    
    /// 현재 선택된 가게 타입
    var selectedType: PlaceTypePattern = .all
    
    /// 북마크된 전체 가게
    var bookmarkedItems: [Place] {
        let entirePlaces = Place.dummyData
        
        return entirePlaces.filter { place in
            return PlaceUser.tempUser.userData.bookmarkedPlaces.contains(place.id)
        }
    }
    
    /// 테이블에 표시할 가게
    ///
    /// 현재 선택된 가게 타입에 따라 적절한 데이터에 접근합니다.
    var list: [Place] {
        let entire = bookmarkedItems
        if selectedType == .all {
            return entire
        } else {
            guard let selected = selectedType.matchedPlaceType else { return entire }
            return bookmarkedItems.filter { $0.placeType == selected }
        }
    }
    
    /// 북마크가 삭제되었을 때 표시할 토스트
    lazy var bookmarkDeletedLoaf: Loaf = Loaf("북마크가 삭제되었습니다",
                                              state: .info,
                                              location: .bottom,
                                              presentingDirection: .vertical,
                                              dismissingDirection: .vertical,
                                              sender: self)
    
    
    
    // MARK: View Lifecycle method
    
    /// 뷰가 메모리에 로드된 후 화면을 초기화합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeSelectionCollectionView.dataSource = self
        typeSelectionCollectionView.delegate = self
        
        bookmarkListTableView.dataSource = self
        bookmarkListTableView.delegate = self
        
        bookmarkListTableView.rowHeight = UITableView.automaticDimension
        
        /// 북마크 삭제 이벤트를 감시합니다.
        NotificationCenter.default.addObserver(forName: .updateBookmark, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            self.bookmarkListTableView.reloadData()
        }
        
        /// 전체 가게 표시
        let first = IndexPath(row: 0, section: 0)
        typeSelectionCollectionView.selectItem(at: first, animated: false, scrollPosition: .left)
    }
    
    
    /// segue가 실행되기 전에 다음 화면에 대한 초기화를 수행합니다.
    ///
    /// 상세 정보 화면에 표시할 가게를 저장합니다.
    /// - Parameters:
    ///   - segue: 선택한 가게의 상세 정보 화면으로 연결되는 segue
    ///   - sender: 북마크된 가게를 표시하는 테이블 뷰 셀
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? BookmarkListTableViewCell {
            guard let place = Place.dummyData.first(where: { $0.id == cell.target.id }) else {
                #if DEBUG
                print("검색 실패, 북마크한 가게 찾을 수 없음")
                #endif
                return
            }
            
            if let vc = segue.destination as? PlaceInfoViewController {
                vc.place = place
            }
        }
        
    }
}



// MARK: CollectionView Delegation

extension BookmarkManagingViewController: UICollectionViewDataSource {
    
    /// 각 섹션에서 표시할 항목의 수를 제공합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - section: 섹션
    /// - Returns: 섹션에서 표시할 항목의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count 
    }
    
    
    /// 각 열에서 표시할 셀을 제공합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 항목의 index path
    /// - Returns: 각 항목이 표시할 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceTypeCollectionViewCell", for: indexPath) as! PlaceTypeCollectionViewCell
        
        let typeForDisplaying = types[indexPath.item]
        cell.configure(type: typeForDisplaying,
                       isSelected: typeForDisplaying == selectedType,
                       collectionView: collectionView,
                       indexPath: indexPath,
                       selectedType: selectedType)
        
        return cell
    }
}



extension BookmarkManagingViewController: UICollectionViewDelegate {
    
    /// 타입이 선택되었을 때 리스트를 업데이트 합니다.
    /// - Parameters:
    ///   - collectionView: 아이템이 포함된 collection view
    ///   - indexPath: 아이템의 indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedType = types[indexPath.item]
        
        bookmarkListTableView.reloadData()
    }
    
}



extension BookmarkManagingViewController: UICollectionViewDelegateFlowLayout {
    
    
    /// 컬렉션 뷰에서 표시하는 항목의 크기를 제공합니다.
    /// - Parameters:
    ///   - collectionView: 아이템이 포함된 collection view
    ///   - collectionViewLayout: 컬렉션 뷰 layout 객체
    ///   - indexPath: 선택된 항목의 indexPath
    /// - Returns: 항목의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4.5
        return CGSize(width: width, height: width * 1.3)
    }
}



// MARK: TableView Delegation

extension BookmarkManagingViewController: UITableViewDataSource {
    
    /// 테이블 뷰에 표시할 섹션의 수를 제공합니다.
    /// - Parameter tableView: 테이블 뷰
    /// - Returns: 테이블 뷰에 표시할 섹션의 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /// 각 섹션에 표시할 항목의 수를 제공합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - section: 해당 섹션
    /// - Returns: 각 섹션에 표시될 항목의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /// 각 indexpath에 표시할 셀을 제공합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 해당 항목의 indexPath
    /// - Returns: 각 항목에 표시할 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkListTableViewCell", for: indexPath) as! BookmarkListTableViewCell
        
        cell.configure(with: list[indexPath.item])
        return cell
    }
    
    
    
    /// 테이블 뷰 편집 허용 여부를 결정합니다.
    /// - Parameters:
    ///   - tableView: 편집 여부를 결정할 테이블 뷰
    ///   - indexPath: 편집 여부를 결정할 셀의 indexPath
    /// - Returns: 해당 테이블 뷰 셀의 편집 여부
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}



extension BookmarkManagingViewController: UITableViewDelegate {
    
    /// 우측 contextual action menu를 제공합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 항목의 indexpath
    /// - Returns: 셀의 우측에 표시되는 contextual menu
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedPlace = list[indexPath.row]
        
        var conf = UISwipeActionsConfiguration(actions: [])
        
        let deleteBookmarkMenu = UIContextualAction(style: .destructive, title: "북마크\n삭제") { [weak self] action, view, completion in
            
            guard let self = self else { return }
            
            // 북마크된 가게를  id 검색해서 삭제
            if let index = PlaceUser.tempUser.userData.bookmarkedPlaces.firstIndex(of: selectedPlace.id) {
                PlaceUser.tempUser.userData.bookmarkedPlaces.remove(at: index)
            }
            
            self.bookmarkListTableView.beginUpdates()
            self.bookmarkListTableView.deleteRows(at: [indexPath], with: .automatic)
            self.bookmarkListTableView.endUpdates()
            
            self.bookmarkDeletedLoaf.show(.custom(1.2))
            
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
    ///   - indexPath: 선택된 항목의 indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

