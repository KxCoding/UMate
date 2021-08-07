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
    
    // profilePic
    @IBOutlet weak var profilePic1: UIImageView!
    @IBOutlet weak var profilePic2: UIImageView!
    @IBOutlet weak var profilePic3: UIImageView!
    @IBOutlet weak var profilePic4: UIImageView!
    @IBOutlet weak var profilePic5: UIImageView!
    @IBOutlet weak var profilePic6: UIImageView!
    @IBOutlet weak var profilePic7: UIImageView!
    @IBOutlet weak var profilePic8: UIImageView!
    @IBOutlet weak var profilePic9: UIImageView!
    
    // Profile Button
    @IBOutlet weak var profileButton1: UIButton!
    @IBOutlet weak var profileButton2: UIButton!
    @IBOutlet weak var profileButton3: UIButton!
    @IBOutlet weak var profileButton4: UIButton!
    @IBOutlet weak var profileButton5: UIButton!
    @IBOutlet weak var profileButton6: UIButton!
    @IBOutlet weak var profileButton7: UIButton!
    @IBOutlet weak var profileButton8: UIButton!
    @IBOutlet weak var profileButton9: UIButton!
    
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
    @IBAction func selectedProfilePicsButton1(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: profilePic1 ?? UIImageView()])

        dismiss(animated: true, completion: nil)

    }
    @IBAction func selectedProfilePicsButton2(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: profilePic2 ?? UIImageView()])
        dismiss(animated: true, completion: nil)

    }
    @IBAction func selectedProfilePicsButton3(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: profilePic3 ?? UIImageView()])
        dismiss(animated: true, completion: nil)

    }
    @IBAction func selectedProfilePicsButton4(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: profilePic4 ?? UIImageView()])
        dismiss(animated: true, completion: nil)

    }
    @IBAction func selectedProfilePicsButton5(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: profilePic5 ?? UIImageView()])

        dismiss(animated: true, completion: nil)

    }
    @IBAction func selectedProfilePicsButton6(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: profilePic6 ?? UIImageView()])

        dismiss(animated: true, completion: nil)

    }
    @IBAction func selectedProfilePicsButton7(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: profilePic7 ?? UIImage()])

        dismiss(animated: true, completion: nil)

    }
    @IBAction func selectedProfilePicsButton8(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: profilePic8 ?? UIImage()])

        dismiss(animated: true, completion: nil)

    }
    @IBAction func selectedProfilePicsButton9(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: profilePic9 ?? UIImage()])

        dismiss(animated: true, completion: nil)

    }


}
