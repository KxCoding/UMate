//
//  AccountViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import KeychainSwift

/// 로그인 화면을 구성하는 클래스.
/// 키체인에 저장된 아이디 비밀번호를 로그인시 확인.
class AccountViewController: UIViewController {
    
    /// 로그인화면을 구성하는 아울렛
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    /// 키체인 계정을 가져오기 위한 인스턴스를 생성.
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// 특정 텍스트필드에 조건을 줘야하기 때문에 속성을 추가.
    var activeTextField: UITextField? = nil
    
    /// 로그인시 키체인 계정을 체크합니다. 성공시 홈화면으로 이동.
    /// 협업을 하기위해서 잠시 주석처리.
    /// - Parameter sender: 로그인 버튼
    @IBAction func login(_ sender: Any) {
       /*
        guard let safeEmail = keychain.get(Keys.userEmailKey),
              let safePassword = keychain.get(Keys.passwordKey),
              let email = idTextField.text,
              let password = passwordTextField.text else { return }

         To show if have some keychin error
        if keychain.lastResultCode != noErr { print(keychain.lastResultCode) }

        guard email == safeEmail && password == safePassword else {
            alert(title: "알림", message: "형식에 맞지않거나 존재하지않는 계정입니다", handler: nil)
            return
        }
        */

        CommonViewController.transitionToHome()
     
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 키보드 메소드르 호출함.
        KeyboardWillShow()
        KeyboardWillHide()
        
        /// 규격해 놓은 버튼 모양으로 만듬.
        loginButton.setButtonTheme()
        
        /// 텍스트필드 델리게이트 지정
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        /// 작업하기 편하게 미리 저장된 키체인 계정으로 초기화함.
       idTextField.text = keychain.get(Keys.userEmailKey)
       passwordTextField.text = keychain.get(Keys.passwordKey)
        
        /// 뷰를 탭하면 키보드가 내려감.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        registerButton.setTitleColor(UIColor.dynamicColor(light: .darkGray, dark: .white), for: .normal)
        
    }
    
    
}


extension AccountViewController: UITextFieldDelegate {
    /// 텍스트필드에 편집이 시작되면 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    /// 텍스트필드에 편집이 끝나면 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    
}


extension AccountViewController {
    /// 키보드가 텍스트필드를 덮는것을 피하기위한 메소드
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
    
    /// 키보드가 내려가게 하는 메소드
    func KeyboardWillHide() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
    }
    
}
