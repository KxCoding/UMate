//
//  SearchHeaderCollectionViewCell.swift
//  SearchHeaderCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit


/// 필터 버튼 셀
/// - Author: 장현우(heoun3089@gmail.com)
class SearchHeaderCollectionViewCell: UICollectionViewCell {
    
    /// 필터 버튼 컨테이너 뷰
    @IBOutlet weak var filterButtonContainerView: UIView!
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 필터 버튼 컨테이너 뷰의 UI를 설정합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filterButtonContainerView.configureStyle(with: [.pillShape])
    }
}
