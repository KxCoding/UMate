//
//  ProfilePicturesViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/04.
//

import UIKit

extension Notification.Name {
    static let didTapProfilePics = Notification.Name("didTapProfilePics")
}

class ProfilePicturesViewController: UIViewController {
    
    static let picsKey = "picsKey"
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectedProfilePic(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


extension ProfilePicturesViewController {
    @IBAction func selectedProfilePicsButton1(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: sender.tag / 100])
        
        dismiss(animated: true, completion: nil)
        
    }
 
    
}
