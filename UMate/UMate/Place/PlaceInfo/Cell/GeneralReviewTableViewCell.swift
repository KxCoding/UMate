//
//  GeneralReviewTableViewCell.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/07/18.
//

import Cosmos
import UIKit


/// 총 평점 셀
/// - Author: 장현우(heoun3089@gmail.com)
class GeneralReviewTableViewCell: UITableViewCell {
    
    /// 별점 이미지뷰
    ///
    /// 사용자가 작성한 별점의 평균값을 이미지로 표시합니다.
    @IBOutlet weak var starPointView: CosmosView!
    
    /// 별점 레이블
    ///
    /// 사용자가 작성한 별점을 숫자로 표시합니다.
    @IBOutlet weak var starPointLabel: UILabel!
    
    /// 맛 평가 레이블
    @IBOutlet weak var tasteLabel: UILabel!
    
    /// 서비스 평가 레이블
    @IBOutlet weak var serviceLabel: UILabel!
    
    /// 분위기 평가 레이블
    @IBOutlet weak var moodLabel: UILabel!
    
    /// 가격 평가 레이블
    @IBOutlet weak var priceLabel: UILabel!
    
    /// 음식양 평가 레이블
    @IBOutlet weak var foodAmountLabel: UILabel!
    
    /// 리뷰쓰기 버튼 컨테이너 뷰
    @IBOutlet weak var reviewWriteContainerView: UIView!
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    ///
    /// 각 평가 항목에 대한 정보를 표시합니다.
    /// - Parameter placeReview: 내가 쓴 리뷰 객체
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
    ///
    /// 리뷰쓰기 버튼 컨테이너 뷰의 UI를 설정합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reviewWriteContainerView.backgroundColor = UIColor(named: "black")
        reviewWriteContainerView.tintColor = .white
        reviewWriteContainerView.frame.size.height = 40
        reviewWriteContainerView.layer.cornerRadius = 10
        reviewWriteContainerView.layer.masksToBounds = true
    }
}
