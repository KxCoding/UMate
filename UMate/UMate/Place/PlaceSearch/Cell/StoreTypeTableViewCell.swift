//
//  StoreTypeTableViewCell.swift
//  StoreTypeTableViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit

class StoreTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var cafeView: UIView!
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var bakeryView: UIView!
    @IBOutlet weak var studyCafeView: UIView!
    @IBOutlet weak var pubView: UIView!
    @IBOutlet weak var desertView: UIView!
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        [cafeView, restaurantView, bakeryView, studyCafeView, pubView, desertView].forEach { view in
            view?.backgroundColor = .white
            view?.configureStyle(with: [.squircleBig])
            view?.layer.borderWidth = 2
            view?.layer.borderColor = UIColor.black.cgColor
        }
    }
}
