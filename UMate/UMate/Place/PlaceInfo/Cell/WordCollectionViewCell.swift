//
//  WordCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/27.
//

import UIKit


// MARK: 단어 전용 컬렉션 뷰
class WordCollectionViewCell: UICollectionViewCell {
    
    var target: Place?
    
    func configure(with content: Place, indexPath: IndexPath) {
        target = content
    }
    
    override func awakeFromNib() {
        configureStyle(with: [.squircleSmall])
    }
    
}




// MARK: 인근 지역 컬렉션 뷰
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
    }
    
}


// MARK: 키워드 컬렉션 뷰
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
    }
    
    
}
