//
//  GeneralReviewTableViewCell.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/07/18.
//

import UIKit
import Cosmos

class GeneralReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var starPointView: CosmosView!
    @IBOutlet weak var starPointLabel: UILabel!
    @IBOutlet weak var tasteLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var foodAmountLabel: UILabel!
    @IBOutlet weak var reviewWriteContainerView: UIView!
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        /// reviewWriteContainerView의 cornerRadius 설정
        reviewWriteContainerView.configureStyle(with: [.pillShape])
    }
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter placeReview: 표시할 내용을 가진 구조체
    func configure(with placeReview: PlaceReviewItem) {
        starPointLabel.text = "\(starPointView.rating)"
        tasteLabel.text = placeReview.taste.rawValue
        serviceLabel.text = placeReview.service.rawValue
        moodLabel.text = placeReview.mood.rawValue
        priceLabel.text = placeReview.price.rawValue
        foodAmountLabel.text = placeReview.amount.rawValue
    }
}
