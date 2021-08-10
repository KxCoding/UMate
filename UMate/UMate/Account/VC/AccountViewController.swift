//
//  AccountViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var activeTextField: UITextField? = nil
    
    
    @IBAction func findIDPassword(_ sender: Any) {
        
        
    }
    
    
    @IBAction func register(_ sender: Any) {
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        guard idTextField.text == User.emailAddress && passwordTextField.text == User.password else {
            return
        }
        guard let id = idTextField.text,
              id.count > 0,
              isEmailValid(id),
              id.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  
                  alert(title: "알림", message: "존재하지 않는 아이디 입니다.")
                  
                  return
              }
        
        guard let password = passwordTextField.text,
              isPasswordValid(password),
              password.count >= 8,
              password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  
                  alert(title: "알림", message: "아이디와 비밀번호가 맞지 않습니다.")
                  
                  return
              }
        
        
        CommonViewController.shared.transitionToHome()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardWillShow()
        addKeyboardWillHide()
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        
        idTextField.text = User.emailAddress
        passwordTextField.text = User.password
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    func isPasswordValid(_ password : String) -> Bool{
        if let range = password.range(of: Regex.password, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (password.startIndex, password.endIndex) {
            return true
        }
        
        return false
    }
    
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        
        return false
    }
    
    
}


extension AccountViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    
}


extension AccountViewController {
    
    func addKeyboardWillShow() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return  }
            guard let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                strongSelf.view.frame.origin.y = 0 - keyboardSize.height
            }
            
        }
    }
    
    func addKeyboardWillHide() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
    }
    
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
