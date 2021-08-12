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
    
    var activeTextField: UITextField? = nil
    
    
    @IBAction func sendCodeButtonAction(_ sender: Any) {
        guard let email = emailTextField.text,
              isEmailValid(email),
              email.trimmingCharacters(in: .whitespacesAndNewlines)  != "" else {
                  alert(title: "알림", message: "잘못된 형식의 이메일입니다.")
                  return
              }
    }
    
    
    @IBAction func emailVerificationButtonAction(_ sender: Any) {
        guard let codeField = codeTextField.text, codeField == "19930725" else {
            alert(title: "알림", message: "잘못된 코드입니다.")
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
        
        addKeyboardWillHide()
        addKeyboardWillShow()
        
        codeTextField.delegate = self
        codeTextField.text = "19930725"
        emailTextField.text = "qwer123@gmail.com"
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        
        return false
    }
    
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension EmailVerifyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let codeField = codeTextField.text else { return false }
        let finalStr = NSString(string: codeField).replacingCharacters(in: range, with: string)
        let chartSet = CharacterSet(charactersIn: "0123456789").inverted
        
        guard let _ = finalStr.rangeOfCharacter(from: chartSet) else { return true }
        
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
}

extension EmailVerifyViewController {
    func addKeyboardWillShow() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return  }
            guard let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            var shouldMoveViewUp = false
            
            if let activeTextField = strongSelf.activeTextField {
                let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: strongSelf.view).maxY
                let topOfKeyboard = strongSelf.view.frame.height - keyboardSize.height
                
                if bottomOfTextField > topOfKeyboard {
                    shouldMoveViewUp = true
                }
            }
            
            if shouldMoveViewUp {
                UIView.animate(withDuration: 0.3) {
                    strongSelf.view.frame.origin.y = 15 - keyboardSize.height
                }
                
            }
        }
        
    }
    
    
    func addKeyboardWillHide() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
    }
}
