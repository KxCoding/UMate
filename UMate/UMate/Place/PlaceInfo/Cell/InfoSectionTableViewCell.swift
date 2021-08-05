//
//  InfoSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit

class InfoSectionTableViewCell: UITableViewCell {
    
    var target: Place!
    
    @IBOutlet weak var placeTypeImage: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var openInstagramButton: UIButton!
    @IBOutlet weak var openSafariButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func openInInstagram(_ sender: UIButton) {
        guard let id = target.instagramID, let url = URL(string: "https://instagram.com/\(id)") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func openInSafari(_ sender: Any) {
        
        guard let url = target.url, let webURL = URL(string: url) else { return }
        
        if UIApplication.shared.canOpenURL(webURL) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(webURL)
            }
        }
    }
}
