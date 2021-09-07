//
//  DetailLectureReviewViewController.swift
//  DetailLectureReviewViewController
//
//  Created by 남정은 on 2021/08/17.
//

import UIKit

class DetailLectureReviewViewController: UIViewController {
    
    @IBOutlet weak var lectureInfoTableView: UITableView!
    
    @IBAction func perfromSegueToWrite(_ sender: UIButton) {
        if sender.tag == 2 {
            performSegue(withIdentifier: "writeReviewSegue", sender: self)
        } else {
            performSegue(withIdentifier: "testInfoSegue", sender: self)
        }
    }
    
    
    var selectedLectrue: LectureInfo?

    var isSelected = true
    
    @IBAction func unwindToDetailLectureReview(_ unwindSegue: UIStoryboardSegue) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let lectrue = selectedLectrue else { return }
        storeRawValue(lecture: lectrue)
        
        NotificationCenter.default.addObserver(forName: .newLectureReviewDidInput, object: nil, queue: .main) { [weak self] (noti) in
            if let newReview = noti.userInfo?["review"] as? LectureReview {
                self?.selectedLectrue?.reviews.insert(newReview, at: 0)
                self?.lectureInfoTableView.reloadData()
            }
        }
    }
    
    /// 리뷰 총합
    typealias Count = (key: Int, value: Int)
    
    /// 각 기준에대해서 항목을 빈도수가 높은 순으로 나열한 배열
    var sortedResultReviewList = [[Count]]()
    
    /// 각 항목의 빈도수를 rawValue로 체크
    private func storeRawValue(lecture: LectureInfo) {
      
        var assignCounter = [Int: Int]() /// 과제에 대한 항목 개수 체크
        var groupCounter = [Int: Int]() /// 조모임에 대한 항목 개수 체크
        var evaluationCounter = [Int: Int]() /// 학점 비율에대한 항목 개수 체크
        var attendanceCounter = [Int: Int]() /// 출결에대한 항목 개수 체크
        var testCounter = [Int: Int]() /// 시험 횟수에대한 항목 개수 체크
        
        for review in lecture.reviews {
            
            /// 과제에 있는 많음/보통/없음 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if assignCounter.keys.contains(review.assignment.rawValue) {
                assignCounter[review.assignment.rawValue]! += 1
            } else {
                assignCounter[review.assignment.rawValue] = 1
            }
            
            /// 조모임에 있는 많음/보통/없음 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if groupCounter.keys.contains(review.groupMeeting.rawValue) {
                groupCounter[review.groupMeeting.rawValue]! += 1
            } else {
                groupCounter[review.groupMeeting.rawValue] = 1
            }
            
            /// 학점 비율에 있는 후함/비율채워줌/매우깐깐함/F폭격기 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if evaluationCounter.keys.contains(review.evaluation.rawValue) {
                evaluationCounter[review.evaluation.rawValue]! += 1
            } else {
                evaluationCounter[review.evaluation.rawValue] = 1
            }
            
            /// 출결에 있는 혼용/직접호명/지정좌석/전자출결/반영안함 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if attendanceCounter.keys.contains(review.attendance.rawValue) {
                attendanceCounter[review.attendance.rawValue]! += 1
            } else {
                attendanceCounter[review.attendance.rawValue] = 1
            }
            
            /// 시험 횟수에 있는 네번이상/세번/두번/한번/없음 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if testCounter.keys.contains(review.testNumber.rawValue) {
                testCounter[review.testNumber.rawValue]! += 1
            } else {
                testCounter[review.testNumber.rawValue] = 1
            }
        }
        
        let counterList = [assignCounter, groupCounter, evaluationCounter, attendanceCounter, testCounter]
        
        /// 각각의 리뷰 기준에 있는 항목을 빈도수 순으로 정렬하고 resultReview배열에 담는다.
        for counter in counterList {
            var resultCounter = [Count]()
            
            for i in counter {
                resultCounter.append((i.key, i.value)) /// rawValue값,  빈도수
            }

            resultCounter.sort{ $0.value > $1.value } /// 빈도수 높은게 왼쪽에 가도록
            sortedResultReviewList.append(resultCounter)
        }
    }
}




extension DetailLectureReviewViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        /// 강의 개요
        case 0:
            return 1
            
        /// 교재 정보
        case 1:
            return 1
            
        /// 종합 리뷰
        case 2:
            return 1
            
        /// 개별 리뷰
        case 3:
            return selectedLectrue?.reviews.count ?? 0
            
        /// 시험 정보
        case 4:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedLectrue = selectedLectrue else { return UITableViewCell() }
        
        switch indexPath.section {
        /// 강의 개요
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LectureSummaryTableViewCell", for: indexPath) as! LectureSummaryTableViewCell
            
            cell.configure(lecture: selectedLectrue)
            return cell
            
        /// 교재 정보
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LectureBookTableViewCell", for: indexPath) as! LectureBookTableViewCell
            
            return cell
            
        /// 종합 리뷰
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LectureRatingTableViewCell", for: indexPath) as! LectureRatingTableViewCell
            
            cell.configure(resultReview: sortedResultReviewList, lecture: selectedLectrue)
            return cell
            
        /// 개별 리뷰
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewContentTableViewCell", for: indexPath) as! ReviewContentTableViewCell
            
            
            cell.configure(lecture: selectedLectrue, indexPath: indexPath)
            return cell
            
        /// 시험 정보
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
        /// section3은 section2에 속함
        if section != 3 {
            return 60
        }
       return 0
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailLectureHeaderTableViewCell") as! DetailLectureHeaderTableViewCell
        
        switch section {
        /// 강의 개요
        case 0:
            cell.sectionNameLabel.text = selectedLectrue?.lectureTitle
            cell.writeButton.isHidden = true
            
            return cell
            
        /// 교재 정보
        case 1:
            cell.sectionNameLabel.text = "교재 정보"
            cell.writeButton.isHidden = true
            
            return cell
            
        /// 종합 리뷰
        case 2:
            cell.sectionNameLabel.text = "강의평"
            cell.writeButton.setTitle("새 강의평 쓰기", for: .normal)
            cell.writeButton.tag = 2
            return cell
            
        /// 시험 정보
        case 4:
            cell.sectionNameLabel.text = "시험 정보"
            cell.writeButton.setTitle("시험 정보 공유", for: .normal)
            cell.writeButton.tag = 4
            
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
            if isSelected {
                cell.sectionTtileLabel.textColor = UIColor.init(named: "blackSelectedColor")
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
        if isSelected {
            isSelected = false
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        /// 개요 선택시 개요 부분으로 스크롤 이동
        case 0:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        /// 교재 정보 선택시
        case 1:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
       
        /// 강의평 선택시
        case 2:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
          
        /// 시험 정보 선택시
        case 3:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: true)
          
        default:
            break
        }
    }
}



