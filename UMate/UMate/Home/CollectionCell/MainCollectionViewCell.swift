//
//  MainCollectionViewCell.swift
//  MainCollectionViewCell
//
//  Created by 황신택 on 2021/09/11.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var favoriteImageVIew: UIImageView!
    
    /// 메인화면  콜렉션 뷰 둥글게 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
        favoriteImageVIew.contentMode = .scaleAspectFit
    }
    
}
