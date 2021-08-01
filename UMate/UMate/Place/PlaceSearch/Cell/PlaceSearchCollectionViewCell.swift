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
    
    func configure(with searchItem: SearchPlaceItem) {
        imageView.image = searchItem.image
        placeTitle.text = searchItem.placeTitle
        regionNameLabel.text = searchItem.regionName
        classificationNameLabel.text = searchItem.classificationName
    }
    
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 5
    }
    
}
