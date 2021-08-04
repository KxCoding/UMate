//
//  EmailChangeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/08/04.
//

import UIKit

class EmailChangeViewController: UIViewController {

    let regex = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var emailErrorContainerView: UIView!
    
    
    @IBAction func changeButtonDidTapped(_ sender: Any) {
        guard let email = emailField.text, let _ = email.range(of: regex, options: .regularExpression) else {
            emailErrorContainerView.isHidden = false
            return
        }
        emailErrorContainerView.isHidden = true
        
        alertWithNoAction(title: "알림", message: "정상적으로 변경되었습니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.becomeFirstResponder()
        emailErrorContainerView.isHidden = true
    }

}



extension EmailChangeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let email = emailField.text, let _ = email.range(of: regex, options: .regularExpression) else {
            emailErrorContainerView.isHidden = false
            return false
        }
        emailErrorContainerView.isHidden = true
        
        return true
    }
}
