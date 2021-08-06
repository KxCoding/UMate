//
//  InfoSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit

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
        
        placeTypeImage.image = target.typeIconImage
        placeNameLabel.text = target.name
        
        universityLabel.text = target.university
        districtLabel.text = target.district
        
        keywordLabel.text = target.keywords.first
        placeTypeLabel.text = target.type.rawValue
        
        if target.instagramID == nil {
            openInstagramButton.isHidden = true
        }
        
        if target.url == nil {
            openSafariButton.isHidden = true
        }
        
    }
    
    
    /// 셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    /// 버튼을 누르면 해당 가게 인스타그램 open
    /// - Parameter sender: 버튼
    @IBAction func openInInstagram(_ sender: UIButton) {
        guard let id = target.instagramID else { return }
        openURL(urlString: "https://instagram.com/\(id)")
    }
    
    
    /// 버튼을 누르면 해당 가게 관련 URL open
    /// - Parameter sender: 버튼
    @IBAction func openInSafari(_ sender: Any) {
        guard let string = target.url else { return }
        openURL(urlString: string)
    }
    
    
    /// 문자열 url을 앱이나 웹에서 열어주는 메소드
    /// - Parameter urlString: 문자열 url
    func openURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
