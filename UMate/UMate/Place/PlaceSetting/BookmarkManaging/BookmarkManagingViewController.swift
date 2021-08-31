//
//  ManageBookmarkViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import UIKit

class BookmarkManagingViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var typeSelectionCollectionView: UICollectionView!
    @IBOutlet weak var bookmarkListTableView: UITableView!
    
    
    // MARK: Properties
    
    // 컬렉션 뷰에서 표시할 가게 타입
    var types: [PlaceTypePattern] = [.all, .cafe, .restaurant, .bakery, .dessert, .pub, .studyCafe]
    
    /// 현재 선택된 가게 타입
    var selectedType: PlaceTypePattern = .all
    
    /// 북마크된 데이터
    var bookmarkedItems: [Place] {
        /// 일단 전체 데이터 - 수정 예정
        //        return Place.dummyData
        
        let entirePlaces = Place.dummyData
        
        return entirePlaces.filter { place in
            return PlaceUser.tempUser.userData.bookmarkedPlaces.contains(place.name)
        }
    }
    
    /// 테이블에 표시할 가게 데이터 - 종류별
    var list: [Place] {
        let entire = bookmarkedItems
        if selectedType == .all {
            return entire
        } else {
            guard let selected = selectedType.matchedPlaceType else { return entire }
            return bookmarkedItems.filter { $0.placeType == selected }
        }
    }
    
    
    // MARK: View Lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// collection view delegation
        typeSelectionCollectionView.dataSource = self
        typeSelectionCollectionView.delegate = self
        
        /// table view delegation
        bookmarkListTableView.dataSource = self
        bookmarkListTableView.delegate = self
        
        /// tableview configuration
        bookmarkListTableView.rowHeight = UITableView.automaticDimension
        
        /// 북마크 수정 사항 팔로우
        NotificationCenter.default.addObserver(forName: .updateBookmark, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            /// 삭제 시 테이블 뷰 업데이트
            self.bookmarkListTableView.reloadData()
        }
        
        let first = IndexPath(row: 0, section: 0)
        typeSelectionCollectionView.selectItem(at: first, animated: false, scrollPosition: .left)
    }
    
    
    /// VC에게 segue가 곧 실행됨을 알리는 메소드
    /// - Parameters:
    ///   - segue: segue에 포함된 vc 정보(desination)를 포함하고 있는 segue
    ///   - sender: segue를 실행시키는 트리거 객체
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? BookmarkListTableViewCell {
            /// 전체 데이터에서 [이름으로] 가게 검색
            guard let place = Place.dummyData.first(where: { $0.name == cell.target.name }) else {
                /// 검색 실패시 리턴
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
    
    /// 컬렉션 뷰의 각 섹션에서 표시할 항목의 수를 제공하는 메소드
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - section: 섹션
    /// - Returns: 섹션에서 표시할 항목의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return types.count 
    }
    
    
    /// 각 항목이 표시할 셀을 제공하는 메소드
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
    
    /// collection view의 아이템이 선택되었을 떄 호출되어 구현된 작업을 실행합니다.
    /// - Parameters:
    ///   - collectionView: 아이템이 포함된 collection view
    ///   - indexPath: 아이템의 indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// vc의 선택된 타입 속성에 타입 저장
        selectedType = types[indexPath.item]
        
        /// 리스트 업데이트
        bookmarkListTableView.reloadData()
    }
    
}




extension BookmarkManagingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4.5
        return CGSize(width: width, height: width * 1.3)
    }
}




// MARK: TableView Delegation

extension BookmarkManagingViewController: UITableViewDataSource {
    
    /// 테이블 뷰에 표시할 섹션의 수를 제공하는 메소드
    /// - Parameter tableView: 테이블 뷰
    /// - Returns: 테이블 뷰에 표시할 섹션의 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /// 각 섹션에 표시할 항목의 수를 제공하는 메소드
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - section: 해당 섹션
    /// - Returns: 각 섹션에 표시될 항목의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /// 각 항목에 표시할 셀을 제공하는 메소드
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 해당 항목의 indexPath
    /// - Returns: 각 항목에 표시할 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkListTableViewCell", for: indexPath) as! BookmarkListTableViewCell
        
        cell.configure(with: list[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}




extension BookmarkManagingViewController: UITableViewDelegate {
    
    /// 우측 contextual action menu를 제공하는 메소드
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 항목의 indexpath
    /// - Returns: 셀의 우측에 표시되는 contextual menu
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        /// 선택된 열이 표시하고 있는 가게
        let selectedPlace = list[indexPath.row]
        
        var conf = UISwipeActionsConfiguration(actions: [])
        
        let deleteBookmarkMenu = UIContextualAction(style: .destructive, title: "북마크\n삭제") { [weak self] action, view, completion in
            
            guard let self = self else { return }
            
            /// 북마크된 가게를 [이름으로] 검색 - 삭제
            if let index = PlaceUser.tempUser.userData.bookmarkedPlaces.firstIndex(of: selectedPlace.name) {
                PlaceUser.tempUser.userData.bookmarkedPlaces.remove(at: index)
            }
            
            /// 테이블 업데이트
            self.bookmarkListTableView.beginUpdates()
            self.bookmarkListTableView.deleteRows(at: [indexPath], with: .automatic)
            self.bookmarkListTableView.endUpdates()
            
            completion(true)
        }
        
        deleteBookmarkMenu.backgroundColor = .systemRed
        deleteBookmarkMenu.image = UIImage(systemName: "bookmark.slash.fill")
        
        conf.performsFirstActionWithFullSwipe = false
        
        conf = UISwipeActionsConfiguration(actions: [deleteBookmarkMenu])
        
        return conf
    }
    
    
    /// 항목이 선택되면 작업을 실행하는 메소드 - 선택 상태를 즉시 해제
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 선택된 항목의 indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

