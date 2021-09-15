//
//  LectureReviewBoardViewController.swift
//  LectureReviewBoardViewController
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit


/// 최근 강의평 목록이 나오는 화면에대한 클래스
/// - Author: 김정민, 남정은
class LectureReviewBoardViewController: UIViewController {
    /// 강의평을 나타내는 테이블 뷰
    @IBOutlet weak var lectureReviewListTableView: UITableView!
    
    /// 엑스 버튼을 누르면 모달창이 닫힘
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
    let searchController = UISearchController(searchResultsController: nil)
    var cachedText: String?
    
    var lectureList = [LectureInfo]()
    var filteredLectureList = [LectureInfo]()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    
    /// 강의 리스트를 파싱함
    /// - Author: 남정은
    func parseList() {
        guard let data = NSDataAsset(name: "lectures2")?.data else {
            return
        }
        
        guard let str = String(data: data, encoding: .utf8) else {
            return
        }
        
        let lines: [String] = str.components(separatedBy: "\n")
        
        for line in lines.dropFirst() {
            let values: [String] = line.components(separatedBy: ",")
        
            guard values.count == 5 else { continue }
            
            let lectureTitle = values[0].trimmingCharacters(in: .whitespaces) /// 교과목명
            let professor = values[1].trimmingCharacters(in: .whitespaces) /// 교수명
            let openingSemester = values[2].trimmingCharacters(in: .whitespaces) /// 개설학기
            let textbookName = values[3].trimmingCharacters(in: .whitespaces) /// 교재명
            let bookLink = values[4].trimmingCharacters(in: .whitespaces) /// 교재링크
            
            let lectureInfo = LectureInfo(
                lectureTitle: lectureTitle,
                professor: professor,
                openingSemester: openingSemester,
                textbookName: textbookName,
                bookLink: bookLink,
                reviews: [LectureReview(assignment: .normal,
                                        groupMeeting: .many,
                                        evaluation: .generous,
                                        attendance: .seat,
                                        testNumber: .two,
                                        rating: .four,
                                        semester: "2019-2",
                                        reviewContent: "괜찮아요"),
                          LectureReview(assignment: .normal,
                                        groupMeeting: .many,
                                        evaluation: .generous,
                                        attendance: .seat,
                                        testNumber: .two,
                                        rating: .four,
                                        semester: "2019-2",
                                        reviewContent: "강력 추천"),
                          LectureReview(assignment: .many,
                                        groupMeeting: .none,
                                        evaluation: .normal,
                                        attendance: .direct,
                                        testNumber: .none,
                                        rating: .three,
                                        semester: "2019-2",
                                        reviewContent: "별로에요")
                ])
            
            lectureList.append(lectureInfo)
        }
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredLectureList = lectureList.filter { (list: LectureInfo) -> Bool in
            return list.professor.lowercased().contains(searchText.lowercased()) || list.lectureTitle.lowercased().contains(searchText.lowercased())
        }
        
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

    
    /// 강의평을 선택시에 해당하는 강의정보를 보여주기 위한 데이터 전달
    /// - Author: 남정은
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = lectureReviewListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? DetailLectureReviewViewController {
                vc.selectedLecture = lectureList[indexPath.row]
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        parseList()
        
        setupSearchBar()
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



/// 강의평 테이블 뷰에 대한 데이터소스
/// - Author: 남정은
extension LectureReviewBoardViewController: UITableViewDataSource {
    /// 내 강의평과 최근 강의평 두 개
    /// - Author: 남정은
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    /// 강의평 테이블 뷰에 나타낼 셀의 개수
    /// - Author: 김정민, 남정은
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case  0:
            return 0
        case 1:
            if isFiltering {
                return filteredLectureList.count
            }
            
            return lectureList.count
        default:
            return 0
        }
    }
    
    /// 각 셀을 초기화
    /// - Author: 김정민, 남정은
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureReviewTableViewCell", for: indexPath) as! LectureReviewTableViewCell
        if indexPath.section == 1 {
            
            let list: LectureInfo
            
            if isFiltering {
                list = filteredLectureList[indexPath.row]
            } else {
                list = lectureList[indexPath.row]
            }
            
            cell.configure(lecture: list)
            
            return cell
        }
        
        return cell
    }
}



/// 강의평 테이블 뷰에대한 동작 처리
/// - Author: 남정은
extension LectureReviewBoardViewController: UITableViewDelegate {
    /// 헤더의 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    
    /// 헤더에 들어갈 뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureReviewHeaderTableViewCell") as! LectureReviewHeaderTableViewCell
        
        if section == 0 {
            cell.sectionNameLabel.text = "내 강의평"
        } else {
            cell.sectionNameLabel.text = "최근 강의평"
        }
        
        return cell.contentView
    }
}


