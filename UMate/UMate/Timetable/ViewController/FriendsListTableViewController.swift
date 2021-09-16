//
//  FriendsListTableViewController.swift
//  FriendsListTableViewController
//
//  Created by 안상희 on 2021/07/28.
//

import UIKit


/// TimeTable 탭에서 시간표 친구 목록을 보여주는 TableViewController
/// - Author: 안상희
class FriendsListTableViewController: UITableViewController {
    
    /// 친구 이름을 표시하는 UILabel
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FriendLectureViewController {
            vc.friendName = nameLabel.text
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
