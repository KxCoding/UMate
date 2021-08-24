//
//  PlaceTypeSelectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import UIKit

extension Notification.Name {
    
    /// 선택된 가게 종류가 바뀌었음을 알리는 notification
    static let selectedPlaceTypeHasBeenChanged = Notification.Name(rawValue: "selectedPlaceTypeHasBeenChanged")
}




// MARK: TableView Cell

class PlaceTypeSelectionTableViewCell: UITableViewCell {
    
    /// 가게 종류를 나타내는 컬렉션 뷰
    @IBOutlet weak var placeTypeCollectionView: UICollectionView!
    
    /// 전체 타입
    let types: [Place.PlaceType] = [.cafe, .restaurant, .bakery, .dessert, .pub, .studyCafe]
    
    /// 셀이 로드되었을 떄 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeTypeCollectionView.dataSource = self
        placeTypeCollectionView.delegate = self
    }
    
    
    /// 컬렉션 뷰의 첫번째 셀 (전체) 선택
    func selectAllType() {
        let selectedIndex = IndexPath(item: 0, section: 0)
        placeTypeCollectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .left)
    }
    
}




// MARK: CollectionView Delegation

extension PlaceTypeSelectionTableViewCell: UICollectionViewDataSource {
    
    /// 컬렉션 뷰의 각 섹션에서 표시할 항목의 수를 제공하는 메소드
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - section: 섹션
    /// - Returns: 섹션에서 표시할 항목의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return types.count + 1
    }
    
    
    /// 각 항목이 표시할 셀을 제공하는 메소드
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 항목의 index path
    /// - Returns: 각 항목이 표시할 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceTypeCollectionViewCell", for: indexPath) as! PlaceTypeCollectionViewCell
        
        if indexPath.item == 0 {
            /// 첫번째 - 전체
            cell.configure(type: nil)
        } else if indexPath.item <= types.count {
            /// 두 번째부터 각 가게 타입
            cell.configure(type: types[indexPath.item - 1])
        }
        
        return cell
    }
}




extension PlaceTypeSelectionTableViewCell: UICollectionViewDelegate {
    
    /// collection view의 아이템이 선택되었을 떄 호출되어 구현된 작업을 실행합니다.
    /// - Parameters:
    ///   - collectionView: 아이템이 포함된 collection view
    ///   - indexPath: 아이템의 indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PlaceTypeCollectionViewCell {
            
            cell.didSelect()
            
            /// 특정 타입이 선택되었음을 알리는 notification 전송
            let selectedType: Place.PlaceType?
            
            if indexPath.item == 0 {
                selectedType = nil
            } else {
                let index = indexPath.item - 1
                selectedType = types[index]
            }
            
            NotificationCenter.default.post(name: .selectedPlaceTypeHasBeenChanged,
                                            object: nil,
                                            userInfo: ["selectedPlaceType": selectedType])
        }
    }
    
    
    /// collection view의 아이템이 선택 해제되었을 떄 호출되어 구현된 작업을 실행합니다.
    /// - Parameters:
    ///   - collectionView: 아이템이 포함된 collection view
    ///   - indexPath: 아이템의 indexPath
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PlaceTypeCollectionViewCell {
            cell.didDeselect()
        }
    }
    
}




// MARK: CollectionView Cell

class PlaceTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var dimmingView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    
    /// 셀을 데이터를 초기화하는 메소드
    /// - Parameter type: 장소 타입
    func configure(type: Place.PlaceType?) {
        if let type = type {
            typeImageView.image = type.photoImage
            placeTypeLabel.text = type.rawValue
        } else {
            typeImageView.image = UIImage(named: "dummy-image-landscape")
            placeTypeLabel.text = "전체"
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
    
}

