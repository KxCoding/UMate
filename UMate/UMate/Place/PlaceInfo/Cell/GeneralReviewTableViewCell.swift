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
    
    
    func configure(with placeReview: PlaceReviewItem) {
        starPointLabel.text = "\(starPointView.rating)"
        tasteLabel.text = placeReview.taste.rawValue
        serviceLabel.text = placeReview.service.rawValue
        moodLabel.text = placeReview.mood.rawValue
        priceLabel.text = placeReview.price.rawValue
        foodAmountLabel.text = placeReview.amount.rawValue
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reviewWriteContainerView.layer.cornerRadius = 10
    }



}
