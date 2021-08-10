//
//  SettingTableViewController.swift
//  SettingTableViewController
//
//  Created by 황신택 on 2021/07/23.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    var token: NSObjectProtocol?
    
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
        }
    }
    
    
    @IBAction func cacheDeleteButtonDidTapped(_ sender: Any) {
        alert(message: "캐시를 삭제하시겠습니까?")
    }
    
    
   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        StorageDataSource.shard.display(with: profileImageView)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
