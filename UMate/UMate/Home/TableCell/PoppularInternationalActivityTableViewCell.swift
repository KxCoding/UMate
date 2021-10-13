//
//  InternationalActivityTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/10/08.
//

import UIKit

/// 인기 대외활동 셀
/// 테이블뷰 셀 안에있는 콜렉션뷰를 구현합니다.
/// - Author: 황신택 (sinadsl1457@gmail.com)
class PoppularInternationalActivityTableViewCell: UITableViewCell {
    /// 인기 대외활동 데이터 모델
    var list = [ContestSingleData.FavoriteContests]()
    
    /// 인기 대외활동 콜렉션 뷰
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    
    /// 대외활동 VC에있는 데이터를 파라미터로 전달 받습니다.
    /// - Parameter models: [ContestSingleData.FavoriteContests]
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func configure(with models: [ContestSingleData.FavoriteContests] ) {
        DispatchQueue.global().async {
            self.list = models
        }
        DispatchQueue.main.async {
            self.listCollectionView.reloadData()
        }
    }
    
    /// 초기화 작업은 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
}


extension PoppularInternationalActivityTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PoppularInternationalActivityCollectionViewCell", for: indexPath) as! PoppularInternationalActivityCollectionViewCell
        let model = list[indexPath.row]
        
        cell.configure(with: model)
        
        return cell
    }
}



extension PoppularInternationalActivityTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero}
        
        let width = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2
        
        let height = width * 1.4
        
        return CGSize(width: Int(width), height: Int(height))
        
    }
}
