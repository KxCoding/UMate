//
//  LectureReviewBoardViewController.swift
//  LectureReviewBoardViewController
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit



class LectureReviewBoardViewController: UIViewController {
    
    @IBOutlet weak var lectureReviewListTableView: UITableView!
    
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

    
    ///  강의 리스트를 파싱하는 메소드
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
                                        semester: "19년 1학기",
                                        reviewContent: "괜찮아요"),
                          LectureReview(assignment: .normal,
                                        groupMeeting: .many,
                                        evaluation: .generous,
                                        attendance: .seat,
                                        testNumber: .two,
                                        rating: .four,
                                        semester: "19년 2학기",
                                        reviewContent: "강력 추천"),
                          LectureReview(assignment: .many,
                                        groupMeeting: .none,
                                        evaluation: .normal,
                                        attendance: .direct,
                                        testNumber: .none,
                                        rating: .three,
                                        semester: "19년 2학기",
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = lectureReviewListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? DetailLectureReviewViewController {
                vc.selectedLectrue = lectureList[indexPath.row]
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




extension LectureReviewBoardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
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




extension LectureReviewBoardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    
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


