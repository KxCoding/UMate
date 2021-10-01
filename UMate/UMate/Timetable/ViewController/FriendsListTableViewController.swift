//
//  FriendsListTableViewController.swift
//  FriendsListTableViewController
//
//  Created by 안상희 on 2021/07/28.
//

import UIKit


/// TimeTable 탭의 시간표 친구 목록 화면 TableViewController 클래스
///
/// 사용자의 시간표 친구 목록을 확인할 수 있습니다.
/// - Author: 안상희
class FriendsListTableViewController: UITableViewController {
    /// 친구 이름을 표시하는 UILabel
    @IBOutlet weak var nameLabel: UILabel!
    
    
    /// 친구 이름을 클릭하면 화면이 넘어가기 전에 호출됩니다.
    /// - Parameters:
    ///   - segue: 뷰컨트롤러에 포함된 segue에 대한 정보를 갖는 객체
    ///   - sender: 친구 이름 (테이블뷰 셀). 클릭 시 친구 시간표 화면으로 이동합니다.
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
