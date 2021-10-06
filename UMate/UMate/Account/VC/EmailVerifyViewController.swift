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
class EmailVerificationViewController: AccountCommonThingsViewController {
    /// 보안코드 발송 버튼
    @IBOutlet weak var sendCodeButton: UIButton!
    
    /// 다음 화면 버튼
    @IBOutlet weak var emailVerificationButton: UIButton!
    
    /// 이메일  필드
    @IBOutlet weak var emailTextField: UITextField!
    
    /// 인증받은 코드를 입력하는 필드
    @IBOutlet weak var codeTextField: UITextField!
    
    
    /// 이메일 검증을 받기위해 코드를 전송합니다.
    /// 서버에서 코드를 전송
    /// - Parameter sender: sendCodeButton
    @IBAction func sendTheCode(_ sender: Any) {
        guard let email = emailTextField.text,
              isEmailValid(email),
              email.trimmingCharacters(in: .whitespacesAndNewlines)  != "" else {
                  alert(title: "알림", message: "잘못된 형식의 이메일입니다.")
                  return
              }
        
        
        // 이메일을 키체인 저장하고 액세스 레벨을 accessibleAfterFirstUnlock로 설정합니다.
        // 앱을 재시작하기 전까지 언락합니다.
        if keychain.set(email, forKey: Keys.userEmailKey, withAccess: .accessibleAfterFirstUnlock) {
            print("Succeed Set email")
        } else {
            print("Faild Set")
        }
    }
    
    
    /// 입력한 코드가 맞는지 검사
    /// - Parameter sender: emailVerificationButton
    @IBAction func checkToVerifiedCode(_ sender: Any) {
        guard let codeField = codeTextField.text, codeField == "12345678" else {
            alert(title: "알림", message: "잘못된 코드입니다.")
            return
        }
        
    }
    
    /// DetailRegisterViewController에 접근하여 verifiedEmail 속성에 이메일 데이타를 전달합니다.
    ///   - Parameters:
    ///   - segue: segue.destination속성을 타입캐스팅 하여 DetailRegisterViewController 접근
    ///   - sender: Any?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailRegisterViewController {
            vc.verifiedEmail = emailTextField.text
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 버튼에 공통 스타일 적용 합니다.
        [sendCodeButton, emailVerificationButton].forEach({
            $0?.setToEnabledButtonTheme()
        })
        
        [emailTextField, codeTextField].forEach {
            $0?.layer.cornerRadius = 16
            $0?.clipsToBounds = true
        }
        
        // 키보드 옵저버 등록 합니다.
        addKeyboardWillHideObserver()
        addKeyboardWillShowObserver()
        
        // 더미데이터 및 delegate 설정 합니다.
        codeTextField.delegate = self
        
        // 뷰를 탭하면 키보드 내립니다.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmailVerificationViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// 뷰를 탭할시 키보드가 내려갑니다.
    /// UITapGestureRecognizer 의 생성자 액션 파라미터 #selector로 쓰이는 메소드입니다.
    /// - Parameter sender: UITapGestureRecognizer 
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}



extension EmailVerificationViewController: UITextFieldDelegate {
    /// codeTextField 텍스트필드에 숫자를 제외한 다른 텍스트는 작성 불가합니다.
    /// - Parameters:
    ///   - textField: 텍스트 파일안에 있는 문자
    ///   - range: 대체될 텍스트 범위
    ///   - string: 타이핑시 대체되는 문자열
    /// - Returns: 리턴 트루시 텍스트를 입력가능 false일시 불가
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let codeField = codeTextField.text else { return false }
        let finalStr = NSString(string: codeField).replacingCharacters(in: range, with: string)
        let chartSet = CharacterSet(charactersIn: "0123456789").inverted
        
        guard let _ = finalStr.rangeOfCharacter(from: chartSet) else { return true }
        
        return false
    }
    
    
    /// 텍스트 필드가 편집이 시작될때 호출됩니다.
    /// - Parameter textField: 텍스트 필드 편집시 전달
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    
    /// 텍스트 필드가 편집이 끝나면 nil로 초기화 합니다.
    /// - Parameter textField: 텍스트 필드 편집이 끝날시 전달
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
}


/// 키보드 노티피케이션 확장자
/// Author: 황신택
extension EmailVerificationViewController {
    ///keyboardWillShowNotification을 처리하는 옵저버를 등록합니다.
    /// 키보드가 화면에 표시되기 직전에 키보드 높이만큼 Bottom 여백을 추가해서 UI와 겹치는 문제를 방지합니다.
    func addKeyboardWillShowObserver() {
        let token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] noti in
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
        
        tokens.append(token)
        
    }
    
    
    /// keyboardWillHideNotification을 처리하는 옵저버를 등록합니다.
    func addKeyboardWillHideObserver() {
        let token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
        
        tokens.append(token)
    }
    
}

