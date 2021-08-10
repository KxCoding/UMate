//
//  SearchHeaderCollectionViewCell.swift
//  SearchHeaderCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit

class SearchHeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterView: UIView!
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        filterView.configureStyle(with: [.pillShape])
    }
}
