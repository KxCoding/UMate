//
//  PlaceTypeCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/26.
//

import UIKit

// MARK: CollectionView Cell

class PlaceTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var dimmingView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    var placeHandler: ((PlaceTypePattern) -> ())?
    
    /// 셀이 표시할 가게 타입
    var displayingType: PlaceTypePattern = .all
    
    /// 셀을 데이터를 초기화하는 메소드
    /// - Parameter type: 장소 타입
    func configure(type: PlaceTypePattern, isSelected: Bool, collectionView: UICollectionView, indexPath: IndexPath, selectedType: PlaceTypePattern) {
        /// 셀이 표시할 타입에 파라미터로 전달된 타입을 저장
        displayingType = type
        
        /// 표시하는 타입에 따라 표시하는 데이터 설정
        if type == .all {
            typeImageView.image = UIImage(named: "dummy-image-landscape")
            placeTypeLabel.text = "전체"
        } else {
            guard let selected = type.matchedPlaceType else { return }
            typeImageView.image = selected.photoImage
            placeTypeLabel.text = selected.description
        }
        
        /// 선택 상태에 따라 UI 업데이트 메소드 호출
        if isSelected {
            didSelect()
        } else {
            didDeselect()
        }
    }
    
    
    /// 셀이 로드되었을 때 셀 상태 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageContainerView.configureStyle(with: [.pillShape])
        typeImageView.contentMode = .scaleAspectFill
        dimmingView.backgroundColor = .systemRed
        dimmingView.alpha = 0
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
    
}
