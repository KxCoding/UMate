//
//  HomeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit

/// 홈화면을 담당하는 클래스입니다.
/// Author: 황신택
class HomeViewController: UIViewController {
    /// 홈화면 콜렉션뷰
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    /// 홈화면 설계리스트 속성
  var list = getHomeDataList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
}



extension HomeViewController: UICollectionViewDataSource {
    /// 섹션에 아이템을 개수를 지정하는 메소드
    /// - Parameters:
    ///   - collectionView: 해당 요청을 보낸 UICollectionView
    ///   - section: 섹션의 위치
    /// - Returns: 아이템 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /// 셀에 데이타를 지정하는 메소드
    /// - Parameters:
    ///   - collectionView: 관련 요청을 보낸 UICollectionView
    ///   - indexPath: 셀의 IndexPath
    /// - Returns: 안성된 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = list[indexPath.item]
        
        switch type {
        case .main(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
            cell.title.text = model.cellTitle
            cell.favoriteImageVIew.image = UIImage(named: model.backgoundImageName)
            return cell
            
            
        case .promotion(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCollectionViewCell", for: indexPath) as! PromotionCollectionViewCell
            
            cell.promotionLabel.text = model.cellTitle
            cell.detailLabel.text = model.detailTitle
            cell.promotionImageView.image = UIImage(named: model.backgoundImageName)
            
            return cell
        case .contest(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContestCollectionViewCell", for: indexPath) as! ContestCollectionViewCell
            
            cell.titleLabel.text = model.cellTitle
            cell.detailLabel.text = model.detailTitle
            cell.contestImageView.image = UIImage(named: model.backgoundImageName)
            
            return cell
        }
        
    }
    
}



extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    /// 델리게이트에게 지정된 아이템의 셀의 사이즈를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션 뷰
    ///   - collectionViewLayout: 정보를 요청하는 layout 객체
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let type = list[indexPath.item]
        
        switch type {
        case .main(_):
            // portrait 모드일 경우에 셀을 4등분으로 만듭니다.
            if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
                let width = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing * 3 + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 4
                
                return CGSize(width: Int(width), height: Int(width))
            }
            
            var width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2
            
            var height = width * 1.0
            
            // compact 모드일 경우에 3등분으로 셀을 만듭니다.
            if view.frame.width > view.frame.height {
                height = width * 0.3
                width = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing * 2 + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 3
                
            }
            
            return CGSize(width: Int(width), height: Int(height))
            
        case .promotion(_):
            let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) * 1.05
            
            let height = width * 0.3
            
            return CGSize(width: Int(width), height: Int(height))
            
        case .contest(_):
            let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) * 1.05
             
            let height = width * 0.3
            
            return CGSize(width: Int(width), height: Int(height))
        }
        
    }
}
