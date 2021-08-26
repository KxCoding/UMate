//
//  ReviewContentTableViewCell.swift
//  ReviewContentTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit
import Cosmos


class ReviewContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var semesterLabel: UILabel!
    
    @IBOutlet weak var reviewContentLabel: UILabel!
    
    
    func configure(lecture: LectureInfo, indexPath: IndexPath) {
        reviewContentLabel.text = lecture.reviews[indexPath.row].reviewContent
        ratingView.rating = Double(lecture.reviews[indexPath.row].rating.rawValue)
    }
}
