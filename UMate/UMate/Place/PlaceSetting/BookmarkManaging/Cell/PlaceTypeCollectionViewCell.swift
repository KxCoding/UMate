//
//  PlaceTypeCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/26.
//

import UIKit


/// 상점 타입 셀
/// - Author: 박혜정(mailmelater11@gmail.com)
class PlaceTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    /// 이미지 컨테이너
    @IBOutlet weak var imageContainerView: UIView!
    
    /// 셀의 선택 상태에 따라 투명도가 조절되는 dimming view
    @IBOutlet weak var dimmingView: UIView!
    
    /// 타입 이미지 뷰
    @IBOutlet weak var typeImageView: UIImageView!
    
    /// 타입 이름 레이블
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    
    // MARK: Properties
    
    /// 셀이 표시할 가게 타입
    var displayingType: PlaceTypePattern = .all
    
    
    // MARK: Methods
    
    /// 셀을 데이터를 초기화하는 메소드
    /// content와 UI를 업데이트하고
    /// - Parameter type: 장소 타입
    func configure(type: PlaceTypePattern, isSelected: Bool, collectionView: UICollectionView, indexPath: IndexPath, selectedType: PlaceTypePattern) {
        
        displayingType = type
        
        if type == .all {
            #warning("전체를 나타내내는 이미지로 변경해야 합니다")
            typeImageView.image = UIImage(named: "dummy-image-landscape")
            placeTypeLabel.text = "전체"
        } else {
            guard let selected = type.matchedPlaceType else { return }
            typeImageView.image = selected.photoImage
            placeTypeLabel.text = selected.description
        }
        
        if isSelected {
            didSelect()
        } else {
            didDeselect()
        }
    }
    
    
    /// 셀 선택 UI를 업데이트합니다.
    func didSelect() {
        dimmingView.alpha = 0.6
        placeTypeLabel.textColor = .systemRed
    }
    
    
    /// 선택 상태가 해제되었을 때 UI를 업데이트합니다.
    func didDeselect() {
        dimmingView.alpha = 0
        placeTypeLabel.textColor = .label
    }
    
    
    /// 셀의 상태에 따라 설정을 업데이트 합니다.
    ///
    /// 셀 선택 상태에 따라 UI를 업데이트합니다.
    /// - Parameter state: 셀의 상태
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        if state.isSelected {
            didSelect()
        } else {
            didDeselect()
        }
    }
    
    
    /// 셀이 재사용 되기 전에 선택 해제 상태의 UI로 업데이트 합니다.
    override func prepareForReuse() {
        super.prepareForReuse()
        didDeselect()
    }
    
    
    // MARK: Cell Lifecycle method
    
    /// 셀이 로드되었을 때 UI를 초기화합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 셀 UI 설정
        imageContainerView.configureStyle(with: [.pillShape])
        typeImageView.contentMode = .scaleAspectFill
        dimmingView.backgroundColor = .systemRed
        dimmingView.alpha = 0
    }
    
}
