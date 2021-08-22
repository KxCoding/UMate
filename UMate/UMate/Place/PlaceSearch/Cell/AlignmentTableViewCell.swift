//
//  AlignmentTableViewCell.swift
//  AlignmentTableViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit

class AlignmentTableViewCell: UITableViewCell {
    /// 정렬 관련 변수들
    @IBOutlet weak var ratingButton: RoundedButton!
    @IBOutlet weak var recommendationButton: RoundedButton!
    @IBOutlet weak var reviewButton: RoundedButton!
    @IBOutlet weak var distanceButton: RoundedButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    /// - Parameter sender: 버튼
    @IBAction func alignmentSelectLineButtonTapped(_ sender: RoundedButton) {
        ratingButton.isSelected = sender.tag == 100
        recommendationButton.isSelected = sender.tag == 101
        reviewButton.isSelected = sender.tag == 102
        distanceButton.isSelected = sender.tag == 103
        
        /// Selected 상태에 따라 버튼의 백그라운드 색상 설정
        [ratingButton, recommendationButton, reviewButton, distanceButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
}
