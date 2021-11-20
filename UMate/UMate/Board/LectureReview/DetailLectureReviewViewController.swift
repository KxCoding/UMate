//
//  DetailLectureReviewViewController.swift
//  DetailLectureReviewViewController
//
//  Created by 남정은 on 2021/08/17.
//

import UIKit


/// 강의 정보 뷰 컨트롤러
/// - Author: 김정민, 남정은(dlsl7080@gmail.com)
class DetailLectureReviewViewController: CommonViewController {
    /// 강의 정보 테이블 뷰
    @IBOutlet weak var lectureInfoTableView: UITableView!
    
    /// 교수명
    var professor: String?

    /// 선택색상을 표현하기 위한 속성
    var isSelected = true
    
    /// 강의 Id
    var lectureInfoId = -1
    
    /// 종합 리뷰평가 이후 테이블 뷰를 표시하도록 함
    let group = DispatchGroup()
    
    /// 강의 정보
    var lectureInfo: LectureInfoDetailResponse.LectrueInfo?
    
    /// 강의평
    var lectureReviewList = [LectureReviewListResponse.LectureReview]()
    
    /// 시험정보
    var testInfoList = [TestInfoListResponse.TestInfo]()
    
    
    /// 강의 정보를 불러옵니다.
    /// - Parameter id: 강의 정보 Id
    ///  - Author: 남정은(dlsl7080@gmail.com)
    private func fetchLectureInfo(id: Int) {
        guard let url = URL(string: "https://board1104.azurewebsites.net/api/lectureInfo/\(id)") else { return }
        
        BoardDataManager.shared.session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(LectureInfoDetailResponse.self, from: data)
                
                if data.resultCode == ResultCode.ok.rawValue {
                    self.lectureInfo = data.lectureInfo
                }
                self.fetchLectureReviews(lectureInfoid: self.lectureInfoId)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    /// 강의평을 불러옵니다.
    /// - Parameter id: 강의 정보 Id
    ///  - Author: 남정은(dlsl7080@gmail.com)
    private func fetchLectureReviews(lectureInfoid: Int) {
        guard let url = URL(string: "https://board1104.azurewebsites.net/api/lectureReview?lectureInfoId=\(lectureInfoid)") else { return }
        
        BoardDataManager.shared.session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(LectureReviewListResponse.self, from: data)
                
                if data.resultCode == ResultCode.ok.rawValue {
                    self.lectureReviewList = data.lectureReviews
                    self.evaluatelecture(reviews: data.lectureReviews)
                }
                self.fetchTestInfos(lectureInfoid: self.lectureInfoId)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    /// 시험 정보를 불러옵니다.
    /// - Parameter id: 강의 정보 Id
    ///  - Author: 남정은(dlsl7080@gmail.com)
    private func fetchTestInfos(lectureInfoid: Int) {
        guard let url = URL(string: "https://board1104.azurewebsites.net/api/testInfo?lectureInfoId=\(lectureInfoid)") else { return }
        
        BoardDataManager.shared.session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(TestInfoListResponse.self, from: data)
                
                if data.resultCode == ResultCode.ok.rawValue {
                    self.testInfoList = data.testInfos
                    
                    self.group.notify(queue: .main) {
                        self.lectureInfoTableView.reloadData()
                        self.lectureInfoTableView.isHidden = false
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    /// 리뷰 총합
    typealias Count = (key: Int, value: Int)
    
    /// 각 기준에대해서 항목을 빈도수가 높은 순으로 나열한 배열
    var sortedResultReviewList = [Int]()
    
    /// 과제에 대한 항목 개수 체크
    var assignCounter = [Int: Int]()
    
    /// 조모임에 대한 항목 개수 체크
    var groupCounter = [Int: Int]()
    
    /// 학점 비율에대한 항목 개수 체크
    var evaluationCounter = [Int: Int]()
    
    /// 출결에대한 항목 개수 체크
    var attendanceCounter = [Int: Int]()
    
    /// 시험 횟수에대한 항목 개수 체크
    var testCounter = [Int: Int]()
    
    
    /// 각 항목의 빈도수를 rawValue로 체크합니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func evaluatelecture(reviews: [LectureReviewListResponse.LectureReview]) {
        group.enter()
        sortedResultReviewList.removeAll()
        defer {
            group.leave()
        }
        
        for review in reviews {
            
            // 과제에 있는 많음/보통/없음 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if assignCounter.keys.contains(review.assignment) {
                assignCounter[review.assignment]! += 1
            } else {
                assignCounter[review.assignment] = 1
            }
            
            // 조모임에 있는 많음/보통/없음 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if groupCounter.keys.contains(review.groupMeeting) {
                groupCounter[review.groupMeeting]! += 1
            } else {
                groupCounter[review.groupMeeting] = 1
            }
            
            // 학점 비율에 있는 후함/비율채워줌/매우깐깐함/F폭격기 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if evaluationCounter.keys.contains(review.evaluation) {
                evaluationCounter[review.evaluation]! += 1
            } else {
                evaluationCounter[review.evaluation] = 1
            }
            
            // 출결에 있는 혼용/직접호명/지정좌석/전자출결/반영안함 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if attendanceCounter.keys.contains(review.attendance) {
                attendanceCounter[review.attendance]! += 1
            } else {
                attendanceCounter[review.attendance] = 1
            }
            
            // 시험 횟수에 있는 네번이상/세번/두번/한번/없음 항목 중에 rawValue값이 assignCounter에 있다면 +1, 없다면 rawValue값으로 key등록해주고 +1
            if testCounter.keys.contains(review.testNumber) {
                testCounter[review.testNumber]! += 1
            } else {
                testCounter[review.testNumber] = 1
            }
        }
        
        let counterList = [assignCounter, groupCounter, evaluationCounter, attendanceCounter, testCounter]
        
        // 각각의 리뷰 기준에 있는 항목을 빈도수 순으로 정렬하고 resultReview배열에 담는다.
        for counter in counterList {
            var resultCounter = [Count]()
            
            for i in counter {
                resultCounter.append((i.key, i.value)) // rawValue값,  빈도수
            }

            resultCounter.sort{ $0.value > $1.value } // 빈도수 높은게 왼쪽에 가도록
            sortedResultReviewList.append(resultCounter.first?.key ?? 0)
        }
    }
    

    /// 시험정보공유 작성화면에 강의에 대한 정보를 전달합니다.
    /// - Parameters:
    ///   - segue: 호출된 segue
    ///   - sender: segue가 시작된 객체
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TestInfoWriteViewController {
            vc.lectureInfo = lectureInfo
        }
        
        if let vc = segue.destination as? LectureReviewWriteTableViewController {
            vc.lectureInfo = lectureInfo
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lectureInfoTableView.isHidden = true
        
        let headerNib = UINib(nibName: "LectureInfoCustomHeader", bundle: nil)
        lectureInfoTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        fetchLectureInfo(id: lectureInfoId)
        
        // 강의평 추가
        var token = NotificationCenter.default.addObserver(forName: .newLectureReviewDidInput, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            if let newReview = noti.userInfo?["review"] as? LectureReviewListResponse.LectureReview {
                self.lectureReviewList.append(newReview)
                
                if self.lectureReviewList.count > 0 {
                    self.evaluatelecture(reviews: self.lectureReviewList)
                    
                    self.group.notify(queue: .main) {
                        if self.lectureReviewList.count == 1 {
                            self.lectureInfoTableView.insertRows(at: [IndexPath(row: 0, section: 2), IndexPath(row: self.lectureReviewList.count - 1, section: 3)], with: .automatic)
                        } else {
                            self.lectureInfoTableView.insertRows(at: [IndexPath(row: self.lectureReviewList.count - 1, section: 3)], with: .automatic)
                            self.lectureInfoTableView.reloadSections(IndexSet(2...2), with: .automatic)
                        }
                    }
                }
            }
        }
        tokens.append(token)
        
        // 시험 정보 추가
        token = NotificationCenter.default.addObserver(forName: .testInfoDidShare, object: nil, queue: .main) { noti in
            if let testInfo = noti.userInfo?["testInfo"] as? TestInfoListResponse.TestInfo {
                self.testInfoList.append(testInfo)
                
                let count = self.testInfoList.count
                self.lectureInfoTableView.insertRows(at: [IndexPath(row: count - 1, section: 4)], with: .automatic)
            }
        }
        tokens.append(token)
    }
    
    
    /// 뷰 계층에 모든 뷰들이 추가된 이후 호출됩니다.
    /// - Parameter animated: 윈도우에 뷰가 추가될 때 애니메이션 여부. 기본값은 true입니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        // 헤더뷰 버튼 동작
        let token = NotificationCenter.default.addObserver(forName: .performSegueToWrite, object: nil, queue: .main, using: { [weak self] noti in
            guard let self = self else { return }
            if let tag = noti.userInfo?["tag"] as? Int {
                if tag == 2 {
                    self.performSegue(withIdentifier: "writeReviewSegue", sender: self)
                } else {
                    self.performSegue(withIdentifier: "testInfoSegue", sender: self)
                }
            }
        })
        tokens.append(token)
    }
}



/// 강의 정보를 나타냄
/// - Author: 남정은(dlsl7080@gmail.com)
extension DetailLectureReviewViewController: UITableViewDataSource {
    /// 강의 정보를 나타내기 위한 section 수를 리턴합니다.
    /// - Parameter tableView: 강의 정보 테이블 뷰
    /// - Returns: section의 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    /// 강의 정보를 나타내기 위한 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 강의 정보 테이블 뷰
    ///   - section: 강의 정보를 나누는 section
    /// - Returns: section안에 포함되는 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // 강의 개요
        case 0:
            return 1
            
        // 교재 정보
        case 1:
            return 1
            
        // 종합 리뷰
        case 2:
            if lectureReviewList.count > 0 {
                return 1
            }
            return 0
            
        // 개별 리뷰
        case 3:
            return lectureReviewList.count
            
        // 시험 정보
        case 4:
            return testInfoList.count
            
        default:
            return 0
        }
    }
    
    
    /// 강의 정보 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 강의 정보 테이블 뷰
    ///   - indexPath: 강의 정보 셀의 indexPath
    /// - Returns: 강의 정보 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let lectureInfo = lectureInfo else { return UITableViewCell() }
        
        switch indexPath.section {
        // 강의 개요
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LectureSummaryTableViewCell", for: indexPath) as! LectureSummaryTableViewCell
            
            cell.configure(lecture: lectureInfo, professor: professor ?? "")
            return cell
            
        // 교재 정보
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LectureBookTableViewCell", for: indexPath) as! LectureBookTableViewCell
            
            
            cell.configure(lecture: lectureInfo)
            return cell
            
        // 종합 리뷰
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LectureRatingTableViewCell", for: indexPath) as! LectureRatingTableViewCell
            
            let ratingSum = lectureReviewList.reduce(0) { partialResult, review in
                return partialResult + review.rating
            }
           
            let ratingAvg = Double(ratingSum) / Double(lectureReviewList.count).rounded()
            cell.configure(resultReview: sortedResultReviewList, ratingAvg: ratingAvg)
            return cell
            
        // 개별 리뷰
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewContentTableViewCell", for: indexPath) as! ReviewContentTableViewCell
            
            let review = lectureReviewList[indexPath.row]
            cell.configure(review: review)
            return cell
            
        // 시험 정보
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestInfoTableViewCell", for: indexPath) as! TestInfoTableViewCell
            
            let testInfo = testInfoList[indexPath.row]
            cell.configure(testInfo: testInfo)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}



/// 강의정보 tableView header를 설정
/// - Author: 남정은(dlsl7080@gmail.com)
extension DetailLectureReviewViewController: UITableViewDelegate {
    /// section header의 높이를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 강의 정보 테이블 뷰
    ///   - section: 강의 정보를 나누는 section
    /// - Returns: header의 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // section3은 section2에 속함
        if section != 3 {
            return 60
        }
       return 0
    }

    
    /// section header를 구성합니다.
    /// - Parameters:
    ///   - tableView: 강의 정보 테이블 뷰
    ///   - section: 강의 정보를 나누는 section
    /// - Returns: header를 나타내는 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! LectureInfoCustomHeaderView
        headerView.backView.backgroundColor = .systemBackground
        
        switch section {
        // 강의 개요
        case 0:
            headerView.sectionNameLabel.text = lectureInfo?.title ?? ""
            headerView.writeButton.isHidden = true
            
            return headerView
            
        // 교재 정보
        case 1:
            headerView.sectionNameLabel.text = "교재 정보"
            headerView.writeButton.isHidden = true
            
            return headerView
            
        // 종합 리뷰
        case 2:
            headerView.sectionNameLabel.text = "강의평"
            headerView.writeButton.setTitle("새 강의평 쓰기", for: .normal)
            headerView.writeButton.tag = 2
            return headerView
            
        // 시험 정보
        case 4:
            headerView.sectionNameLabel.text = "시험 정보"
            headerView.writeButton.setTitle("시험 정보 공유", for: .normal)
            headerView.writeButton.tag = 4
            
            return headerView
            
        default:
            return nil
        }
    }
}



/// 강의정보 위에 소제목을 컬렉션 뷰로 나타냄
/// - Author: 남정은(dlsl7080@gmail.com)
extension DetailLectureReviewViewController: UICollectionViewDataSource {
    /// 강의 정보의 소제목의 개수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 소제목 컬렉션 뷰
    ///   - section: 소제목을 나누는 section
    /// - Returns: section안에 들어갈 item 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    /// 소제목을 구성하는 셀을 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 소제목 컬렉션 뷰
    ///   - indexPath: 소제목의 indexPath
    /// - Returns: 소제목 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionTitleCollectionViewCell", for: indexPath) as! SectionTitleCollectionViewCell
        
        if indexPath.row == 0 {
            // 아무것도 선택되지 않았을 때 row == 0 인 셀이 선택된 것처럼 보이도록
            if isSelected {
                cell.sectionTtileLabel.textColor = UIColor.init(named: "blackSelectedColor")
            }
            // 다른 카테고리 선택
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



/// 강의 정보 위에 나타낼 컬렉션 뷰 동작 처리
/// - Author: 남정은(dlsl7080@gmail.com)
extension DetailLectureReviewViewController: UICollectionViewDelegate {
    ///  컬렉션 뷰 셀을 클릭 시에 호출됩니다.
    ///
    /// 다른 소제목 선택시에 row == 0 인 cell을 리로드하여 선택되지 않은 상태로 보여지게 합니다.
    /// - Parameters:
    ///   - collectionView: 소제목 컬렉션 뷰
    ///   - indexPath: 소제목 셀의 indexPath
    /// - Returns: 셀의 선택 가능 여부. true일 때는 선택이 되며, false일 때는 선택이 되지 않습니다.
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if isSelected {
            isSelected = false
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        return true
    }
    
    
    /// 소제목 셀을 선택했을 때 동작합니다.
    ///
    /// 소제목에 해당하는 부분을 보여주도록 강의 정보 테이블 뷰를 스크롤합니다.
    /// - Parameters:
    ///   - collectionView: 소제목 컬렉션 뷰
    ///   - indexPath: 소제목 셀의 indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        // 개요 선택시 개요 부분으로 스크롤 이동
        case 0:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        // 교재 정보 선택 시
        case 1:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
       
        // 강의평 선택 시
        case 2:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
          
        // 시험 정보 선택 시
        case 3:
            lectureInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 4), at: .top, animated: true)
          
        default:
            break
        }
    }
}



