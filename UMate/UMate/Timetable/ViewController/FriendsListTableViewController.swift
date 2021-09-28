//
//  FriendsListTableViewController.swift
//  FriendsListTableViewController
//
//  Created by 안상희 on 2021/07/28.
//

import UIKit


/// TimeTable 탭에서 시간표 친구 목록을 보여주는 TableViewController 클래스
/// - Author: 안상희
class FriendsListTableViewController: UITableViewController {
    // MARK: Outlet
    /// 친구 이름을 표시하는 UILabel
    @IBOutlet weak var nameLabel: UILabel!
    
    
    /// 친구 이름을 클릭하면 화면이 넘어가기 전에 호출됩니다.
    /// - Parameters:
    ///   - segue: UIStoryboardSegue
    ///   - sender: UITableViewCell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FriendLectureViewController {
            vc.friendName = nameLabel.text
        }
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
