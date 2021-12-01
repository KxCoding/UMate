//
//  LectureReviewBoardViewController.swift
//  LectureReviewBoardViewController
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit
import RxSwift
import Moya
import NSObject_Rx


/// 최근 강의평 목록 뷰 컨트롤러
/// - Author: 김정민, 남정은(dlsl7080@gmail.com)
class LectureReviewBoardViewController: CommonViewController {
    /// 강의평 테이블 뷰
    @IBOutlet weak var lectureReviewListTableView: UITableView!
    
    
    /// 엑스 버튼을 누르면 모달창이 닫힙니다.
    /// - Parameter sender: 엑스 버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
    /// 서치 바와의 상호작용을 기반으로 검색 결과 화면을 관리하는 뷰 컨트롤러
    let searchController = UISearchController(searchResultsController: nil)
    
    /// 검색 문자열을 일시적으로 저장할 속성
    var cachedText: String?
    
    /// 강의 리스트
    var lectureList = [LectureInfoListResponseData.LectureInfo]()
    
    /// 검색결과 강의 리스트
    var filteredLectureList = [LectureInfoListResponseData.LectureInfo]()
    
    /// 서치바 글자 유무 확인
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// 검색중인지 확인
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    /// 강의목록 페이지
    var lecturePage = 1
    
    /// 추가로 불러온 정보
    var hasMoreLecture = true
    
    /// 첫음에는 리로드 테이블 뷰
    var reloadRequired = false
    
    /// 데이터를 불러올 때 필요한 데이터 설정
    let setting = { (lecturePage: inout Int, hasMoreLecture: inout Bool, dataListCount: Int, lectureListCount: Int) -> () in
        lecturePage += 1
        
        hasMoreLecture = BoardDataManager.shared.totalCount > lectureListCount + dataListCount
    }
    
    
    /// 최신 강의평을 테이블 뷰에 나타냅니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func fetchRecentReviewLecture() {
        
        guard !BoardDataManager.shared.lectureIsFetching && self.hasMoreLecture else { return }
        
        reloadRequired = lecturePage == 1
        
        let lectureReviews = BoardDataManager.shared.fetchRecentReview(lecturePage: lecturePage).share().observe(on: MainScheduler.instance)
        
        lectureReviews
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.setting(&$0.0.lecturePage, &$0.0.hasMoreLecture, $0.1.count, $0.0.lectureList.count)
            })
            .disposed(by: rx.disposeBag)
        
        lectureReviews.filter { $0.count == 0 }
        .withUnretained(self)
        .subscribe(onNext: {
            $0.0.hasMoreLecture = false
        })
        .disposed(by: rx.disposeBag)
       
        if self.reloadRequired {
            lectureReviews.withUnretained(self)
                .filter { !$0.1.isEmpty }
                .subscribe(onNext: {
                    $0.0.lectureList.append(contentsOf: $0.1)
                    $0.0.lectureReviewListTableView.reloadData()
                    $0.0.lectureReviewListTableView.isHidden = false
                })
                .disposed(by: rx.disposeBag)
        } else {
            lectureReviews.withUnretained(self)
                .filter { !$0.1.isEmpty }
                .subscribe(onNext: {
                    let indexPaths = (self.lectureList.count ..< (self.lectureList.count + $0.1.count)).map { IndexPath(row: $0, section: 0) }
                    $0.0.lectureList.append(contentsOf: $0.1)
                    $0.0.lectureReviewListTableView.insertRows(at: indexPaths, with: .none)
                })
                .disposed(by: rx.disposeBag)
        }
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        filteredLectureList = lectureList.filter { $0.professor.lowercased().contains(searchText.lowercased())
                                                    || $0.title.lowercased().contains(searchText.lowercased()) }
        
        lectureReviewListTableView.reloadData()
    }

    
    func setupSearchBar() {
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "과목명, 교수명으로 검색하세요."
        searchController.searchBar.showsCancelButton = false
    }

    
    /// 강의평을 선택 시에 해당하는 강의정보를 보여주기 위한 데이터를 전달합니다.
    /// - Parameters:
    ///   - segue: 호출된 segue
    ///   - sender: segue가 시작된 객체
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = lectureReviewListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? DetailLectureReviewViewController {
                vc.professor = lectureList[indexPath.row].professor
                vc.lectureInfoId = lectureList[indexPath.row].lectureInfoId
            }
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerNib = UINib(nibName: "LectureInfoCustomHeader", bundle: nil)
        lectureReviewListTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        lectureReviewListTableView.isHidden = true
        
        fetchRecentReviewLecture()
        
        lectureReviewListTableView.rx.prefetchRows
            .withUnretained(self)
            .subscribe(onNext: { vc, indexPaths in
                if indexPaths.contains(where: { $0.row > vc.lectureList.count - 8 }) && !BoardDataManager.shared.lectureIsFetching {
                    vc.fetchRecentReviewLecture()
                }
            })
            .disposed(by: rx.disposeBag)
        
        setupSearchBar()
        
        // 강의평 입력하면 최신 강의평 업데이트
        let token = NotificationCenter.default.addObserver(forName: .newLectureReviewDidInput, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            if let recentReview = noti.userInfo?["review"] as? LectureReviewListResponse.LectureReview,
               let index = self.lectureList.firstIndex(where: { $0.lectureInfoId == recentReview.lectureInfoId }) {
                self.lectureList.insert(self.lectureList[index], at: 0)
                self.lectureList.remove(at: index + 1)
                self.lectureList[0].content = recentReview.content
                self.lectureList[0].rating = recentReview.rating
                self.lectureList[0].semester = recentReview.semester
                
                self.lectureReviewListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                self.lectureReviewListTableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
                self.lectureReviewListTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
        }
        tokens.append(token)
    }
}



extension LectureReviewBoardViewController: UISearchBarDelegate {
    /// 서치바의 검색어가 변경될 때마다 호출되는 메소드
    /// - Parameters:
    ///   - searchBar: 검색을 위한 search Bar
    ///   - searchText: 검색어
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
        cachedText = searchText
    }
    
    
    /// 검색이 마칠 때 호출되는 메소드
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = cachedText, !(text.isEmpty || filteredLectureList.isEmpty) {
            searchController.searchBar.text = text
        }
    }
    
    
    ///키보드의 Return버튼을 입력했을 때, 검색이 실행되는 메소드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
}



/// 강의평을 나타냄
/// - Author: 김정민, 남정은(dlsl7080@gmail.com)
extension LectureReviewBoardViewController: UITableViewDataSource {
    /// section 안에 들어갈 row의 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 강의평 목록 테이블 뷰
    ///   - section: 강의평 목록을 나누는 section index
    /// - Returns: section 안에 들어갈 row의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredLectureList.count
        }
        return lectureList.count
    }
    
    
    /// 강의평 목록 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 강의평 목록 테이블 뷰
    ///   - indexPath: 강의평 셀의 indexPath
    /// - Returns: 강의평 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureReviewTableViewCell", for: indexPath) as! LectureReviewTableViewCell
        
        let list: LectureInfoListResponseData.LectureInfo
        
        if isFiltering {
            list = filteredLectureList[indexPath.row]
        } else {
            list = lectureList[indexPath.row]
        }
        
        cell.configure(lecture: list)
        
        return cell
    }
}



/// 강의평 tableView header를 설정
/// - Author: 남정은(dlsl7080@gmail.com)
extension LectureReviewBoardViewController: UITableViewDelegate {
    /// section header의 높이를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 강의평 목록 테이블 뷰
    ///   - section: 강의평 목록을 나누는 section index
    /// - Returns: header의 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    
    /// section header를 구성합니다.
    /// - Parameters:
    ///   - tableView: 강의평 목록 테이블 뷰
    ///   - section: 강의평 목록을 나누는 section index
    /// - Returns: header를 나타내는 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! LectureInfoCustomHeaderView
        headerView.backView.backgroundColor = .systemBackground
        headerView.sectionNameLabel.text = "최신 강의평"
        headerView.writeButton.isHidden = true
        
        return headerView
    }
}


