//
//  NearbyPlaceCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import UIKit


/// 주변 상가가 리스팅된 컬렉션 뷰 셀 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
class NearbyPlaceCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    /// 가게 이름을 표시하는 레이블
    @IBOutlet weak var placeNameLabel: UILabel!
    
    /// 인근 지역을 표시하는 레이블
    @IBOutlet weak var districtLabel: UILabel!
    
    /// 첫번째 키워드를 표시하는 레이블
    @IBOutlet weak var keywordLabel1: UILabel!
    
    /// 첫번째 키워드 레이블 컨테이너
    @IBOutlet weak var keywordContainer1: UIView!
    
    /// 두번째 키워드를 표시하는 레이블
    @IBOutlet weak var keywordLabel2: UILabel!
    
    /// 두번째 키워드 레이블 컨테이너
    @IBOutlet weak var keywordContainer2: UIView!
    
    /// 가게 사진(thumnail)을 표시할 이미지 뷰
    @IBOutlet weak var placeImageView: UIImageView!
    
    /// 메소드 사용을 위한 데이터 매니저 객체
    let manager = DataManager.shared
    
    /// 셀에서 표시하는 place 객체
    var target: Place!
    
    
    // MARK: Methods
    
    /// 각 뷰들이 표시하는 content 초기화
    /// - Parameter content: 뷰에 표시할 내용을 담은 Place 객체
    func configure(with content: Place) {
        target = content
        
        placeNameLabel.text = target.name
        districtLabel.text = target.district
        keywordLabel1.text = target.keywords.first
        
        if target.keywords.count > 1 {
            // 키워드가 한 개 이상이면 두번째 까지 표시
            keywordLabel2.text = target.keywords[1]
        } else {
            // 그렇지 않으면 hidden 처리
            keywordContainer2.isHidden = true
        }
        
        // 응답에 따라 이미지 뷰 업데이트
        manager.download(.thumbnail, andUpdate: placeImageView, with: target.thumbnailUrl)
        
    }
    
    
    /// 셀 내부 UI 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 셀 UI 스타일 적용
        self.configureStyle(with: [.bigRoundedRect, .lightBorder, .lightShadow])
        
        // 키워드 컨테이너 UI 스타일 적용
        [keywordContainer1, keywordContainer2].forEach({ $0?.configureStyle(with: [.smallRoundedRect])})
    }
    
}

