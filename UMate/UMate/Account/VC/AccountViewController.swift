//
//  AccountViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import KeychainSwift

/// 로그인 화면을 구성하는 클래스.  
/// Author: 황신택
class AccountViewController: UIViewController {
    /// 아이디 텍스트필드
    @IBOutlet weak var idTextField: UITextField!
                                
    /// 비밀번호 텍스트 필드
    @IBOutlet weak var passwordTextField: UITextField!
    
    /// 로그인 버튼
    @IBOutlet weak var loginButton: UIButton!
    
    /// 회원가입 버튼
    @IBOutlet weak var registerButton: UIButton!
    
    /// 키체인 계정을 가져오기 위한 인스턴스를 생성.
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// 특정 텍스트필드에 조건을 줘야하기 때문에 속성을 추가.
    var activeTextField: UITextField? = nil
    
    
    
    /// 로그인시 키체인 계정을 체크합니다. 성공시 홈화면으로 이동.
    /// - Parameter sender: 로그인 버튼
    @IBAction func login(_ sender: Any) {
       /*
         MARK: 협업을 하기위해서 잠시 주석처리.
        // 키체인에 저장되어있는 이메일 데이타를 바인딩 합니다
        guard let safeEmail = keychain.get(Keys.userEmailKey),
        // 키체인에 저장되어있는 비밀번호 데이타를 바인딩 합니다.
              let safePassword = keychain.get(Keys.passwordKey),
              let email = idTextField.text,
              let password = passwordTextField.text else { return }

        // 키체인에 저장된 데이타를 가져오는데 문제가 에러가 있다면 에러코드를 전달합니다.
        if keychain.lastResultCode != noErr { print(keychain.lastResultCode) }

        // 키체인에 저장된 이메일, 비밀번호를 확인하고 아니라면 경고를 출력합니다.
        guard email == safeEmail && password == safePassword else {
            alert(title: "알림", message: "형식에 맞지않거나 존재하지않는 계정입니다", handler: nil)
            return
        }
        
        */
        CommonViewController.shared.transitionToHome()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 키보드 메소드르 호출합니다.
        KeyboardWillShow()
        KeyboardWillHide()
        
        /// 버튼에 공통 스타일 적용.
        loginButton.setButtonTheme()
        
        /// 작업하기 편하게 미리 저장된 키체인 계정으로 초기화합니다.
       idTextField.text = keychain.get(Keys.userEmailKey)
       passwordTextField.text = keychain.get(Keys.passwordKey)
        
        /// 뷰를 탭하면 키보드가 내려갑니다.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        /// 회원가입 버튼 다크모드 라이트모드를 지원합니다.
        registerButton.setTitleColor(UIColor.dynamicColor(light: .darkGray, dark: .white), for: .normal)
        
        
    }
    
    
    /// 뷰를 탭할시 키보드 내려감.
    /// - Parameter sender: UITapGestureRecognizer
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}



/// 키보드 노티피케이션 확장자
/// Author: 황신택
extension AccountViewController {
    ///키보드가 텍스트필드를 가리게 되면 뷰가 위로 올라가게 만들어 줍니다.   
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
