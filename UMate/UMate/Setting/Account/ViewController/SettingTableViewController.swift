//
//  SettingTableViewController.swift
//  SettingTableViewController
//
//  Created by 황신택 on 2021/07/23.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enterYearAndUniNameLabel: UILabel!
    
    /// back to LoginView
    @IBAction func logOutTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
    }
    
    
    @IBAction func alertButtonDidTapped(_ sender: Any) {
        alertVersion2(message: "알림 기능 이용을 위해 아이폰의 [설정] > [UMate]에서 알림을 허용해주세요.") { [weak self] action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } handler2: { _ in }
    }
    
    
    @IBAction func cacheDeleteButtonDidTapped(_ sender: Any) {
        alertVersion2(message: "캐시를 삭제하시겠습니까?") { [weak self] action in
            
        } handler2: { _ in }

    }
    
    /// Declear to remove observer 
    var token: NSObjectProtocol?
    
    /// when user didTap this button, present to ProfilePicturesViewController and then get image
    @IBAction func ChangeToProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        if let nav = storyboard.instantiateViewController(withIdentifier: "profileNav") as? UINavigationController {
            
            present(nav, animated: true, completion: nil)
            
            token = NotificationCenter.default.addObserver(forName: .didTapProfilePics, object: nil, queue: .main, using: { [weak self] noti in
                guard let strongSelf = self else { return }
                guard let profileImages = noti.userInfo?[ProfilePicturesViewController.picsKey] as? Int else { return }
                guard let image = UIImage(named: "\(profileImages)") else { return }
                
                strongSelf.profileImageView.image = image
                StorageDataSource.shard.save(image: image)
            })
        }
    }
    
    /// To prevent remained observer
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// get  register user information data
        let name = UserDefaults.standard.string(forKey: "nameKey")
        let nickName = UserDefaults.standard.string(forKey: "nickNameKey")
        let enterYearOfUniversity = UserDefaults.standard.string(forKey: "enterenceYearKey")
        let universityName = UserDefaults.standard.string(forKey: "universityNameKey")
        
        /// get register Profileimage data
        StorageDataSource.shard.display(with: profileImageView)
        
        /// To initialize user information in setting
        if let name = name,
           let nickName = nickName,
           let enterYearOfUniversity = enterYearOfUniversity,
           let universityName = universityName {
            nameLabel.text = "\(name)/ \(nickName)"
            enterYearAndUniNameLabel.text = "\(enterYearOfUniversity)/ \(universityName)"
        }
        
        /// initialize
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        /// To support color depend on dark mode or light mode
        nameLabel.textColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        enterYearAndUniNameLabel.textColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        emailLabel.textColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        navigationController?.navigationBar.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
    }
}
