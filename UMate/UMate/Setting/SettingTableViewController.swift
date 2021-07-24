//
//  SettingTableViewController.swift
//  SettingTableViewController
//
//  Created by 황신택 on 2021/07/23.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBAction func logOutTapped(_ sender: UIButton) {
         
         let storyboard = UIStoryboard(name: "Account", bundle: nil)
         let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
         
         (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
         
     }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

}
