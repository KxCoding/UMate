//
//  FriendsListTableViewController.swift
//  FriendsListTableViewController
//
//  Created by 안상희 on 2021/07/28.
//

import UIKit

class FriendsListTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FriendLectureViewController {
            print(nameLabel.text)
            vc.name = nameLabel.text
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}
