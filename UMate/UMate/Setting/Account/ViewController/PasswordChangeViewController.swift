//
//  PasswordChangeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/08/04.
//

import UIKit

class PasswordChangeViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkField: UITextField!
    
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var checkPasswordContainerView: UIView!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var checkPasswordLabel: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    
    
    @IBAction func changeButtonDidTapped(_ sender: Any) {
        
        guard let password = passwordField.text, password.count > 0 else {
            alert(title: "경고", message: "비밀번호를 형식에 맞게 입력해주세요.")
            return
        }
        
        guard let checkPassword = checkField.text, checkPassword.count > 0 else {
            alert(title: "경고", message: "비밀번호를 다시 한 번 입력해주세요.")
            return
        }
        
        guard password == checkPassword else {
            alert(title: "경고", message: "입력하신 두 비밀번호가 일치하지 않습니다.")
            return
        }
        
        alert(message: "비밀번호가 변경되었습니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.becomeFirstResponder()
        
        changeButton.setButtonTheme()
    }

}



extension PasswordChangeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordField:
            checkField.becomeFirstResponder()
        case checkField:
            checkField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordField:
            guard let password = passwordField.text, password.count > 1 else {
                passwordContainerView.isHidden = false
                return false
            }
            passwordLabel.text = "올바른 비밀번호입니다."
            passwordLabel.textColor = UIColor.blue
            passwordContainerView.isHidden = false
        case checkField:
            guard let checkPassword = checkField.text, checkPassword.count > 1, checkPassword == passwordField.text else {
                checkPasswordContainerView.isHidden = false
                checkPasswordLabel.text = "입력하신 두 비밀번호가 일치하지 않습니다."
                checkPasswordLabel.textColor = UIColor.red
                return true
            }
            checkPasswordLabel.text = "비밀번호가 일치합니다."
            checkPasswordLabel.textColor = UIColor.blue
            checkPasswordContainerView.isHidden = false
        default:
            break
        }
        return true
    }
}
