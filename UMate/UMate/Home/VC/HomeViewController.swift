//
//  HomeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    /// 홈화면 설계리스트 메소드
  var list = getHomeDataList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
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

extension HomeViewController: UICollectionViewDelegate {
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
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
