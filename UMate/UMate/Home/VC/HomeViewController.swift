//
//  HomeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit

/// 홈화면
/// Author: 황신택(sinadsl1457@gmail.com)
class HomeViewController: UIViewController {
    /// 홈화면 콜렉션뷰
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    /// 홈화면 데이타 리스트
  var list = getHomeDataList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
}



extension HomeViewController: UICollectionViewDataSource {
    /// 섹션에 아이템을 개수를 지정합니다.
    /// - Parameters:
    ///   - collectionView: 해당 요청을 보낸 콜렉션뷰
    ///   - section: 섹션의 위치
    /// - Returns: 색션에 표시할 아이템 개수를 리턴합니다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /// 셀에 데이타를 지정합니다.
    /// - Parameters:
    ///   - collectionView: 관련 요청을 보낸 콜렉션뷰
    ///   - indexPath: 셀의 IndexPath
    /// - Returns: 데이타가 표시된 셀이 리턴됩니다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = list[indexPath.item]
        
        switch type {
        case .main(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
            cell.title.text = model.cellTitle
            cell.favoriteImageView.image = UIImage(named: model.backgoundImageName)
            return cell
            
            
        case .promotion(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCollectionViewCell", for: indexPath) as! CompaniesInfoCollectionViewCell
            
            cell.companyCategoryLabel.text = model.cellTitle
            cell.detailLabel.text = model.detailTitle
            cell.companyCategoryImageView.image = UIImage(named: model.backgoundImageName)
            
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
    ///   - collectionView: 레이아웃을 표시하는 콜렉션 뷰
    ///   - collectionViewLayout: 정보를 요청한 layout 객체
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 지정된 아이템의 넓이 높이를 리턴합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let type = list[indexPath.item]
        
        switch type {
        case .main(_):
            if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
                let width = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing * 3 + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 4
                
                return CGSize(width: Int(width), height: Int(width))
            }
            
            var width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2
            
            var height = width * 1.0
            
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
