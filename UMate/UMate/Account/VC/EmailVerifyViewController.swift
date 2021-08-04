//
//  EmailVerifyViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/07/29.
//

import UIKit

class EmailVerifyViewController: UIViewController {
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var emailVerificationButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBAction func sendCodeButtonAction(_ sender: Any) {
        guard let id = emailTextField.text,
              id.count > 0,
              id.contains("@") && id.contains("."),
              id.trimmingCharacters(in: .whitespacesAndNewlines)  != "" else {
                  showError(title: "알림", message: "잘못된 형식의 이메일입니다.")
                  return
              }
    }
    
    @IBAction func emailVerificationButtonAction(_ sender: Any) {
        guard let codeField = codeTextField.text, codeField == "19930725" else {
            showError(title: "알림", message: "잘못된 코드입니다.")
            return
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailRegisterViewController {
            vc.verifiedEmail = emailTextField.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [sendCodeButton, emailVerificationButton].forEach({
            $0?.layer.cornerRadius = 14
            
        })
        [emailTextField, codeTextField].forEach {
            $0?.layer.cornerRadius = 16
            $0?.clipsToBounds = true
        }
        
        codeTextField.delegate = self
        codeTextField.text = "19930725"
        emailTextField.text = "qwer123@gmail.com"
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

}

extension EmailVerifyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let finalStr = NSString(string: codeTextField.text ?? "").replacingCharacters(in: range, with: string)
        let chartSet = CharacterSet(charactersIn: "0123456789").inverted
        
        guard let _ = finalStr.rangeOfCharacter(from: chartSet) else { return true }
        
        return false
    }
}
