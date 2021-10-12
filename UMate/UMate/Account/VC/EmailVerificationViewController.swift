//
//  EmailVerifyViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/07/29.
//

import UIKit
import KeychainSwift

/// 이메일 인증 화면
/// Author: 황신택 (sinadsl1457@gmail.com)
class EmailVerificationViewController: CommonViewController {
    /// 보안코드 발송 버튼
    @IBOutlet weak var sendCodeButton: UIButton!
    
    /// 다음 화면 버튼
    @IBOutlet weak var emailVerificationButton: UIButton!
    
    /// 이메일 필드
    @IBOutlet weak var emailTextField: UITextField!
    
    /// 보안코드 입력 필드
    @IBOutlet weak var codeTextField: UITextField!
    
    
    /// 이메일 검증을 위한 보안코드를 요청합니다.
    /// - Parameter sender: sendCodeButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func sendTheCode(_ sender: Any) {
        guard let email = emailTextField.text,
              isEmailValid(email),
              email.trimmingCharacters(in: .whitespacesAndNewlines)  != "" else {
                  alert(title: "알림", message: "잘못된 형식의 이메일입니다.")
                  return
              }
        
        // 이메일을 키체인 저장하고 액세스 레벨을 accessibleAfterFirstUnlock로 설정합니다.
        // 앱을 재시작하기 전까지 언락 합니다.
        if keychainPrefix.set(email, forKey: Keys.userEmailKey, withAccess: .accessibleAfterFirstUnlock) {
            print("Succeed Set email")
        } else {
            print("Faild Set")
        }
    }
    
    
    /// 입력한 코드가 맞는지 검사합니다.
    /// - Parameter sender: emailVerificationButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func checkToVerifiedCode(_ sender: Any) {
        guard let codeField = codeTextField.text, codeField == "12345678" else {
            alert(title: "알림", message: "잘못된 코드입니다.")
            return
        }
    }
    

    /// 다음 화면으로 전환되기 전에 호출됩니다.
    /// 다음 화면으로 입력된 이메일 주소를 전달합니다.
    /// - Parameters:
    ///   - segue: 실행된 segue
    ///   - sender: segue를 실행한 객체
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailRegisterViewController {
            vc.verifiedEmail = emailTextField.text
        }
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        [sendCodeButton, emailVerificationButton].forEach({
            $0?.setToEnabledButtonTheme()
        })
        
        [emailTextField, codeTextField].forEach {
            $0?.layer.cornerRadius = 16
            $0?.clipsToBounds = true
        }
        
        addKeyboardWillHideObserver()
        addKeyboardWillShowObserver()
        
        codeTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmailVerificationViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    /// 뷰를 탭하면 키보드를 내립니다.
    /// 뷰 전체가 탭 영역입니다.
    /// - Parameter sender: UITapGestureRecognizer
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}



extension EmailVerificationViewController: UITextFieldDelegate {
    /// 내용을 편집할 때마다 반복적으로 호출됩니다.
    /// 숫자를 제외한 나머지 문자를 제한합니다.
    /// - Parameters:
    ///   - textField: 이메일 텍스트필드
    ///   - range: 교체될 문자열의 범위
    ///   - string: 입력된 문자 또는 문자열
    /// - Returns: true를 리턴하면 편집된 내용을 반영하고, false를 리턴하면 무시합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let codeField = codeTextField.text else { return false }
        let finalStr = NSString(string: codeField).replacingCharacters(in: range, with: string)
        let chartSet = CharacterSet(charactersIn: "0123456789").inverted
        
        guard let _ = finalStr.rangeOfCharacter(from: chartSet) else { return true }
        return false
    }
    
    
    /// 텍스트 필드에서 편집이 시작될 때 호출됩니다
    /// - Parameter textField: 편집이 시작된 텍스트 필드
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activatedTextField = textField
    }
    
    
    /// 텍스트 필드에서 편집이 끝나면 호출됩니다.
    /// - Parameter textField: 편집이 끝난 텍스트 필드
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func textFieldDidEndEditing(_ textField: UITextField) {
        activatedTextField = nil
    }
}



/// 키보드 노티피케이션 익스텐션
/// - Author: 황신택 (sinadsl1457@gmail.com)
extension EmailVerificationViewController {
    /// keyboardWillShowNotification을 처리하는 옵저버를 등록합니다.
    /// 키보드가 화면에 표시되기 직전에 키보드 높이만큼 아래 여백을 추가해서 UI와 겹치는 문제를 방지합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func addKeyboardWillShowObserver() {
        let token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return  }
            guard let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            var shouldMoveViewUp = false
            
            if let activeTextField = strongSelf.activatedTextField {
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
        tokens.append(token)
    }
    
    
    /// keyboardWillHideNotification을 처리하는 옵저버를 등록합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func addKeyboardWillHideObserver() {
        let token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
        tokens.append(token)
    }
}

