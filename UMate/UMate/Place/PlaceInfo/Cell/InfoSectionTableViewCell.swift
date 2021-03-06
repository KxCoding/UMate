//
//  InfoSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit
import WebKit


extension Notification.Name {
    
    /// 북마크 토글 시 전송되는 notification
    /// - Author: 박혜정(mailmelater11@gmail.com)
    static let bookmarkHasBeenUpdated = Notification.Name(rawValue: "bookmarkHasBeenUpdated")
    
    /// url 관련 버튼을 눌렀을 때 전송되는 notification
    /// - Author: 박혜정(mailmelater11@gmail.com)
    static let urlOpenHasBeenRequested = Notification.Name(rawValue: "urlOpenHasBeenRequested")
    
}



/// 상점 개요 셀
/// - Author: 박혜정(mailmelater11@gmail.com)
class InfoSectionTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    /// 상점 타입을 나타내는 심벌을 표시하는 이미지 뷰
    @IBOutlet weak var placeTypeImageView: UIImageView!
    
    /// 상점 이름 레이블
    @IBOutlet weak var placeNameLabel: UILabel!
    
    ///  학교 이름 레이블
    @IBOutlet weak var universityLabel: UILabel!
    
    /// 인근 지역 레이블
    @IBOutlet weak var districtLabel: UILabel!
    
    /// 대표 키워드 레이블
    @IBOutlet weak var keywordLabel: UILabel!
    
    /// 상점 타입 레이블
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    /// 인스타그램 열기 버튼
    @IBOutlet weak var openInstagramButton: UIButton!
    
    /// 웹페이지 열기 버튼
    @IBOutlet weak var openSafariButton: UIButton!
    
    /// 북마크 토글 버튼
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    // MARK: Properties
    
    /// 정보를 표시할 상점
    var target: Place?
    
    
    // MARK: Actions
    
    /// 인스타그램 url을 엽니다.
    ///
    /// url의 타입과 url을 담아 notification를 전송하면 이를 수신한 화면 객체에서 앱 내 브라우저 또는 외부 앱을 통해 url을 엽니다.
    /// - Parameter sender: 버튼
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func openInInstagram(_ sender: UIButton) {
        guard let target = target else { return }
        
        guard let id = target.instagramId,
              let url = URL(string: "https://instagram.com/\(id)") else { return }
        
        NotificationCenter.default.post(name: .urlOpenHasBeenRequested,
                                        object: nil,
                                        userInfo: [urlOpenRequestNotificationUrlType: URLType.web, urlOpenRequestNotificationUrl: url])
    }
    
    
    /// 상점 url을 엽니다.
    ///
    /// url의 타입과 url을 담아 notification를 전송하면 이를 수신한 화면 객체에서 앱 내 브라우저 또는 외부 앱을 통해 url을 엽니다.
    /// - Parameter sender: 버튼
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func openInSafari(_ sender: Any) {
        guard let target = target else { return }
        guard let urlString = target.url,
                let url = URL(string: urlString) else { return }
        
        NotificationCenter.default.post(name: .urlOpenHasBeenRequested,
                                        object: nil,
                                        userInfo: [urlOpenRequestNotificationUrlType: URLType.web, urlOpenRequestNotificationUrl: url])
    }
    
    
    /// 북마크 상태를 토글합니다.
    ///
    /// 버튼의 선택 상태를 전환해 버튼 이미지를 변경한 후, 사용자 데이터에 상점이 포함되어 있으면 삭제하고 없으면 추가합니다.
    /// - Parameter sender: 버튼
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func updateBookmark(_ sender: UIButton) {
        NotificationCenter.default.post(name: .bookmarkHasBeenUpdated,
                                        object: nil)
    }
    
    
    // MARK: Methods
    
    /// 각 뷰에서 표시하는 데이터를 초기화합니다.
    ///
    /// 화면에서 전달된 상점 객체에 따라 대상 상점을 저장하고 뷰의 데이터를 초기화합니다.
    /// 상점의 인스타그램 아이디나 웹페이지 정보가 없으면 버튼을 표시하지 않고, 북마크 상태에 따라 버튼 상태를 변경합니다.
    /// - Parameter content: 표시할 내용을 담은 Place 객체
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func configure(with content: Place, isBookmarked: Bool) {
        
        target = content
        guard let target = target else { return }
        
        placeTypeImageView.image = target.placeType.iconImage
        placeNameLabel.text = target.name
        
        universityLabel.text = University.tempUniversity.name
        districtLabel.text = target.district
        
        keywordLabel.text = target.keywords.first
        placeTypeLabel.text = target.placeType.description
        
        openInstagramButton.isHidden = (target.instagramId == nil)
        openSafariButton.isHidden = (target.url == nil)
        
        bookmarkButton.isSelected = isBookmarked
    }
    
}






