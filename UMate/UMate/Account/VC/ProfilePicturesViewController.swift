//
//  ProfilePicturesViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/04.
//

import UIKit

extension Notification.Name {
    static let didTapProfilePics = Notification.Name(rawValue: "didTapProfilePics")

}

class ProfilePicturesViewController: UIViewController {
    @IBOutlet weak var profilePics1: UIImageView!
    @IBOutlet weak var profilePics2: UIImageView!
    @IBOutlet weak var profilePics3: UIImageView!
    @IBOutlet weak var profilePics4: UIImageView!
    @IBOutlet weak var profilePics5: UIImageView!
    @IBOutlet weak var profilePics6: UIImageView!
    @IBOutlet weak var profilePics7: UIImageView!
    @IBOutlet weak var profilePics8: UIImageView!
    @IBOutlet weak var profilePics9: UIImageView!
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

}


extension ProfilePicturesViewController {
    @IBAction func selectedProfilePicsButton1(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: ["picsKey": profilePics1 ?? UIImageView()])
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func selectedProfilePicsButton2(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: ["picsKey": profilePics2 ?? UIImageView()])
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func selectedProfilePicsButton3(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: ["picsKey": profilePics3 ?? UIImageView()])
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func selectedProfilePicsButton4(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: ["picsKey": profilePics4 ?? UIImageView()])
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func selectedProfilePicsButton5(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: ["picsKey": profilePics5 ?? UIImageView()])
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func selectedProfilePicsButton6(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: ["picsKey": profilePics6 ?? UIImageView()])
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func selectedProfilePicsButton7(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: ["picsKey": profilePics7 ?? UIImageView()])
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func selectedProfilePicsButton8(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: ["picsKey": profilePics8 ?? UIImageView()])
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func selectedProfilePicsButton9(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: ["picsKey": profilePics9 ?? UIImageView()])
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
