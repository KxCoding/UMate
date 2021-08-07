//
//  PlaceSearchCollectionViewCell.swift
//  PlaceSearchCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/08/01.
//

import UIKit

class PlaceSearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var regionNameLabel: UILabel!
    @IBOutlet weak var classificationNameLabel: UILabel!
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 10.0
    }
    
    
    /// 컬렉션뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter searchItem: 표시할 내용을 가진 구조체
    func configure(with searchItem: SearchPlaceItem) {
        imageView.image = searchItem.image
        placeTitle.text = searchItem.placeTitle
        regionNameLabel.text = searchItem.regionName
        classificationNameLabel.text = searchItem.classificationName
    }
}
