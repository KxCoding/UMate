//
//  AccountViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import KeychainSwift

class AccountViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    /// create instance to get  user acoount data 
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// To Handle specific  some of TextField
    var activeTextField: UITextField? = nil
    
    /// To verify some conditions for login
    /// - Parameter sender: 로그인 버튼
    @IBAction func login(_ sender: Any) {
//        // 키체인에 저장한 이메일 비밀번호만 로그인이 가능하게끔 조건문 작성
//        guard let safeEmail = keychain.get(Keys.userEmailKey),
//              let safePassword = keychain.get(Keys.passwordKey),
//              let email = idTextField.text,
//              let password = passwordTextField.text else { return }
//
//        /// 에러가 발생시 에러문 띄우게끔 작성
//        if keychain.lastResultCode != noErr { print(keychain.lastResultCode) }
//
//        guard email == safeEmail && password == safePassword else {
//            alert(title: "알림", message: "형식에 맞지않거나 존재하지않는 계정입니다", handler: nil)
//            return
//        }
//
        CommonViewController.shared.transitionToHome()
     
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Call keyboard method
        addKeyboardWillShow()
        addKeyboardWillHide()
        
        /// To make shape like pills
        loginButton.setButtonTheme()
        
        /// delegate
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        /// Initialize to email, password field using keychain Bc to convinient work
       idTextField.text = keychain.get(Keys.userEmailKey)
       passwordTextField.text = keychain.get(Keys.passwordKey)
        
        /// when user didtap backgrond make lower keyboard.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        registerButton.setTitleColor(UIColor.dynamicColor(light: .darkGray, dark: .white), for: .normal)
        
    }
    
    
    /// To verify user password using regular expression
    /// - Parameter password: 패스워드 텍스트필드
    /// - Returns: boolean 값
    func isPasswordValid(_ password : String) -> Bool{
        if let range = password.range(of: Regex.password, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (password.startIndex, password.endIndex) {
            return true
        }
        
        return false
    }
    
    
    /// To verify user email using regular expression
    /// - Parameter email: 이메일 텍스트필드
    /// - Returns: boolean값
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        
        return false
    }
    
    
}


extension AccountViewController: UITextFieldDelegate {
    /// when enterence a value in textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    /// when end editing in textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    
}


extension AccountViewController {
    /// To avoid the keyboard tries to cover a text field
    func KeyboardWillShow() {
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
    
    /// To make lower keyboard 
    func KeyboardWillHide() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
    }
    
    
    
    /// 백그라운드 클릭시 키보드 내려가는 메소드
    /// - Parameter sender:UITapGestureRecognizer
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
