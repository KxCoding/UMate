//
//  WordCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/27.
//

import UIKit


// MARK: 단어 전용 컬렉션 뷰 셀 (공통)

/// 키워드 등 문자열 아이템을 표시하는 셀 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
class WordCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    var target: Place!
    
    
    // MARK: Methods
    
    func configure(with content: Place, indexPath: IndexPath) {
        target = content
    }
    
    // MARK: Cell Lifecycle Method
    
    override func awakeFromNib() {
        configureStyle(with: [.smallRoundedRect])
    }
    
}




// MARK: - 인근 지역 컬렉션 뷰 셀

/// 인근 지역 컬렉션 뷰 셀 클래스
///
/// 이 클래스는 WordCollectionViewCell을 상속합니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
class DistrictCollectionViewCell: WordCollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var districtItemView: UIView!
    @IBOutlet weak var districtKeywordLabel: UILabel!
    
    // MARK: Methods
    
    override func configure(with content: Place, indexPath: IndexPath) {
        super.configure(with: content, indexPath: indexPath)
        
        // 일단은 district 속성이 단일 문자열만 받아서 한 건만 처리 (tbd)
        districtKeywordLabel.text = target.district
        
        
    }
    
}


// MARK: - 키워드 컬렉션 뷰 셀

/// 키워드 컬렉션 뷰 셀 클래스
///
/// 이 클래스는 WordCollectionViewCell을 상속합니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
class KeywordsCollectionViewCell: WordCollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var keywordItemView: UIView!
    @IBOutlet weak var keywordLabel: UILabel!
    
    // MARK: Methods
    
    override func configure(with content: Place, indexPath: IndexPath) {
        super.configure(with: content, indexPath: indexPath)
        
        // 인덱스 확인
        guard (0 ..< target.keywords.count).contains(indexPath.item) else {
            print("invalid index")
            return
            
        }
        
        keywordLabel.text = target.keywords[indexPath.item]
    }
    
}
