//
//  PlaceTypeCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/26.
//

import UIKit


/// 필터링할 가게 종류를 표시하는 컬렉션 뷰 셀 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
class PlaceTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    /// 이미지를 감싸는 컨테이너 뷰
    @IBOutlet weak var imageContainerView: UIView!
    
    /// 셀의 선택 상태에 따라 투명도를 조절할 dimming view
    @IBOutlet weak var dimmingView: UIView!
    
    /// 가게 타입을 나타내는 이미지를 표시할 이미지 뷰
    @IBOutlet weak var typeImageView: UIImageView!
    
    /// 타입 이름을 표시하는 레이블
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    
    // MARK: Properties
    
    /// 셀이 표시할 가게 타입
    var displayingType: PlaceTypePattern = .all
    
    
    // MARK: Methods
    
    /// 셀을 데이터를 초기화하는 메소드
    /// - Parameter type: 장소 타입
    func configure(type: PlaceTypePattern, isSelected: Bool, collectionView: UICollectionView, indexPath: IndexPath, selectedType: PlaceTypePattern) {
        
        // 셀이 표시할 타입에 파라미터로 전달된 타입을 저장
        displayingType = type
        
        // 표시하는 타입에 따라 표시하는 데이터 설정
        if type == .all {
            typeImageView.image = UIImage(named: "dummy-image-landscape")
            placeTypeLabel.text = "전체"
        } else {
            guard let selected = type.matchedPlaceType else { return }
            typeImageView.image = selected.photoImage
            placeTypeLabel.text = selected.description
        }
        
        // 선택 상태에 따라 UI 업데이트 메소드 호출
        if isSelected {
            didSelect()
        } else {
            didDeselect()
        }
    }
    
    
    /// 선택시 UI 업데이트
    func didSelect() {
        dimmingView.alpha = 0.6
        placeTypeLabel.textColor = .systemRed
    }
    
    
    /// 선택 상태가 해제되었을 때 UI 업데이트
    func didDeselect() {
        dimmingView.alpha = 0
        placeTypeLabel.textColor = .label
    }
    
    
    /// 선택 상태에 따라 업데이트
    /// - Parameter state: 셀의 상태
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        if state.isSelected {
            didSelect()
        } else {
            didDeselect()
        }
    }
    
    
    /// 재사용 되기 전에 실행할 코드
    override func prepareForReuse() {
        super.prepareForReuse()
        didDeselect()
    }
    
    
    // MARK: Cell Lifecycle method
    
    /// 셀이 로드되었을 때 셀 상태 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 셀 UI 설정
        imageContainerView.configureStyle(with: [.pillShape])
        typeImageView.contentMode = .scaleAspectFill
        dimmingView.backgroundColor = .systemRed
        dimmingView.alpha = 0
    }
    
}
