//
//  FriendsListViewController.swift
//  FriendsListViewController
//
//  Created by 안상희 on 2021/07/28.
//

import UIKit

class FriendsListViewController: UIViewController {

    
    /// 친구 목록에서 닫기를 누르면 호출되는 메소드
    /// - Parameter sender: UIButton
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /// 친구 목록에서 친구 추가를 누르면 호출되는 메소드
    /// - Parameter sender: UIButton
    @IBAction func addFriends(_ sender: Any) {
        print("친구추가")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
