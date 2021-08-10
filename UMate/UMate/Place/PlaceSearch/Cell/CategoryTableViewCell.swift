//
//  CategoryTableViewCell.swift
//  CategoryTableViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var allButton: RoundedButton!
    @IBOutlet weak var wantTogoButton: RoundedButton!
    @IBOutlet weak var haveBeenButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    /// - Parameter sender: 버튼
    @IBAction func categorySelectLineButtonTapped(_ sender: RoundedButton) {
        allButton.isSelected = sender.tag == 200
        wantTogoButton.isSelected = sender.tag == 201
        haveBeenButton.isSelected = sender.tag == 202
        
        /// Selected 상태에 따라 버튼의 백그라운드 색상 설정
        [allButton, wantTogoButton, haveBeenButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
}
