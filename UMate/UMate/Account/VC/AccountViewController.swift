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
    
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    // 특정 텍스트필드를 조작하기위한 속성
    var activeTextField: UITextField? = nil
    
    /// 로그인 검증 메소드
    /// - Parameter sender: 로그인 버튼
    @IBAction func login(_ sender: Any) {
        /// 키체인에 저장한 이메일 비밀번호만 로그인이 가능하게끔 조건문 작성
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
        
        CommonViewController.shared.transitionToHome()
     
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 키보드 호출 메소드
        addKeyboardWillShow()
        addKeyboardWillHide()
        
        /// 로그인버튼 알약모양
        loginButton.setButtonTheme()
        
        /// delegate 선언
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        ///키체인 이메일/ 비번으로 초기화(작업 편의성)
       idTextField.text = keychain.get(Keys.userEmailKey)
       passwordTextField.text = keychain.get(Keys.passwordKey)
        
        /// 백그라운드 탭하면 키보드 내려가는 기능
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        registerButton.setTitleColor(UIColor.dynamicColor(light: .darkGray, dark: .white), for: .normal)
        
    }
    
    
    /// Regular expression으로 패스워드 검증 하는 메소드
    /// - Parameter password: 패스워드 텍스트필드
    /// - Returns: boolean 값
    func isPasswordValid(_ password : String) -> Bool{
        if let range = password.range(of: Regex.password, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (password.startIndex, password.endIndex) {
            return true
        }
        
        return false
    }
    
    
    /// Regular expression으로 이메일 검증 하는 메소드
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
    // 텍스트필드에 값이 넣어질때
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    // 텍스트필드에 값을 입력하는게 끝났을시
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    
}


extension AccountViewController {
    /// 텍스트필드에 키보드의 높이가 맞닿을 시 뷰가 올라가는 메소드
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
    
    /// 키보드 내려가는 메소드
    func addKeyboardWillHide() {
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
