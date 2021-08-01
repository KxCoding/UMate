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
        alertWithNoAction(title: "알림", message: "친구로 등록되었습니다.")
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
        
        if textField.text == "Hello" || textField.text == "Hi" || textField.text == "aaa" {
            idLabel.text = textField.text
            foundContainerView.isHidden = false
            notFoundContainerView.isHidden = true
        } else {
            foundContainerView.isHidden = true
            notFoundContainerView.isHidden = false
        }
        return true
    }
}
