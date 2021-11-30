//
//  PlaceSearchCollectionViewCell.swift
//  PlaceSearchCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/08/01.
//

import UIKit


/// 상점 검색 결과 셀
/// - Author: 장현우(heoun3089@gmail.com)
class PlaceSearchCollectionViewCell: UICollectionViewCell {
    
    /// 상점 이미지뷰
    @IBOutlet weak var imageView: UIImageView!
    
    /// 상점 이름 레이블
    @IBOutlet weak var placeTitleLabel: UILabel!
    
    /// 상점이 있는 지역명 레이블
    @IBOutlet weak var regionNameLabel: UILabel!
    
    /// 상점 종류 레이블
    @IBOutlet weak var classificationNameLabel: UILabel!
    
    /// 검색 화면 UI 컨테이너 뷰
    @IBOutlet weak var searchContentView: UIView!
    
    
    /// 컬렉션뷰셀에 표시할 내용을 설정합니다.
    ///
    /// 상점 이름과 상점이 있는 지역, 상점 종류를 표시합니다.
    /// 상점 이미지를 표시합니다.
    /// - Parameter searchItem: 검색 결과 객체
    /// - Author: 장현우(heoun3089@gmail.com)
    func configure(with searchItem: Place) {
        imageView.image = PlaceDataManager.shared.getImage(with: searchItem.thumbnailUrl)
        
        placeTitleLabel.text = searchItem.name
        regionNameLabel.text = searchItem.district
        
        classificationNameLabel.text = searchItem.type
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 뷰의 그림자를 추가하고 검색 화면 UI 컨테이너 뷰의 외곽선을 둥글게 깎습니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        searchContentView.layer.cornerRadius = searchContentView.frame.height * 0.06
        searchContentView.layer.masksToBounds = true
    }
}
