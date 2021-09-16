//
//  StoreTypeTableViewCell.swift
//  StoreTypeTableViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit


/// 가게종류 관련 버튼을 표시할 테이블뷰셀 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class StoreTypeTableViewCell: UITableViewCell {
    /// 필터링할 항목을 담을 배열
    /// - Author: 장현우(heoun3089@gmail.com)
    var storeTypeFilterArray = [Place.PlaceType]()
    
    
    // MARK: 카페 관련 그룹
    /// 카페 아이콘 이미지를 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var cafeView: UIView!
    
    /// 카페 글자를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var cafeLabel: UILabel!
    
    /// 카페 아이콘을 표시할 이미지뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var cafeImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 cafe 타입을 추가합니다.
    /// - Parameter sender: 카페 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func caffeButtonTapped(_ sender: Any) {
        cafeView.layer.borderColor = cafeView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        cafeLabel.textColor = cafeLabel.textColor == .darkGray ? .red : .darkGray
        cafeImageView.tintColor = cafeImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.cafe
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
    /// 식당 아이콘 이미지를 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var restaurantView: UIView!
    
    /// 식당 글자를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var restaurantLabel: UILabel!
    
    /// 식당 아이콘을 표시할 이미지뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 restaurant 타입을 추가합니다.
    /// - Parameter sender: 식당 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func restauranteButtonTapped(_ sender: Any) {
        restaurantView.layer.borderColor = restaurantView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        restaurantLabel.textColor = restaurantLabel.textColor == .darkGray ? .red : .darkGray
        restaurantImageView.tintColor = restaurantImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.restaurant
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
    /// 빵집 아이콘 이미지를 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var bakeryView: UIView!
    
    /// 빵집 글자를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var bakeryLabel: UILabel!
    
    /// 빵집 아이콘을 표시할 이미지뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var bakeryImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 bakery 타입을 추가합니다.
    /// - Parameter sender: 빵집 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func bakeryButtonTapped(_ sender: Any) {
        bakeryView.layer.borderColor = bakeryView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        bakeryLabel.textColor = bakeryLabel.textColor == .darkGray ? .red : .darkGray
        bakeryImageView.tintColor = bakeryImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.bakery
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
    /// 스터디카페 아이콘 이미지를 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var studyCafeView: UIView!
    
    /// 식당 글자를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var studyCafeLabel: UILabel!
    
    /// 식당 아이콘을 표시할 이미지뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var studyCafeImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 studyCafe 타입을 추가합니다.
    /// - Parameter sender: 스터디카페 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func studyCafeButtonTapped(_ sender: Any) {
        studyCafeView.layer.borderColor = studyCafeView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        studyCafeLabel.textColor = studyCafeLabel.textColor == .darkGray ? .red : .darkGray
        studyCafeImageView.tintColor = studyCafeImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.studyCafe
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
    /// 주점 아이콘 이미지를 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var pubView: UIView!
    
    /// 주점 글자를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var pubLabel: UILabel!
    
    /// 주점 아이콘을 표시할 이미지뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var pubImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 pub 타입을 추가합니다.
    /// - Parameter sender: 주점 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func pubButtonTapped(_ sender: Any) {
        pubView.layer.borderColor = pubView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        pubLabel.textColor = pubLabel.textColor == .darkGray ? .red : .darkGray
        pubImageView.tintColor = pubImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.pub
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
    /// 디저트 가게 이미지를 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var desertView: UIView!
    
    /// 디저트 가게 글자를 표시할 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var desertLabel: UILabel!
    
    /// 디저트 가게 아이콘을 표시할 이미지뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var desertImageView: UIImageView!
    
    
    /// 버튼을 누르면 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 desert 타입을 추가합니다.
    /// - Parameter sender: 디저트 가게 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func desertButtonTapped(_ sender: Any) {
        desertView.layer.borderColor = desertView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        desertLabel.textColor = desertLabel.textColor == .darkGray ? .red : .darkGray
        desertImageView.tintColor = desertImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.dessert
        if desertView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 각 뷰의 background 색상과 외곽선 스타일, 두께, 색상을 설정
        [cafeView, restaurantView, bakeryView, studyCafeView, pubView, desertView].forEach { view in
            view?.backgroundColor = .white
            view?.configureStyle(with: [.bigRoundedRect])
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        // 각 이미지뷰의 색상을 darkGray로 설정
        [cafeImageView, restaurantImageView, bakeryImageView, studyCafeImageView, pubImageView, desertImageView].forEach {
            $0?.tintColor = .darkGray
        }
        
        // 각 레이블의 색상을 darkGray로 설정
        [cafeLabel, restaurantLabel, bakeryLabel, studyCafeLabel, pubLabel, desertLabel].forEach {
            $0?.textColor = .darkGray
        }
    }
}
