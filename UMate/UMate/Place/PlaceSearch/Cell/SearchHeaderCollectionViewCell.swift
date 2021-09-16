//
//  SearchHeaderCollectionViewCell.swift
//  SearchHeaderCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit


/// 필터 버튼을 넣을 컬렉션뷰셀 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class SearchHeaderCollectionViewCell: UICollectionViewCell {
    /// 필터 버튼을 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var filterView: UIView!
    
    
    /// 초기화 작업을 실행합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filterView.configureStyle(with: [.pillShape])
    }
}
