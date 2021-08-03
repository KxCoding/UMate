//
//  PasswordChangeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/08/04.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBOutlet weak var passwordCheckField: UITextField!
    
    
    @IBAction func changeButtonDidTapped(_ sender: Any) {
        
        guard let pw = passwordField.text, pw.count > 0 else {
            alert(title: "알림", message: "현재 비밀번호가 올바르지 않습니다.")
            return
        }
        
        guard let newPassword = newPasswordField.text, newPassword.count > 0 else {
            alert(title: "경고", message: "비밀번호를 형식에 맞게 입력해주세요.")
            return
        }
        
        guard let checkPassword = passwordCheckField.text, checkPassword.count > 0 else {
            alert(title: "경고", message: "비밀번호를 다시 한 번 입력해주세요.")
            return
        }
        
        guard newPassword == checkPassword else {
            alert(title: "경고", message: "입력하신 두 비밀번호가 일치하지 않습니다.")
            return
        }
        
        alert(title: "알림", message: "비밀번호가 변경되었습니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
