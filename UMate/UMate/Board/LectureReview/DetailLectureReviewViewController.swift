//
//  DetailLectureReviewViewController.swift
//  DetailLectureReviewViewController
//
//  Created by 남정은 on 2021/08/17.
//

import UIKit

class DetailLectureReviewViewController: UIViewController {
    
    @IBOutlet weak var lectureInfoTableView: UITableView!
    
    var selectedLectrue: LectureInfo?
    var nonCliked = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let lectrue = selectedLectrue else { return }
        storeRawValue(lecture: lectrue)
        
        //print(resultReview)
    }
    
    /// 리뷰 총합
    typealias Count = (key: Int, value: Int)
    
    /// 각 기준에대해서 항목을 빈도수가 높은 순으로 나열한 배열
    var resultReview = [[Count]]()
    
    /// 각 항목의 빈도수 체크
    private func storeRawValue(lecture: LectureInfo) {
      
        var assignCounter = [Int: Int]()
        var groupCounter = [Int: Int]()
        var evaluationCounter = [Int: Int]()
        var attendanceCounter = [Int: Int]()
        var testCounter = [Int: Int]()
        
        
        for review in lecture.reviews {
           
            if assignCounter.keys.contains(review.assignment.rawValue) {
                assignCounter[review.assignment.rawValue]! += 1
            } else {
                assignCounter[review.assignment.rawValue] = 1
            }
            
            if groupCounter.keys.contains(review.groupMeeting.rawValue) {
                groupCounter[review.groupMeeting.rawValue]! += 1
            } else {
                groupCounter[review.groupMeeting.rawValue] = 1
            }
            
            if evaluationCounter.keys.contains(review.evaluation.rawValue) {
                evaluationCounter[review.evaluation.rawValue]! += 1
            } else {
                evaluationCounter[review.evaluation.rawValue] = 1
            }
            
            if attendanceCounter.keys.contains(review.attendance.rawValue) {
                attendanceCounter[review.attendance.rawValue]! += 1
            } else {
                attendanceCounter[review.attendance.rawValue] = 1
            }
            
            if testCounter.keys.contains(review.testNumber.rawValue) {
                testCounter[review.testNumber.rawValue]! += 1
            } else {
                testCounter[review.testNumber.rawValue] = 1
            }
        }
        
        let CounterList = [assignCounter, groupCounter, evaluationCounter, attendanceCounter, testCounter]
        
        for counter in CounterList {
            var resultCount = [Count]()
            
            for i in counter {
                //print(i) 빈도수 까지는 맞게 저장됨.
                resultCount.append((i.key, i.value))// 빈도수, rawValue값
            }
            
            resultCount.sort{ $0.value > $1.value } // 빈도수 높은게 왼쪽에 가도록
            //print(resultCount) 여기도 맞게 정렬됨.
            resultReview.append(resultCount)
        }
    }
}




extension DetailLectureReviewViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return selectedLectrue?.reviews.count ?? 0
        case 4:
            return 1
        // 시험 작성은 나중에
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedLectrue = selectedLectrue else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LectureSummaryTableViewCell", for: indexPath) as! LectureSummaryTableViewCell
            
            cell.configure(lecture: selectedLectrue)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LectureBookTableViewCell", for: indexPath) as! LectureBookTableViewCell
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LectureRatingTableViewCell", for: indexPath) as! LectureRatingTableViewCell
            
            cell.configure(resultReview: resultReview, lecture: selectedLectrue)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewContentTableViewCell", for: indexPath) as! ReviewContentTableViewCell
            
           
            cell.configure(lecture: selectedLectrue, indexPath: indexPath)
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestInfoTableViewCell", for: indexPath) as! TestInfoTableViewCell
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}



extension DetailLectureReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 3 {
            return 60
        }
       return 0
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailLectureHeaderTableViewCell") as! DetailLectureHeaderTableViewCell
        
        switch section {
        case 0:
            cell.sectionNameLabel.text = selectedLectrue?.lectureTitle
            cell.writeButton.isHidden = true
            
            return cell
        case 1:
            cell.sectionNameLabel.text = "교재 정보"
            cell.writeButton.isHidden = true
            
            return cell
            
        case 2:
            cell.sectionNameLabel.text = "강의평"
            cell.writeButton.setTitle("새 강의평 쓰기", for: .normal)
            
            return cell
            
        case 4:
            cell.sectionNameLabel.text = "시험 정보"
            cell.writeButton.setTitle("시험 정보 공유", for: .normal)
            
            return cell
            
        default:
            return nil
        }
        
    }
}




extension DetailLectureReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionTitleCollectionViewCell", for: indexPath) as! SectionTitleCollectionViewCell
        
        if indexPath.row == 0 {
            /// 아무것도 선택되지 않았을 시에 row == 0 인 cell 선택된 것처럼 보이도록
            if nonCliked {
                cell.sectionTtileLabel.textColor = .black
            }
            /// 다른 카테고리 선택시
            else {
                cell.sectionTtileLabel.textColor = .lightGray
            }
        }
        
        switch indexPath.row {
        case 0:
            cell.sectionTtileLabel.text = "개요"
        case 1:
            cell.sectionTtileLabel.text = "교재 정보"
        case 2:
            cell.sectionTtileLabel.text = "강의평"
        case 3:
            cell.sectionTtileLabel.text = "시험 정보"
        default:
            break
        }
        
        return cell
        
    }
}




extension DetailLectureReviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        /// 다른 카테고리 선택시에 row == 0 인 cell리로드
        if nonCliked {
            nonCliked = false
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        case 1:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
       
        case 2:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
          
        case 3:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: true)
          
        default:
            break
        }
    }
}



