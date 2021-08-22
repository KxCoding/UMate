//
//  StoreTypeTableViewCell.swift
//  StoreTypeTableViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit

class StoreTypeTableViewCell: UITableViewCell {
    /// 필터링할 항목을 담을 배열
    var storeTypeFilterArray = [SearchPlaceItem.PlaceType]()
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        /// 각 뷰의 background 색상과 외곽선 스타일, 두께, 색상을 설정
        [cafeView, restaurantView, bakeryView, studyCafeView, pubView, desertView].forEach { view in
            view?.backgroundColor = .white
            view?.configureStyle(with: [.squircleBig])
            view?.layer.borderWidth = 2
            view?.layer.borderColor = UIColor.black.cgColor
        }
        
        /// 각 레이블의 색상을 darkGray로 설정
        [cafeLabel, restaurantLabel, bakeryLabel, studyCafeLabel, pubLabel, desertLabel].forEach {
            $0?.textColor = .darkGray
        }
    }
    
    // MARK: 카페 관련 그룹
    @IBOutlet weak var cafeView: UIView!
    @IBOutlet weak var cafeLabel: UILabel!
    @IBOutlet weak var cafeImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 cafe 타입을 추가합니다.
    /// - Parameter sender: 카페 버튼
    @IBAction func caffeButtonTapped(_ sender: Any) {
        cafeView.layer.borderColor = cafeView.layer.borderColor == UIColor.black.cgColor ? UIColor.red.cgColor : UIColor.black.cgColor
        cafeLabel.textColor = cafeLabel.textColor == .darkGray ? .red : .darkGray
        cafeImageView.tintColor = cafeImageView.tintColor == .black ? .red : .black
        
        let target = SearchPlaceItem.PlaceType.cafe
        if cafeView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
        #if DEBUG
        print(storeTypeFilterArray)
        #endif
    }
    
    
    // MARK: 식당 관련 그룹
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 restaurant 타입을 추가합니다.
    /// - Parameter sender: 식당 버튼
    @IBAction func restauranteButtonTapped(_ sender: Any) {
        restaurantView.layer.borderColor = restaurantView.layer.borderColor == UIColor.black.cgColor ? UIColor.red.cgColor : UIColor.black.cgColor
        restaurantLabel.textColor = restaurantLabel.textColor == .darkGray ? .red : .darkGray
        restaurantImageView.tintColor = restaurantImageView.tintColor == .black ? .red : .black
        
        let target = SearchPlaceItem.PlaceType.restaurant
        if restaurantView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    // MARK: 빵집 관련 그룹
    @IBOutlet weak var bakeryView: UIView!
    @IBOutlet weak var bakeryLabel: UILabel!
    @IBOutlet weak var bakeryImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 bakery 타입을 추가합니다.
    /// - Parameter sender: 빵집 버튼
    @IBAction func bakeryButtonTapped(_ sender: Any) {
        bakeryView.layer.borderColor = bakeryView.layer.borderColor == UIColor.black.cgColor ? UIColor.red.cgColor : UIColor.black.cgColor
        bakeryLabel.textColor = bakeryLabel.textColor == .darkGray ? .red : .darkGray
        bakeryImageView.tintColor = bakeryImageView.tintColor == .black ? .red : .black
        
        let target = SearchPlaceItem.PlaceType.bakery
        if bakeryView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    // MARK: 스터디카페 관련 그룹
    @IBOutlet weak var studyCafeView: UIView!
    @IBOutlet weak var studyCafeLabel: UILabel!
    @IBOutlet weak var studyCafeImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 studyCafe 타입을 추가합니다.
    /// - Parameter sender: 스터디카페 버튼
    @IBAction func studyCafeButtonTapped(_ sender: Any) {
        studyCafeView.layer.borderColor = studyCafeView.layer.borderColor == UIColor.black.cgColor ? UIColor.red.cgColor : UIColor.black.cgColor
        studyCafeLabel.textColor = studyCafeLabel.textColor == .darkGray ? .red : .darkGray
        studyCafeImageView.tintColor = studyCafeImageView.tintColor == .black ? .red : .black
        
        let target = SearchPlaceItem.PlaceType.studyCafe
        if studyCafeView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    // MARK: 주점 관련 그룹
    @IBOutlet weak var pubView: UIView!
    @IBOutlet weak var pubLabel: UILabel!
    @IBOutlet weak var pubImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 pub 타입을 추가합니다.
    /// - Parameter sender: 주점 버튼
    @IBAction func pubButtonTapped(_ sender: Any) {
        pubView.layer.borderColor = pubView.layer.borderColor == UIColor.black.cgColor ? UIColor.red.cgColor : UIColor.black.cgColor
        pubLabel.textColor = pubLabel.textColor == .darkGray ? .red : .darkGray
        pubImageView.tintColor = pubImageView.tintColor == .black ? .red : .black
        
        let target = SearchPlaceItem.PlaceType.pub
        if pubView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    // MARK: 디저트 가게 관련 그룹
    @IBOutlet weak var desertView: UIView!
    @IBOutlet weak var desertLabel: UILabel!
    @IBOutlet weak var desertImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 desert 타입을 추가합니다.
    /// - Parameter sender: 디저트 가게 버튼
    @IBAction func desertButtonTapped(_ sender: Any) {
        desertView.layer.borderColor = desertView.layer.borderColor == UIColor.black.cgColor ? UIColor.red.cgColor : UIColor.black.cgColor
        desertLabel.textColor = desertLabel.textColor == .darkGray ? .red : .darkGray
        desertImageView.tintColor = desertImageView.tintColor == .black ? .red : .black
        
        let target = SearchPlaceItem.PlaceType.desert
        if desertView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
}
