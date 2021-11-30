//
//  AccountViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import KeychainSwift
import RxSwift
import RxCocoa
import NSObject_Rx


/// 로그인 화면
/// - Author: 황신택 (sinadsl1457@gmail.com), 장현우(heoun3089@gmail.com)
class AccountViewController: CommonViewController {
    /// 아이디 필드
    @IBOutlet weak var idTextField: UITextField!
    
    /// 비밀번호 필드
    @IBOutlet weak var passwordTextField: UITextField!
    
    /// 로그인 버튼
    @IBOutlet weak var loginButton: UIButton!
    
    /// 회원가입 버튼
    @IBOutlet weak var registerButton: UIButton!
    
    
    /// 키체인 계정을 체크합니다.
    /// 성공시 홈화면으로 이동합니다.
    /// - Parameter sender: loginButton
    /// - Author: 황신택 (sinadsl1457@gmail.com), 장현우(heoun3089@gmail.com)
    @IBAction func login(_ sender: Any) {
        guard let email = idTextField.text,
              let password = passwordTextField.text else {
                  return
              }
        
        let emailLoginPostData = EmailLoginPostData(email: email, password: password)
        LoginDataManager.shared.login(emailLoginPostData: emailLoginPostData, transitionToHome: CommonViewController.transitionToHome, vc: self)
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        idTextField.text = "test@test.com"
        passwordTextField.text = "Test123456$"
        #endif
        
        loginButton.setToEnabledButtonTheme()
        
        didTapMakeLowerKeyboard()
        
        AddkeyboardNotification()
 
        makeChangeButtonColor(loginButton)
    }
}
