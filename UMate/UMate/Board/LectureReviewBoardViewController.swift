//
//  LectureReviewBoardViewController.swift
//  LectureReviewBoardViewController
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit


/// 최근 강의평 목록 뷰 컨트롤러
/// - Author: 김정민, 남정은(dlsl7080@gmail.com)
class LectureReviewBoardViewController: UIViewController {
    /// 강의평 테이블 뷰
    @IBOutlet weak var lectureReviewListTableView: UITableView!
    
    
    /// 엑스 버튼을 누르면 모달창이 닫힙니다.
    /// - Parameter sender: 엑스 버튼
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

    
    /// 강의 리스트를 파싱합니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
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
            
            let lectureTitle = values[0].trimmingCharacters(in: .whitespaces) // 교과목명
            let professor = values[1].trimmingCharacters(in: .whitespaces) // 교수명
            let openingSemester = values[2].trimmingCharacters(in: .whitespaces) // 개설학기
            let textbookName = values[3].trimmingCharacters(in: .whitespaces) // 교재명
            let bookLink = values[4].trimmingCharacters(in: .whitespaces) // 교재링크
            
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

    
    /// 강의평을 선택 시에 해당하는 강의정보를 보여주기 위한 데이터를 전달합니다.
    /// - Parameters:
    ///   - segue: 호출된 segue
    ///   - sender: segue가 시작된 객체
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = lectureReviewListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? DetailLectureReviewViewController {
                vc.selectedLecture = lectureList[indexPath.row]
            }
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
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



/// 강의평을 나타냄
/// - Author: 김정민, 남정은(dlsl7080@gmail.com)
extension LectureReviewBoardViewController: UITableViewDataSource {
    /// section 안에 들어갈 row의 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 강의평 목록 테이블 뷰
    ///   - section: 강의평 목록을 나누는 section
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
        
        let list: LectureInfo
        
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
    ///   - section: 강의평 목록을 나누는 section
    /// - Returns: header의 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    
    /// section header를 구성합니다.
    /// - Parameters:
    ///   - tableView: 강의평 목록 테이블 뷰
    ///   - section: 강의평 목록을 나누는 section
    /// - Returns: header를 나타내는 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureReviewHeaderTableViewCell") as! LectureReviewHeaderTableViewCell
        
        return cell.contentView
    }
}


