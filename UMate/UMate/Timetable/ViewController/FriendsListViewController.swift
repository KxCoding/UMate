//
//  FriendsListViewController.swift
//  FriendsListViewController
//
//  Created by 안상희 on 2021/07/28.
//

import UIKit


/// TimeTable 탭에서 시간표 친구 목록을 보여주는 ViewController 클래스.
/// - Author: 안상희
class FriendsListViewController: UIViewController {
    /// 친구 목록에서 닫기를 누르면 호출됩니다.
    /// - Parameter sender: UIButton.
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 친구 목록에서 친구 추가를 누르면 호출됩니다.
    /// - Parameter sender: UIButton.
    @IBAction func addFriends(_ sender: Any) {
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
