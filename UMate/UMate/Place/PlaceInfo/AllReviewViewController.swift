//
//  AllReviewViewController.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/09/17.
//

import UIKit


/// 리뷰 목록 화면
/// - Author: 장현우(heoun3089@gmail.com)
class AllReviewViewController: UIViewController {
    
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
            
            PlaceReviewItem.dummyData.sort { $0.date > $1.date }
        } else {
            dateAlignmentArrowImageView.image = UIImage(systemName: "arrow.up")
            
            PlaceReviewItem.dummyData.sort { $0.date < $1.date }
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
            
            PlaceReviewItem.dummyData.sort { $0.starPoint > $1.starPoint }
        } else {
            pointAlignmentLabel.text = "별점낮은순"
            pointAlignmentArrowImageView.image = UIImage(systemName: "arrow.up")
            
            PlaceReviewItem.dummyData.sort { $0.starPoint < $1.starPoint }
        }
        
        allReviewTableView.reloadData()
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 리뷰 데이터를 날짜를 기준으로 내림차순 정렬합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlaceReviewItem.dummyData.sort { $0.date > $1.date }
        dateAlignmentLabel.textColor = UIColor(named: "blackSelectedColor")
        dateAlignmentArrowImageView.tintColor = .systemBlue
        
        pointAlignmentArrowImageView.isHidden = true
    }
    
    
    /// 뷰가 나타나기 전에 호출됩니다.
    /// - Parameter animated: 애니메이션 사용 여부
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let placeName = placeName {
            self.navigationController?.navigationBar.topItem?.title = ""
            self.navigationItem.title = "\(placeName)의 리뷰"
        }
    }
}



/// 모든 리뷰 테이블뷰 데이터 관리
extension AllReviewViewController: UITableViewDataSource {
    
    /// 섹션에 표시할 셀 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 리뷰 목록 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 행의 수
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceReviewItem.dummyData.count
    }
    
    
    /// 리뷰 데이터로 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 리뷰 목록 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 구성한 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell", for: indexPath) as! UserReviewTableViewCell
        
        let target = PlaceReviewItem.dummyData[indexPath.row]
        cell.userPointView.rating = target.starPoint
        cell.userPointLabel.text = "\(target.starPoint)"
        cell.reviewTextLabel.text = target.reviewText
        cell.dateLabel.text = target.date.reviewDate
        cell.recommendationCountLabel.text = "\(target.recommendationCount)"
        
        return cell
    }
}
