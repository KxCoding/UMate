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
    
    /// 정보를 표시할 가게
    var target: Place!
    
    /// 셀 내부 각 뷰들이 표시하는 content 초기화
    /// - Parameter content: 표시할 내용을 담은 Place 객체
    func configure(with content: Place, indexPath: IndexPath) {
        target = content
        
        addressLabel.text = target.district
        
        districtCollectionView.reloadData()
        keywordsCollectionView.reloadData()
        
    }
   
    
    /// 셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // data source 연결
        districtCollectionView.dataSource = self
        keywordsCollectionView.dataSource = self
        
        // UI 초기화
        addressView.configureStyle(with: [.squircleSmall])
    }
    
}




extension DetailTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case districtCollectionView:
            return 1
            
        case keywordsCollectionView:
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
            
            cell.configure(with: target, indexPath: indexPath)
            
            return cell
            
        default:
            fatalError()
            
        }
    }
    
    
}




class WordCollectionViewCell: UICollectionViewCell {
    
    var target: Place?
    
    func configure(with content: Place, indexPath: IndexPath) {
        target = content
    }
    override func awakeFromNib() {
        
    }
    
}




class DistrictCollectionViewCell: WordCollectionViewCell {
    
    @IBOutlet weak var districtItemView: UIView!
    @IBOutlet weak var districtKeywordLabel: UILabel!
    
    override func configure(with content: Place, indexPath: IndexPath) {
        super.configure(with: content, indexPath: indexPath)
        
        // 일단은 district 속성이 단일 문자열만 받아서 한 건만 처리 (tbd)
        districtKeywordLabel.text = content.district
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // UI 초기화
        districtItemView.layer.cornerRadius = districtItemView.frame.height / 4
    }
    
}



class KeywordsCollectionViewCell: WordCollectionViewCell {
    @IBOutlet weak var keywordItemView: UIView!
    @IBOutlet weak var keywordLabel: UILabel!
    
    override func configure(with content: Place, indexPath: IndexPath) {
        super.configure(with: content, indexPath: indexPath)
        
        guard (0 ..< content.keywords.count).contains(indexPath.item) else {
            print("invalid index")
            return
            
        }
        
        keywordLabel.text = content.keywords[indexPath.item]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // UI 초기화
        keywordItemView.layer.cornerRadius = keywordItemView.frame.height / 4
    }
    
    
}
