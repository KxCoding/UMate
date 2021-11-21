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
/// - Author: 황신택 (sinadsl1457@gmail.com)
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
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func login(_ sender: Any) {
#warning("협업을 하기위해서 잠시 주석처리 했습니다.")
        /*
         // 키체인에 저장된 계정인지 확인 합니다.
         guard let safeEmail = keychain.get(Keys.userEmailKey),
         let safePassword = keychain.get(Keys.passwordKey),
         let email = idTextField.text,
         let password = passwordTextField.text else { return }
         
         
         if keychain.lastResultCode != noErr { print(keychain.lastResultCode) }
         
         guard email == safeEmail && password == safePassword else {
         alert(title: "알림", message: "형식에 맞지않거나 존재하지않는 계정입니다", handler: nil)
         return
         }
         */
        
        // 홈화면으로 이동합니다.
        CommonViewController.transitionToHome()
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setToEnabledButtonTheme()
        
        didTapMakeLowerKeyboard()
        
        AddkeyboardNotification()
 
        makeChangeButtonColor(loginButton)
    }
}




