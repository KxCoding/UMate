//
//  SimplePlaceTypeCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/10/20.
//

import UIKit

class SimplePlaceTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    /// 타입 아이콘 이미지
    @IBOutlet weak var typeIconImageView: UIImageView!
    
    /// 타입 이름 레이블
    @IBOutlet weak var typeNameLabel: UILabel!
    
    
    // MARK: Properties
    
    /// 셀이 표시할 상점 타입
    ///
    /// 화면에 처음 진입하면 전체 타입의 북마크 데이터를 표시합니다.
    var displayingType: PlaceTypePattern = .all
    
    
    // MARK: Methods
    
    /// 각 뷰에서 표시하는 데이터를 초기화하고 선택 상태에 따라 UI를 업데이트합니다.
    /// - Parameters:
    ///   - type: 타입
    ///   - isSelected: 선택 상태
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func configure(type: PlaceTypePattern, isSelected: Bool) {
        
        displayingType = type
        
        if type == .all {
            typeIconImageView.image = UIImage(systemName: "a.circle")
            typeNameLabel.text = "전체"
        } else {
            guard let selected = type.matchedPlaceType else { return }
            typeIconImageView.image = selected.iconImage
            typeNameLabel.text = selected.description
        }
        
        if isSelected {
            didSelect()
        } else {
            didDeselect()
        }
    }
    
    
    /// 셀 선택 UI를 업데이트합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func didSelect() {
        self.layer.borderColor = UIColor.systemRed.cgColor
        typeIconImageView.tintColor = .systemRed
        typeNameLabel.textColor = .systemRed
    }
    
    
    /// 선택 상태가 해제되었을 때 UI를 업데이트합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func didDeselect() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        typeIconImageView.tintColor = .lightGray
        typeNameLabel.textColor = .lightGray
    }
    
    
    /// 셀의 선택 상태에 따라 UI를 업데이트 합니다.
    /// - Parameter state: 셀의 상태
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        if state.isSelected {
            didSelect()
        } else {
            didDeselect()
        }
    }
    
    
    /// 셀이 재사용 되기 전에 선택 해제 상태의 UI로 업데이트 합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func prepareForReuse() {
        super.prepareForReuse()
        didDeselect()
    }
    
    
    // MARK: Cell Lifecycle method
    
    /// 셀이 로드되면 UI를 초기화합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureStyle(with: [.smallRoundedRect, .lightBorder])
        typeIconImageView.tintColor = .lightGray
        typeNameLabel.textColor = .lightGray
    }
}
