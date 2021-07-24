//
//  UserReviewTableViewCell.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/07/19.
//

import UIKit
import Cosmos

class UserReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userPointView: CosmosView!
    @IBOutlet weak var userPointLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recommendationView: UIView!
    @IBOutlet weak var recommendationImageView: UIImageView!
    @IBOutlet weak var recommendationLabel: UILabel!
    @IBOutlet weak var recommendationButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    
    @IBAction func recommendationButtonTapped(_ sender: UIButton) {
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == false
        recommendationImageView.isHighlighted = recommendationImageView.isHighlighted == true
        
        if recommendationImageView.isHighlighted {
            recommendationLabel.textColor = .systemRed
        } else {
            recommendationLabel.textColor = .lightGray
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPointLabel.text = "\(userPointView.rating)"
        recommendationView.layer.cornerRadius = 5
        reportButton.layer.cornerRadius = 5
        
    }

}

