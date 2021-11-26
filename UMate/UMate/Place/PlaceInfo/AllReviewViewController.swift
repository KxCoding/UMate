//
//  AllReviewViewController.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/09/17.
//

import UIKit


/// 리뷰 목록 화면
/// - Author: 장현우(heoun3089@gmail.com)
class AllReviewViewController: CommonViewController {
    
    /// 리뷰 목록 테이블뷰
    @IBOutlet weak var allReviewTableView: UITableView!
    
    
    /// 날짜순 정렬 레이블
    @IBOutlet weak var dateAlignmentLabel: UILabel!
    
    /// 날짜순 정렬 화살표 이미지뷰
    @IBOutlet weak var dateAlignmentArrowImageView: UIImageView!
    
    /// 날짜순 정렬 버튼
    @IBOutlet weak var dateAlignmentButton: UIButton!
    
    
    /// 별점순 정렬 레이블
    @IBOutlet weak var pointAlignmentLabel: UILabel!
    
    /// 별점순 정렬 화살표 이미지뷰
    @IBOutlet weak var pointAlignmentArrowImageView: UIImageView!
    
    /// 별점순 정렬 버튼
    @IBOutlet weak var pointAlignmentButton: UIButton!
    
    
    /// 상점 이름
    ///
    /// 이전 화면에서 전달됩니다.
    var placeName: String?
    
    /// 선택한 상점에 해당하는 리뷰 목록
    var targetPlaceList: [PlaceReviewList.PlaceReview]?
    
    
    /// 리뷰를 날짜순으로 정렬합니다.
    /// - Parameter sender: 날짜순 정렬 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func toggleDateAlignment(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if !pointAlignmentArrowImageView.isHidden {
            pointAlignmentLabel.textColor = .systemGray2
            pointAlignmentButton.isSelected = false
            pointAlignmentArrowImageView.isHidden = true
        }
        
        if sender.isSelected {
            dateAlignmentArrowImageView.isHidden = false
            dateAlignmentLabel.textColor = UIColor(named: "blackSelectedColor")
            dateAlignmentArrowImageView.tintColor = .systemBlue
            dateAlignmentArrowImageView.image = UIImage(systemName: "arrow.down")
            
            self.targetPlaceList?.sort { $0.insertDate > $1.insertDate }
        } else {
            dateAlignmentArrowImageView.image = UIImage(systemName: "arrow.up")
            
            self.targetPlaceList?.sort { $0.insertDate < $1.insertDate }
        }
        
        allReviewTableView.reloadData()
    }
    
    
    /// 리뷰를 별점순으로 정렬합니다.
    /// - Parameter sender: 별점순 정렬 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func togglePointAlignment(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if !dateAlignmentArrowImageView.isHidden {
            dateAlignmentLabel.textColor = .systemGray2
            dateAlignmentButton.isSelected = false
            dateAlignmentArrowImageView.isHidden = true
        }
        
        if sender.isSelected {
            pointAlignmentLabel.text = "별점높은순"
            pointAlignmentArrowImageView.isHidden = false
            pointAlignmentLabel.textColor = UIColor(named: "blackSelectedColor")
            pointAlignmentArrowImageView.tintColor = .systemBlue
            pointAlignmentArrowImageView.image = UIImage(systemName: "arrow.down")
            
            self.targetPlaceList?.sort { $0.starRating > $1.starRating }
        } else {
            pointAlignmentLabel.text = "별점낮은순"
            pointAlignmentArrowImageView.image = UIImage(systemName: "arrow.up")
            
            self.targetPlaceList?.sort { $0.starRating < $1.starRating }
        }
        
        allReviewTableView.reloadData()
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 리뷰 데이터를 날짜를 기준으로 내림차순 정렬합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlaceReviewDataManager.shared.fetchAllReview(vc: self) {
            PlaceReviewDataManager.shared.allPlaceReviewList.sort { $0.insertDate > $1.insertDate }
            self.dateAlignmentButton.isSelected = true
            self.dateAlignmentLabel.textColor = UIColor(named: "blackSelectedColor")
            self.dateAlignmentArrowImageView.tintColor = .systemBlue
            self.pointAlignmentArrowImageView.isHidden = true
            
            self.allReviewTableView.reloadData()
        }
    }
    
    
    /// 뷰가 나타나기 전에 호출됩니다.
    /// - Parameter animated: 애니메이션 사용 여부
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let placeName = placeName {
            self.navigationController?.navigationBar.topItem?.title = ""
            self.navigationItem.title = "\(placeName)의 리뷰"
            
            targetPlaceList = PlaceReviewDataManager.shared.allPlaceReviewList.filter { $0.place.name == placeName }
        }
    }
}



/// 리뷰 목록 테이블뷰 데이터 관리
extension AllReviewViewController: UITableViewDataSource {
    
    /// 섹션에 표시할 셀 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 리뷰 목록 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 행의 수
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let targetPlaceList = targetPlaceList else { return 0 }
        
        return targetPlaceList.count
    }
    
    
    /// 리뷰 데이터로 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 리뷰 목록 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 구성한 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell", for: indexPath) as! UserReviewTableViewCell
        
        guard let targetPlaceList = targetPlaceList else { return UITableViewCell() }
        
        let target = targetPlaceList[indexPath.row]
        cell.userPointView.rating = target.starRating
        cell.userPointLabel.text = "\(target.starRating)"
        cell.reviewTextLabel.text = target.reviewText
        cell.dateLabel.text = target.insertDate.reviewDBDate?.reviewDate
        cell.recommendationCountLabel.text = "\(target.recommendationCount)"
        
        return cell
    }
}
