//
//  AlignmentTableViewCell.swift
//  AlignmentTableViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit


/// 정렬 버튼 셀
/// - Author: 장현우(heoun3089@gmail.com)
class AlignmentTableViewCell: UITableViewCell {
    
    /// 평점순 버튼
    @IBOutlet weak var ratingButton: RoundedButton!
    
    /// 추천순 버튼
    @IBOutlet weak var recommendationButton: RoundedButton!
    
    /// 리뷰순 버튼
    @IBOutlet weak var reviewButton: RoundedButton!
    
    /// 거리순 버튼
    @IBOutlet weak var distanceButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    /// - Parameter sender: 평점순 버튼, 추천순 버튼, 리뷰순 버튼, 거리순 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func alignmentSelectLineButtonTapped(_ sender: RoundedButton) {
        ratingButton.isSelected = sender.tag == 100
        recommendationButton.isSelected = sender.tag == 101
        reviewButton.isSelected = sender.tag == 102
        distanceButton.isSelected = sender.tag == 103
        
        // Selected 상태에 따라 버튼의 백그라운드 색상 설정
        [ratingButton, recommendationButton, reviewButton, distanceButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
}
