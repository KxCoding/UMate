//
//  AccountViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import KeychainSwift

/// 로그인 화면
/// Author: 황신택 (sinadsl1457@gmail.com)
class AccountViewController: AccountCommonThingsViewController {
    /// 아이디 필드
    @IBOutlet weak var idTextField: UITextField!
    
    /// 비밀번호  필드
    @IBOutlet weak var passwordTextField: UITextField!
    
    /// 로그인 버튼
    @IBOutlet weak var loginButton: UIButton!
    
    /// 회원가입 버튼
    @IBOutlet weak var registerButton: UIButton!
    

    /// 키체인 계정을 체크합니다.
    /// 성공시 홈화면으로 갑니다.
    /// - Parameter sender: loginButton
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

        // 홈화면으로 갑니다.
        transitionToHome()
     
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 키보드 옵저버를 등록합니다.
        addKeyboardWillShowObserver()
        addKeyboardWillHideObserver()
        
        // 정해진 버튼 모양으로 만듭니다.
        loginButton.setToEnabledButtonTheme()
        
        // 저장된 키체인 계정으로 초기화합니다.
       idTextField.text = keychain.get(Keys.userEmailKey)
       passwordTextField.text = keychain.get(Keys.passwordKey)
        
        // 뷰를 탭하면 키보드가 내려갑니다.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AccountViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // registerButton 라이트 모드 다크모드 색상을 지원합니다.
        registerButton.setTitleColor(UIColor.dynamicColor(light: .darkGray, dark: .white), for: .normal)
        
    }
    
    /// 뷰를 탭할시 키보드가 내려갑니다.
    /// - Parameter sender: 파라미터가 UITapGestureRecognizer 전달
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}


extension AccountViewController {
    /// keyboardWillShowNotification을 처리하는 옵저버를 등록합니다.
    /// 키보드가 화면에 표시되기 직전에 키보드 높이만큼 Bottom 여백을 추가해서 UI와 겹치는 문제를 방지합니다.
    func addKeyboardWillShowObserver() {
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
    
    /// keyboardWillHideNotification을 처리하는 옵저버를 등록합니다.
    func addKeyboardWillHideObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
    }
    
}
