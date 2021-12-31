//
//  PlaceViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import Loaf
import NSObject_Rx
import RxSwift
import UIKit


extension Notification.Name {
    /// 하위 탭을 선택할 때 전송할 notification
    /// - Author: 박혜정(mailmelater11@gmail.com)
    static let tabToggleDidRequest = Notification.Name(rawValue: "tabToggleDidRequest")
    
    /// 북마크 목록이 업데이트 되었을 때 전송할 notification
    ///
    /// 북마크가 추가된 이후에 table view를 업데이트 하기 위해 전송됩니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    static let bookmarkListHasBeenUpdated = Notification.Name(rawValue: "bookmarkListHasBeenUpdated")
}



/// 상점 상세 정보 화면
/// - Author: 박혜정(mailmelater11@gmail.com), 장현우(heoun3089@gmail.com)
class PlaceInfoViewController: CommonViewController {
    
    // MARK: Nested Types
    
    /// 하위 탭
    /// - Author: 박혜정(mailmelater11@gmail.com)
    enum SubTab {
        /// 정보 탭
        case detail
        
        /// 리뷰 탭
        case review
    }
    
    
    
    // MARK: Outlets
    
    /// 전체 데이터를 표시하는 테이블 뷰
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBOutlet weak var placeInfoTableView: UITableView!
    
    
    // MARK: Properties
    
    let dataManager = PlaceDataManager.shared
    
    /// 상세 정보를 표시할 상점
    /// - Author: 박혜정(mailmelater11@gmail.com)
    var place: Place! = Place.dummyPlace {
        didSet {
            placeInfoTableView.reloadData()
        }
    }
    
    /// 현재 표시되는 상점의 북마킹 여부
    /// - Author: 박혜정(mailmelater11@gmail.com)
    var isBookmarked = false {
        didSet {
            placeInfoTableView.reloadSections([1], with: .automatic)
        }
    }
    
    /// 리뷰 요약 데이터
    /// - Author: 장현우(heoun3089@gmail.com)
    /// 선택된 하위 탭을 저장하는 속성
    ///
    /// 화면 진입 시 정보 탭이 선택되어 있습니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    var selectedTab: SubTab = .detail
    
    
    // MARK: Loafs
    
    /// 북마크 추가 알림 토스트
    /// - Author: 박혜정(mailmelater11@gmail.com)
    lazy var bookmarkedLoaf = Loaf("북마크가 저장되었습니다",
                              state: .success,
                              location: .top,
                              presentingDirection: .vertical,
                              dismissingDirection: .vertical,
                              sender: self)
    
    /// 북마크 삭제 알림 토스트
    /// - Author: 박혜정(mailmelater11@gmail.com)
    lazy var bookmarkDeletedLoaf = Loaf("북마크가 해제되었습니다",
                                  state: .success,
                                  location: .top,
                                  presentingDirection: .vertical,
                                  dismissingDirection: .vertical,
                                  sender: self)
    
    
    // MARK: Actions
    
    /// 탭을 선택하면 알맞은 내용으로 notification을 전송하고 UI를 업데이트 합니다.
    ///
    /// notification에 선택된 탭을 함께 담아 전송합니다.
    /// - Parameter sender: 탭 버튼
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func selectTap(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            selectedTab = .detail
            
            NotificationCenter.default.post(name: .tabToggleDidRequest,
                                            object: nil,
                                            userInfo: [placeInfoTabSelectedNotificationSelectedTab: selectedTab])
        case 101:
            selectedTab = .review
            
            NotificationCenter.default.post(name: .tabToggleDidRequest,
                                            object: nil,
                                            userInfo: [placeInfoTabSelectedNotificationSelectedTab: selectedTab])
        default:
            break
        }
        placeInfoTableView.reloadData()
    }
    
    
    // MARK: View Lifecycle Methods
    
    /// 뷰가 로드되면 화면을 초기화합니다.
    ///
    /// notification 옵저버를 추가합니다. url 관련 버튼이 눌리면 전달된 url을 열고, 리뷰 작성이 완료되면 테이블 뷰를 다시 로드합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com), 장현우(heoun3089@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeInfoTableView.dataSource = self
        placeInfoTableView.delegate = self
        
        self.navigationItem.title = "상점 정보"
        
        PlaceReviewDataManager.shared.fetchAllReview(vc: self) {
            self.placeInfoTableView.reloadData()
        }
        
        var token = NotificationCenter.default.addObserver(forName: .urlOpenHasBeenRequested,
                                                           object: nil,
                                                           queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            guard let urlType = noti.userInfo?[urlOpenRequestNotificationUrlType] as? URLType,
                  let url = noti.userInfo?[urlOpenRequestNotificationUrl] as? URL else { return }
            
            switch urlType {
            case .web:
                self.openUrl(with: url)
            case .tel:
                self.openURLExternal(url: url)
            }
        }
        
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: .bookmarkHasBeenUpdated,
                                                           object: nil,
                                                           queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            if !self.isBookmarked {
                self.dataManager.createBookmark(placeId: self.place.id, vc: self) { _ in
                    DispatchQueue.main.async {
                        self.isBookmarked.toggle()
                        self.bookmarkedLoaf.show(.custom(1.2))
                        NotificationCenter.default.post(name: .bookmarkListHasBeenUpdated, object: nil)
                    }
                }
            } else {
                self.dataManager.deleteBookmark(placeId: self.place.id, vc: self) {
                    DispatchQueue.main.async {
                        self.isBookmarked.toggle()
                        self.bookmarkDeletedLoaf.show(.custom(1.2))
                        NotificationCenter.default.post(name: .bookmarkListHasBeenUpdated, object: nil)
                    }
                }
            }
        }
        
        tokens.append(token)
        
        NotificationCenter.default.rx.notification(.reviewDidApplied, object: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                PlaceReviewDataManager.shared.fetchAllReview(vc: self) {
                    self.placeInfoTableView.reloadData()
                }
            })
            .disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(.reviewPostFailed, object: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in self.alert(message: "리뷰 추가에 실패했습니다.") })
            .disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(.errorOccured, object: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in self.alert(message: "에러가 발생했습니다.") })
            .disposed(by: rx.disposeBag)
        
        setTapBarAppearanceAsDefault()
    }
    
    
    /// 다음 화면으로 넘어가기 전에 호출됩니다.
    /// - Parameters:
    ///   - segue: 다음 화면 뷰컨트롤러에 대한 정보를 가지고 있는 segue 객체
    ///   - sender: segue를 연결한 객체
    /// - Author: 장현우(heoun3089@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ReviewWriteTableViewController {
            vc.placeName = place.name
        } else if let vc = segue.destination as? AllReviewViewController {
            vc.placeName = place.name
        }
    }
}



// MARK: - Tableview Delegation

extension PlaceInfoViewController: UITableViewDataSource {
    
    /// 테이블 뷰에서 표시할 섹션의 개수를 리턴합니다.
    /// - Parameter tableView: 테이블 뷰
    /// - Returns: 섹션의 개수
    /// - Author: 박혜정(mailmelater11@gmail.com), 장현우(heoun3089@gmail.com)
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedTab == .review {
            return 6
        }
        return 5
    }
    
    
    /// 지정된 섹션에서 표시할 항목의 개수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 포함되는 항목의 개수
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 4:
            if selectedTab == .review {
                let reviewList = PlaceReviewDataManager.shared.allPlaceReviewList.filter { $0.place.name == place.name }
                
                if reviewList.count < 3 {
                    return reviewList.count
                } else {
                    return 3
                }
            }
            else { return 0 }
        default:
            return 1
        }
    }
    
    
    /// 지정된 indexpath에서 표시할 셀을 리턴합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 셀의 index path
    /// - Returns: 완성된 셀
    /// - Author: 박혜정(mailmelater11@gmail.com), 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        
        // 이미지 섹션
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstSectionTableViewCell", for: indexPath) as! FirstSectionTableViewCell
            
            cell.configure(with: place)
            
            return cell
            
        // 기본 정보 섹션
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSectionTableViewCell", for: indexPath) as! InfoSectionTableViewCell
            
            cell.configure(with: place, isBookmarked: isBookmarked)
            
            return cell
            
        // 하위 탭 섹션
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "TabSectionTableViewCell", for: indexPath)
            
        // 선택된 하위 탭에 따라 - 상세 정보 / 리뷰 요약
        case 3:
            switch selectedTab {
            case .detail:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
                
                cell.configure(with: place)
                
                return cell
                
            case .review:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralReviewTableViewCell", for: indexPath) as! GeneralReviewTableViewCell
                
                let target = PlaceReviewDataManager.shared.allPlaceReviewList.filter { $0.place.name == place.name }
                cell.configure(with: target)
                
                return cell
            }
            
        // 선택된 하위 탭에 따라 - 리뷰
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell", for: indexPath) as! UserReviewTableViewCell
            
            let targetPlace = PlaceReviewDataManager.shared.allPlaceReviewList.filter { $0.place.name == place.name }
            let target = targetPlace[indexPath.row]
            
            cell.configure(with: target)
            
            return cell
        
        // 선택된 하위 탭에 따라 - 리뷰 더보기
        case 5:
            return tableView.dequeueReusableCell(withIdentifier: "AllReviewTableViewCell", for: indexPath)
            
        default:
            fatalError()
            
        }
    }
    
}



extension PlaceInfoViewController: UITableViewDelegate {
    
    /// 지정된 indexpath의 셀 높이를 제한합니다.
    /// - Parameters:
    ///   - tableView: 이 정보를 요청하는 table view
    ///   - indexPath: 열의 위치를 가리키는 index path
    /// - Returns: 열의 높이
    /// - Author: 박혜정(mailmelater11@gmail.com), 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        // 이미지 섹션
        case 0:
            return tableView.frame.width * 0.5
            
        // 하위 탭 섹션
        case 2:
            return tableView.frame.width / 8
            
        default:
            return UITableView.automaticDimension
        }
    }
}
