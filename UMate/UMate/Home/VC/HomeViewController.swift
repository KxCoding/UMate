//
//  HomeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


/// 홈 화면
/// Author: 황신택, 안상희
class HomeViewController: UIViewController {
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    /// 홈화면 설계리스트 메소드
  var list = getToHomeDataList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    /// 학교 상세 정보 화면으로 이동하기 전에 학교 고유 id와 navigationTitle을 전달합니다.
    /// - Parameters:
    ///   - segue: 뷰컨트롤러에 포함된 segue에 대한 정보를 갖는 객체
    ///   - sender: MainCollectionViewCell
    /// - Author: 안상희
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell {
            if let indexPath = listCollectionView.indexPath(for: cell) {
                if let vc = segue.destination as? SchoolDetailViewController {
                    vc.schoolId = 114
                    
                    if indexPath.item == 0 {
                        vc.navigationTitle = "학교 홈페이지"
                    } else if indexPath.item == 1 {
                        vc.navigationTitle = "포탈"
                    } else if indexPath.item == 2 {
                        vc.navigationTitle = "도서관"
                    } else {
                        vc.navigationTitle = "캠퍼스맵"
                    }
                }
            }
        }
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
            let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right))
            
            let height = width * 0.3
            
            return CGSize(width: Int(width), height: Int(height))
            
        case .contest(_):
            let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right))
            
            let height = width * 0.3
            
            return CGSize(width: Int(width), height: Int(height))
        }
        
    }
}
