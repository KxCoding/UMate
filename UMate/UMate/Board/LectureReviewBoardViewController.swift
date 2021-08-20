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

    
    func parseList() {
        guard let data = NSDataAsset(name: "lecture2019-1")?.data else {
            return
        }
        
        guard let str = String(data: data, encoding: .utf8) else {
            return
        }
        
        let lines: [String] = str.components(separatedBy: "\n")
        lines.forEach { line in
            print(line)
        }
        
        var index = 0
        
        for line in lines.dropFirst() {
            let values: [String] = line.components(separatedBy: ",")
        
            guard values.count == 7 else { continue }
            
            let assortment = values[0].trimmingCharacters(in: .whitespaces)
            let lectureNumber = values[1].trimmingCharacters(in: .whitespaces)
            let credit = values[2].trimmingCharacters(in: .whitespaces)
            let lectureTitle = values[3].trimmingCharacters(in: .whitespaces)
            let professor = values[4].trimmingCharacters(in: .whitespaces)
            let lectureTime = values[5].trimmingCharacters(in: .whitespaces)
            let lectureRoom = values[6].replacingOccurrences(of: "\r", with: "")
            
            index += 1
            let lectureInfo = LectureInfo(assortment: assortment,
                                          lectureNumber: lectureNumber,
                                          credit: credit,
                                          lectureTitle: lectureTitle,
                                          professor: professor,
                                          lectureTime: lectureTime,
                                          lectureRoom: lectureRoom,
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

    
    func setupSearchBar() {
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
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
    
}




extension LectureReviewBoardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return lectureList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureReviewTableViewCell", for: indexPath) as! LectureReviewTableViewCell
        if indexPath.section == 1 {
            
            let target = lectureList[indexPath.row]
            cell.configure(lecture: target)
            
            return cell
        }
        
        return cell
    }
}




extension LectureReviewBoardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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


