//
//  FriendsListViewController.swift
//  FriendsListViewController
//
//  Created by 안상희 on 2021/07/28.
//

import UIKit

class FriendsListViewController: UIViewController {

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFriends(_ sender: Any) {
        print("친구추가")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
