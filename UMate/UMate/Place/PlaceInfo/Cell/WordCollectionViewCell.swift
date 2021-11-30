//
//  WordCollectionViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/27.
//
import UIKit


// MARK: 단어 전용 컬렉션 뷰 셀
/// 키워드 등 문자열 아이템을 표시하는 셀
///
/// 인근 지역 컬렉션 뷰, 키워드 컬렉션 뷰 셀 클래스에서 상속합니다. 공통 UI 및 데이터 초기화 작업을 위한 속성과 메소드가 선언되어 있습니다.
/// 아웃렛은 상속하는 클래스에서 별도로 선언해 사용해야 합니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
class WordCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    /// 단어 레이블 컨테이너
    @IBOutlet weak var wordLabelContainer: UIView!
    
    /// 단어 레이블
    @IBOutlet weak var wordLabel: UILabel!
    
    
    // MARK: Properties
    
    /// 대상 상점
    var target: String?
    
    
    // MARK: Methods
    
    /// 각 뷰에서 표시하는 데이터를 초기화합니다.
    /// - Parameters:
    ///   - content: 표시할 내용을 담은 Place 객체
    ///   - indexPath: 셀의 index path
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func configure(with content: String) {
        target = content
        guard let target = target else { return }
        wordLabel.text = target
    }
    
    
    // MARK: Cell Lifecycle Method
    
    /// 셀이 로드되면 UI를 초기화합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func awakeFromNib() {
        configureStyle(with: [.smallRoundedRect])
    }
    
}
