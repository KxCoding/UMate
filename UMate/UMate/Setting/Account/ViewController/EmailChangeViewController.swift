//
//  EmailChangeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/08/04.
//

import UIKit

class EmailChangeViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailErrorContainerView: UIView!
    
    @IBOutlet weak var changeButton: UIButton!
    
    
    @IBAction func changeButtonDidTapped(_ sender: Any) {
        guard let email = emailField.text, let _ = email.range(of: Regex.email, options: .regularExpression) else {
            emailErrorContainerView.isHidden = false
            return
        }
        emailErrorContainerView.isHidden = true
        
        alert(message: "정상적으로 변경되었습니다.")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.becomeFirstResponder()
        emailErrorContainerView.isHidden = true
        
        changeButton.setButtonTheme()
    }
}



extension EmailChangeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let email = emailField.text, let _ = email.range(of: Regex.email, options: .regularExpression) else {
            emailErrorContainerView.isHidden = false
            return false
        }
        emailErrorContainerView.isHidden = true
        
        return true
    }
}
