//
//  StoreTypeTableViewCell.swift
//  StoreTypeTableViewCell
//
//  Created by Hyunwoo Jang on 2021/08/09.
//

import UIKit


/// 상점 종류 버튼 셀
/// - Author: 장현우(heoun3089@gmail.com)
class StoreTypeTableViewCell: UITableViewCell {
    
    /// 필터링할 항목
    var storeTypeFilterArray = [Place.PlaceType]()
    
    
    // MARK: 카페 관련 그룹
    /// 카페 아이콘 이미지 컨테이너 뷰
    @IBOutlet weak var cafeImageContainerView: UIView!
    
    /// 카페 레이블
    @IBOutlet weak var cafeLabel: UILabel!
    
    /// 카페 아이콘 이미지뷰
    @IBOutlet weak var cafeImageView: UIImageView!
    
    
    /// 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고, storeTypeFilterArray 배열에 cafe 타입을 추가합니다.
    /// - Parameter sender: 카페 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func caffeButtonTapped(_ sender: Any) {
        cafeImageContainerView.layer.borderColor = cafeImageContainerView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        cafeLabel.textColor = cafeLabel.textColor == .darkGray ? .red : .darkGray
        cafeImageView.tintColor = cafeImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.cafe
        if cafeImageContainerView.layer.borderColor == UIColor.red.cgColor {
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
    /// 식당 아이콘 이미지 컨테이너 뷰
    @IBOutlet weak var restaurantImageContainerView: UIView!
    
    /// 식당 레이블
    @IBOutlet weak var restaurantLabel: UILabel!
    
    /// 식당 아이콘 이미지뷰
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    
    /// 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 restaurant 타입을 추가합니다.
    /// - Parameter sender: 식당 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func restauranteButtonTapped(_ sender: Any) {
        restaurantImageContainerView.layer.borderColor = restaurantImageContainerView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        restaurantLabel.textColor = restaurantLabel.textColor == .darkGray ? .red : .darkGray
        restaurantImageView.tintColor = restaurantImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.restaurant
        if restaurantImageContainerView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    // MARK: 빵집 관련 그룹
    /// 빵집 아이콘 이미지 컨테이너 뷰
    @IBOutlet weak var bakeryImageContainerView: UIView!
    
    /// 빵집 레이블
    @IBOutlet weak var bakeryLabel: UILabel!
    
    /// 빵집 아이콘 이미지뷰
    @IBOutlet weak var bakeryImageView: UIImageView!
    
    
    /// 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 bakery 타입을 추가합니다.
    /// - Parameter sender: 빵집 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func bakeryButtonTapped(_ sender: Any) {
        bakeryImageContainerView.layer.borderColor = bakeryImageContainerView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        bakeryLabel.textColor = bakeryLabel.textColor == .darkGray ? .red : .darkGray
        bakeryImageView.tintColor = bakeryImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.bakery
        if bakeryImageContainerView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    // MARK: 스터디카페 관련 그룹
    /// 스터디카페 아이콘 이미지 컨테이너 뷰
    @IBOutlet weak var studyCafeImageContainerView: UIView!
    
    /// 스터디카페 레이블
    @IBOutlet weak var studyCafeLabel: UILabel!
    
    /// 스터디카페 아이콘 이미지뷰
    @IBOutlet weak var studyCafeImageView: UIImageView!
    
    
    /// 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 studyCafe 타입을 추가합니다.
    /// - Parameter sender: 스터디카페 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func studyCafeButtonTapped(_ sender: Any) {
        studyCafeImageContainerView.layer.borderColor = studyCafeImageContainerView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        studyCafeLabel.textColor = studyCafeLabel.textColor == .darkGray ? .red : .darkGray
        studyCafeImageView.tintColor = studyCafeImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.studyCafe
        if studyCafeImageContainerView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    // MARK: 주점 관련 그룹
    /// 주점 아이콘 이미지 컨테이너 뷰
    @IBOutlet weak var pubImageContainerView: UIView!
    
    /// 주점 레이블
    @IBOutlet weak var pubLabel: UILabel!
    
    /// 주점 아이콘 이미지뷰
    @IBOutlet weak var pubImageView: UIImageView!
    
    
    /// 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 pub 타입을 추가합니다.
    /// - Parameter sender: 주점 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func pubButtonTapped(_ sender: Any) {
        pubImageContainerView.layer.borderColor = pubImageContainerView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        pubLabel.textColor = pubLabel.textColor == .darkGray ? .red : .darkGray
        pubImageView.tintColor = pubImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.pub
        if pubImageContainerView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    // MARK: 디저트 가게 관련 그룹
    /// 디저트 가게 이미지 컨테이너 뷰
    @IBOutlet weak var desertImageContainerView: UIView!
    
    /// 디저트 가게 레이블
    @IBOutlet weak var desertLabel: UILabel!
    
    /// 디저트 가게 아이콘 이미지뷰
    @IBOutlet weak var desertImageView: UIImageView!
    
    
    /// 뷰의 외곽선, 레이블, 이미지뷰의 색상이 변경되고 storeTypeFilterArray 배열에 desert 타입을 추가합니다.
    /// - Parameter sender: 디저트 가게 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func desertButtonTapped(_ sender: Any) {
        desertImageContainerView.layer.borderColor = desertImageContainerView.layer.borderColor == UIColor.darkGray.cgColor ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        desertLabel.textColor = desertLabel.textColor == .darkGray ? .red : .darkGray
        desertImageView.tintColor = desertImageView.tintColor == .darkGray ? .red : .darkGray
        
        let target = Place.PlaceType.dessert
        if desertImageContainerView.layer.borderColor == UIColor.red.cgColor {
            storeTypeFilterArray.append(target)
        } else {
            let index = storeTypeFilterArray.firstIndex { $0 == target }
            
            if let index = index {
                storeTypeFilterArray.remove(at: index)
            }
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 뷰의 백그라운드 색상과 외곽선 스타일, 두께, 색상을 설정합니다.
    /// 이미지뷰의 tintColor를 darkGray로 설정합니다.
    /// 레이블의 textColor를 darkGray로 설정합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        [cafeImageContainerView,
         restaurantImageContainerView,
         bakeryImageContainerView,
         studyCafeImageContainerView,
         pubImageContainerView,
         desertImageContainerView].forEach { view in
            view?.backgroundColor = .white
            view?.configureStyle(with: [.bigRoundedRect])
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        [cafeImageView, restaurantImageView, bakeryImageView, studyCafeImageView, pubImageView, desertImageView].forEach {
            $0?.tintColor = .darkGray
        }
        
        [cafeLabel, restaurantLabel, bakeryLabel, studyCafeLabel, pubLabel, desertLabel].forEach {
            $0?.textColor = .darkGray
        }
    }
}
