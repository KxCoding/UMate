//
//  FriendSearchViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/29.
//

import UIKit

class FriendSearchViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var foundContainerView: UIView!
    @IBOutlet weak var notFoundContainerView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    
    
    @IBAction func addFriendsButton(_ sender: Any) {
        alert(title: "알림", message: "친구로 등록되었습니다.")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.becomeFirstResponder()
        
        foundContainerView.isHidden = true
        notFoundContainerView.isHidden = true
    }

}




extension FriendSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 아이디가 존재한다면 친구 목록 보여주기
        if textField.text == "Hello" || textField.text == "Hi" || textField.text == "aaa" {
            idLabel.text = textField.text
            foundContainerView.isHidden = false
            notFoundContainerView.isHidden = true
        } else { // 아이디가 존재하지 않는다면 "검색 결과가 없습니다" 화면 보여주기
            foundContainerView.isHidden = true
            notFoundContainerView.isHidden = false
        }
        
        return true
    }
}
