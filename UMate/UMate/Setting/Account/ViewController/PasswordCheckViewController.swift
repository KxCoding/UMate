//
//  PasswordCheckViewController.swift
//  PasswordCheckViewController
//
//  Created by 안상희 on 2021/08/05.
//

import UIKit

class PasswordCheckViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonDidTapped(_ sender: Any) {
        
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let password = passwordField.text, password.count > 0 else {
            alert(title: "경고", message: "비밀번호를 입력해주세요.")
            return false
        }
        
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.becomeFirstResponder()
        
        nextButton.setButtonTheme()
    }
}




extension PasswordCheckViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordField.resignFirstResponder()
        
        return true
    }
}
