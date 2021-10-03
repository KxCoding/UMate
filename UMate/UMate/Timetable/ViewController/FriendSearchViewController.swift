//
//  FriendSearchViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/29.
//

import UIKit


/// TimteTable 탭의 친구 검색/추가 화면 ViewController 클래스
///
/// 아이디를 통해 친구를 검색하고 추가할 수 있습니다.
/// - Author: 안상희
class FriendSearchViewController: UIViewController {
    /// 친구 아이디를 검색할 수 있는 TextField
    @IBOutlet weak var searchField: UITextField!
    
    /// 친구 아이디가 검색되면 나타나는 UIView
    @IBOutlet weak var foundContainerView: UIView!
    
    /// 친구 아이디 검색 결과가 없을 경우 나타나는 UIView
    @IBOutlet weak var notFoundContainerView: UIView!
    
    /// 친구 아이디가 검색되면 나타나는 UILabel
    @IBOutlet weak var idLabel: UILabel!
    
    /// 친구 아이디가 검색될 경우, 친구를 추가하기 위한 UIButton
    @IBOutlet weak var addFriends: UIButton!
    

    /// 친구를 등록합니다.
    /// - Parameter sender: 친구 추가 버튼
    @IBAction func addFriendsButton(_ sender: Any) {
        alert(title: "알림", message: "친구로 등록되었습니다.")
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.becomeFirstResponder()
        foundContainerView.isHidden = true
        notFoundContainerView.isHidden = true
    }
}



extension FriendSearchViewController: UITextFieldDelegate {
    /// Return 버튼을 눌렀을 때의 process에 대해 delegate에게 묻습니다.
    /// - Parameter textField: Return 버튼이 눌려진 해당 TextField
    /// - Returns: TextField가 return 버튼에 대한 동작을 구현해야하는 경우 true이고, 그렇지 않으면 false입니다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 아이디가 존재한다면 친구 목록을 보여줍니다.
        if textField.text == "Hello" || textField.text == "Hi" || textField.text == "aaa" {
            idLabel.text = textField.text
            foundContainerView.isHidden = false
            notFoundContainerView.isHidden = true
            addFriends.setToEnabledButtonTheme()
        } else {
            // 아이디가 존재하지 않는다면 "검색 결과가 없습니다" 화면을 보여줍니다.
            foundContainerView.isHidden = true
            notFoundContainerView.isHidden = false
        }
        return true
    }
}
