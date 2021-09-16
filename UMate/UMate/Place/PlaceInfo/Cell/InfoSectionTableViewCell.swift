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
    static let updateBookmark = Notification.Name(rawValue: "bookmarkUpdate")
    
    /// url 관련 버튼을 눌렀을 때 전송되는 notification
    /// - Author: 박혜정(mailmelater11@gmail.com)
    static let openUrl = Notification.Name(rawValue: "openUrl")
    
}



/// 가게 기본 요약 정보를 표시하는 섹션의 셀 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
class InfoSectionTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    /// 가게 타입을 나타내는 심벌을 표시하는 이미지 뷰
    @IBOutlet weak var placeTypeImage: UIImageView!
    
    /// 가게 이름 레이블
    @IBOutlet weak var placeNameLabel: UILabel!
    
    ///  학교 이름 레이블
    @IBOutlet weak var universityLabel: UILabel!
    
    /// 인근 지역 레이블
    @IBOutlet weak var districtLabel: UILabel!
    
    /// 대표 키워드 레이블
    @IBOutlet weak var keywordLabel: UILabel!
    
    /// 가게 타입 레이블
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    /// 인스타그램 열기 버튼
    @IBOutlet weak var openInstagramButton: UIButton!
    
    /// 웹 페이지 열기 버튼
    @IBOutlet weak var openSafariButton: UIButton!
    
    /// 북마크 토글 버튼
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    // MARK: Properties
    
    /// 정보를 표시할 가게
    var target: Place!
    
    
    // MARK: Actions
    
    /// 버튼을 누르면 해당 가게 인스타그램 open
    /// - Parameter sender: 버튼
    @IBAction func openInInstagram(_ sender: UIButton) {
        guard let id = target.instagramId,
              let url = URL(string: "https://instagram.com/\(id)") else { return }
        
        NotificationCenter.default.post(name: .openUrl, object: nil, userInfo: ["type": URLType.web, "url": url])
    }
    
    
    /// 버튼을 누르면 해당 가게 관련 URL open
    /// - Parameter sender: 버튼
    @IBAction func openInSafari(_ sender: Any) {
        guard let urlString = target.url, let url = URL(string: urlString) else { return }
        
        NotificationCenter.default.post(name: .openUrl, object: nil, userInfo: ["type": URLType.web, "url": url])
    }
    
    
    /// 버튼을 누르면 해당 가게가 북마크됨 (사용자 북마크)
    /// - Parameter sender: 버튼
    @IBAction func updateBookmark(_ sender: UIButton) {
        /// 선택 상태 전환
        sender.isSelected = !sender.isSelected
        
        let normal = UIImage(systemName: "bookmark")
        let highlighted = UIImage(systemName: "bookmark.fill")
        sender.imageView?.image = sender.isSelected ? highlighted : normal
        
        /// 사용자 데이터에 가게가 포함되어 있으면 삭제, 없으면 추가
        if let index = PlaceUser.tempUser.userData.bookmarkedPlaces.firstIndex(of: target.id) {
            PlaceUser.tempUser.userData.bookmarkedPlaces.remove(at: index)
            /// 노티피케이션 전송
            NotificationCenter.default.post(name: .updateBookmark, object: nil)
        } else {
            PlaceUser.tempUser.userData.bookmarkedPlaces.append(target.id)
        }
        
        #if DEBUG
        print(PlaceUser.tempUser.userData.bookmarkedPlaces)
        #endif
    }
    
    
    // MARK: Methods
    
    /// 셀 내부 각 뷰들이 표시하는 content 초기화
    /// - Parameter content: 표시할 내용을 담은 Place 객체
    func configure(with content: Place) {
        
        target = content
        
        placeTypeImage.image = target.placeType.iconImage
        placeNameLabel.text = target.name
        
        universityLabel.text = PlaceUser.tempUser.university?.name
        districtLabel.text = target.district
        
        keywordLabel.text = target.keywords.first
        placeTypeLabel.text = target.placeType.description
        
        /// 인스타그램 아이디가 없으면 버튼을 표시하지 않음
        if target.instagramId == nil {
            openInstagramButton.isHidden = true
        }
        
        /// 웹페이지가 없으면 버튼을 표시하지 않음
        if target.url == nil {
            openSafariButton.isHidden = true
        }
        
        /// 북마크가 되어 있으면 select
        if PlaceUser.tempUser.userData.bookmarkedPlaces.contains(target.id) {
            bookmarkButton.isSelected = true
        } else {
            bookmarkButton.isSelected = false
        }
        
        
    }
    
}






