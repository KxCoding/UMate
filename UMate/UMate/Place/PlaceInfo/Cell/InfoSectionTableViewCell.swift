//
//  InfoSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit
import WebKit

extension Notification.Name {
    
    /// 북마크 토글 시
    static let updateBookmark = Notification.Name(rawValue: "bookmarkUpdate")
    
    /// url 관련 버튼을 눌렀을 때
    static let openUrl = Notification.Name(rawValue: "openUrl")
    
}




class InfoSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeTypeImage: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    @IBOutlet weak var openInstagramButton: UIButton!
    @IBOutlet weak var openSafariButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    /// 정보를 표시할 가게
    var target: Place!
    
    
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
        if target.instagramID == nil {
            openInstagramButton.isHidden = true
        }
        
        /// 웹페이지가 없으면 버튼을 표시하지 않음
        if target.url == nil {
            openSafariButton.isHidden = true
        }
        
        /// 북마크가 되어 있으면 select
        if PlaceUser.tempUser.userData.bookmarkedPlaces.contains(target.name) {
            bookmarkButton.isSelected = true
        } else {
            bookmarkButton.isSelected = false
        }
        
        
    }
    
    
    /// 셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    /// 버튼을 누르면 해당 가게 인스타그램 open
    /// - Parameter sender: 버튼
    @IBAction func openInInstagram(_ sender: UIButton) {
        guard let id = target.instagramID,
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
        if let index = PlaceUser.tempUser.userData.bookmarkedPlaces.firstIndex(of: target.name) {
            PlaceUser.tempUser.userData.bookmarkedPlaces.remove(at: index)
            /// 노티피케이션 전송
            NotificationCenter.default.post(name: .updateBookmark, object: nil)
        } else {
            PlaceUser.tempUser.userData.bookmarkedPlaces.append(target.name)
        }
        
        #if DEBUG
        print(PlaceUser.tempUser.userData.bookmarkedPlaces)
        #endif
    }
}






