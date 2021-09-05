//
//  PlaceSearchCollectionViewCell.swift
//  PlaceSearchCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/08/01.
//

import UIKit

class PlaceSearchCollectionViewCell: UICollectionViewCell {
    /// 검색한 화면 UI와 관련된 변수들
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var regionNameLabel: UILabel!
    @IBOutlet weak var classificationNameLabel: UILabel!
    @IBOutlet weak var searchContentView: UIView!
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        /// 그림자 추가
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        /// 뷰 외곽선 깎기
        searchContentView.layer.cornerRadius = searchContentView.frame.height * 0.06
        searchContentView.layer.masksToBounds = true
    }
    
    
    /// 컬렉션뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter searchItem: 표시할 내용을 가진 구조체
    func configure(with searchItem: Place, image: UIImage?) {
        imageView.image = image
        placeTitle.text = searchItem.name
        regionNameLabel.text = searchItem.district
        classificationNameLabel.text = searchItem.placeType.rawValue
    }
}
