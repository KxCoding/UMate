//
//  BookmarkListTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import UIKit


/// 북마크된 가게 셀
/// - Author: 박혜정(mailmelater11@gmail.com)
class BookmarkListTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    /// 가게 이름 레이블
    @IBOutlet weak var placeNameLabel: UILabel!
    
    /// 인근 지역 레이블
    @IBOutlet weak var districtLabel: UILabel!
    
    /// 첫번째 키워드 레이블
    @IBOutlet weak var keywordLabel1: UILabel!
    
    /// 첫번째 키워드 컨테이너
    @IBOutlet weak var keywordContainer1: UIView!
    
    /// 두번째 키워드 레이블
    @IBOutlet weak var keywordLabel2: UILabel!
    
    /// 두번째 키워드 컨테이너
    @IBOutlet weak var keywordContainer2: UIView!
    
    /// 가게 이미지 뷰
    @IBOutlet weak var placeImageView: UIImageView!
    
    /// data manager 객체
    let manager = PlaceDataManager.shared
    
    /// 셀에서 표시하는 place 객체
    var target: Place!
    
    
    // MARK: Methods
    
    /// 셀이 표시하는 데이터를 초기화합니다.
    /// - Parameter content: 뷰에 표시할 내용을 담은 Place 객체
    func configure(with content: Place) {
        target = content
        
        placeNameLabel.text = target.name
        districtLabel.text = target.district
        keywordLabel1.text = target.keywords.first
        
        if target.keywords.count > 1 {
            keywordLabel2.text = target.keywords[1]
        } else {
            keywordContainer2.isHidden = true
        }
        
        /// 응답에 따라 이미지 뷰 업데이트
        manager.download(.thumbnail, andUpdate: placeImageView, with: target.thumbnailUrl)
    }
    
    
    // MARK: Cell Lifecycle method
    
    /// 셀이 로드되면 셀 UI를 초기화합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        [keywordContainer1, keywordContainer2].forEach { $0?.configureStyle(with: [.smallRoundedRect]) }
        placeImageView.contentMode = .scaleAspectFill
    }
    
}
