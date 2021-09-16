//
//  GeneralReviewTableViewCell.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/07/18.
//

import Cosmos
import UIKit


/// 평점을 나타낼 테이블뷰 셀 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class GeneralReviewTableViewCell: UITableViewCell {
    /// 별점을 이미지로 표시하는 뷰
    /// 사용자가 작성한 별점의 평균값을 이미지로 표시합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var starPointView: CosmosView!
    
    /// 별점을 숫자로 표시하는 레이블
    /// 사용자가 작성한 별점의 평균값을 숫자로 표시합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var starPointLabel: UILabel!
    
    /// 맛 관련 평가를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var tasteLabel: UILabel!
    
    /// 서비스 관련 평가를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var serviceLabel: UILabel!
    
    /// 분위기 관련 평가를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var moodLabel: UILabel!
    
    /// 가격 관련 평가를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var priceLabel: UILabel!
    
    /// 음식양 관련 평가를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var foodAmountLabel: UILabel!
    
    /// 리뷰쓰기 버튼을 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var reviewWriteContainerView: UIView!
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter placeReview: 표시할 내용을 가진 구조체
    /// - Author: 장현우(heoun3089@gmail.com)
    func configure(with placeReview: PlaceReviewItem) {
        starPointLabel.text = "\(starPointView.rating)"
        tasteLabel.text = placeReview.taste.rawValue
        serviceLabel.text = placeReview.service.rawValue
        moodLabel.text = placeReview.mood.rawValue
        priceLabel.text = placeReview.price.rawValue
        foodAmountLabel.text = placeReview.amount.rawValue
    }
    
    
    /// 초기화 작업을 실행합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // reviewWriteContainerView UI 설정
        reviewWriteContainerView.backgroundColor = UIColor(named: "black")
        reviewWriteContainerView.tintColor = .white
        reviewWriteContainerView.frame.size.height = 40
        reviewWriteContainerView.layer.cornerRadius = 10
        reviewWriteContainerView.layer.masksToBounds = true
    }
}
