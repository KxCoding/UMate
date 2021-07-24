//
//  DetailTableViewCell.swift
//  DetailTableViewCell
//
//  Created by Effie on 2021/07/22.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var districtCollectionView: UICollectionView!
    @IBOutlet weak var keywordsCollectionView: UICollectionView!
    
    var target = Place(name: "학교 이름", university: "대학교", district: "도서관 근처", type: .restaurant, keywords: ["일식당", "아기자기한"])
    
    func configure(with content: Place, indexPath: IndexPath) {
        print(type(of: self), #function)
        target = content
        dump(target)
        
        addressLabel.text = target.district
        
        districtCollectionView.reloadData()
        keywordsCollectionView.reloadData()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // data source 연결
        districtCollectionView.dataSource = self
        keywordsCollectionView.dataSource = self
        
        // UI 초기화
        addressView.layer.cornerRadius = addressView.frame.height / 4
        
        
    }
    
}

extension DetailTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case districtCollectionView:
            return 1
            
        case keywordsCollectionView:
            print(target.keywords.count)
            return target.keywords.count
            
        default:
            return 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case districtCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DistrictCollectionViewCell", for: indexPath) as! DistrictCollectionViewCell
            
            cell.configure(with: target, indexPath: indexPath)
            
            return cell
            
        case keywordsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordsCollectionViewCell", for: indexPath) as! KeywordsCollectionViewCell
            print("generate keyword cell")
            
            cell.configure(with: target, indexPath: indexPath)
            
            return cell
            
        default:
            fatalError()
            
        }
    }
    
    
}
