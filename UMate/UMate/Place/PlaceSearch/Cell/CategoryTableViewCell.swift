//
//  CategoryTableViewCell.swift
//  CategoryTableViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit


/// 카테고리 버튼 셀
/// - Author: 장현우(heoun3089@gmail.com)
class CategoryTableViewCell: UITableViewCell {
    
    /// 전체 카테고리 버튼
    @IBOutlet weak var allButton: RoundedButton!
    
    /// 가고싶다 버튼
    @IBOutlet weak var wantTogoButton: RoundedButton!
    
    /// 가봤어요 버튼
    @IBOutlet weak var haveBeenButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    ///
    /// Selected 상태에 따라 버튼의 백그라운드 색상 설정합니다.
    /// - Parameter sender: 전체 버튼, 가고싶다 버튼, 가봤어요 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func categorySelectLineButtonTapped(_ sender: RoundedButton) {
        allButton.isSelected = sender.tag == 200
        wantTogoButton.isSelected = sender.tag == 201
        haveBeenButton.isSelected = sender.tag == 202
        
        [allButton, wantTogoButton, haveBeenButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
}
