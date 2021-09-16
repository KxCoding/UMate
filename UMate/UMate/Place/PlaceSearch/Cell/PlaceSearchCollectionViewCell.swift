//
//  PlaceSearchCollectionViewCell.swift
//  PlaceSearchCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/08/01.
//

import UIKit


/// 가게 검색 결과를 표시할 컬렉션뷰셀 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class PlaceSearchCollectionViewCell: UICollectionViewCell {
    /// 가게 이미지뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var imageView: UIImageView!
    
    /// 가게 이름을 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var placeTitleLabel: UILabel!
    
    /// 지역 이름을 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var regionNameLabel: UILabel!
    
    /// 가게 종류를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var classificationNameLabel: UILabel!
    
    /// 검색 화면 UI를 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var searchContentView: UIView!
    
    
    /// 컬렉션뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter searchItem: 표시할 내용을 가진 구조체
    /// - Author: 장현우(heoun3089@gmail.com)
    func configure(with searchItem: Place, image: UIImage?) {
        imageView.image = image
        placeTitleLabel.text = searchItem.name
        regionNameLabel.text = searchItem.district
        classificationNameLabel.text = searchItem.placeType.rawValue
    }
    
    
    /// 초기화 작업을 실행합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 그림자 추가
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        // 뷰 외곽선 깎기
        searchContentView.layer.cornerRadius = searchContentView.frame.height * 0.06
        searchContentView.layer.masksToBounds = true
    }
}
