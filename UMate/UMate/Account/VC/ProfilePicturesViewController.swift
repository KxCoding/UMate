//
//  ProfilePicturesViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/04.
//

import UIKit

/// Make  new notification name
extension Notification.Name {
    static let didTapProfilePics = Notification.Name("didTapProfilePics")
}

class ProfilePicturesViewController: UIViewController {
    
    /// Make userInfoKey
    static let picsKey = "picsKey"
    
    /// Cancel method
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Cancel profile View
    @IBAction func selectedProfilePic(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


extension ProfilePicturesViewController {
    /// Declaration notification post using userInfo's dictionary and tried match a value to  Asset image ID
    @IBAction func selectedProfilePicsButton1(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: sender.tag / 100])
        
    }
    
}
