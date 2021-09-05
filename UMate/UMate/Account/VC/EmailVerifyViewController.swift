//
//  EmailVerifyViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/07/29.
//

import UIKit
import KeychainSwift

class EmailVerifyViewController: UIViewController {
    
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var emailVerificationButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    
    /// To handle specific TextField
    var activeTextField: UITextField? = nil
    var keyChain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// To check conditions for email
    /// - Parameter sender: sendCodeButton
    @IBAction func sendCodeButtonAction(_ sender: Any) {
        guard let email = emailTextField.text,
              isEmailValid(email),
              email.trimmingCharacters(in: .whitespacesAndNewlines)  != "" else {
                  alert(title: "알림", message: "잘못된 형식의 이메일입니다.")
                  return
              }
        
        if keyChain.set(email, forKey: Keys.userEmailKey, withAccess: .accessibleAfterFirstUnlock) {
            print("Succeed Set email")
        } else {
            print("Faild Set")
        }
    }
    
    
    /// Sending a Code to check user email
    /// - Parameter sender: emailVerificationButton
    @IBAction func emailVerificationButtonAction(_ sender: Any) {
        guard let codeField = codeTextField.text, codeField == "19930725" else {
            alert(title: "알림", message: "잘못된 코드입니다.")
            return
        }
        
    }
    
    
    
    ///  Since verified email be stored for next register step and then it can't be change.
    ///   - Parameters:
    ///   - segue: DetailRegisterViewController
    ///   - sender: Any?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailRegisterViewController {
            vc.verifiedEmail = emailTextField.text
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 버튼 모양 끝에 살짝 동그랗게
        [sendCodeButton, emailVerificationButton].forEach({
            $0?.setButtonTheme()
        })
        
        // 텍스트필드 뷰 깎기
        [emailTextField, codeTextField].forEach {
            $0?.layer.cornerRadius = 16
            $0?.clipsToBounds = true
        }
        
        // 키보드 노티피케이션 호출
        addKeyboardWillHide()
        addKeyboardWillShow()
        
        // 더미데이터 및 delegate선언
        codeTextField.delegate = self
        codeTextField.text = "19930725"
        emailTextField.text = "qwer123@gmail.com"
        
        // 백그라운드 탭시 키보드 아래로.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // regular expression으로 검증하는 메소드
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        
        return false
    }
    
    // 키보드 탭시 일어나는 이벤트를 전달
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension EmailVerifyViewController: UITextFieldDelegate {
    
    /// codeTextField 텍스트필드에 숫자를 제외한 다른 텍스트는 작성 불가
    /// - Parameters:
    ///   - textField: UITextField
    ///   - range: NSRange
    ///   - string: String
    /// - Returns: 리턴 트루시 텍스트를 입력가능 false일시 불가
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let codeField = codeTextField.text else { return false }
        let finalStr = NSString(string: codeField).replacingCharacters(in: range, with: string)
        let chartSet = CharacterSet(charactersIn: "0123456789").inverted
        
        guard let _ = finalStr.rangeOfCharacter(from: chartSet) else { return true }
        
        return false
    }
    
    /// 특정 텍스트필드에 값이 입력될시 키보드가 텍스트필드를 가려질 경우를 만들기위한 메소드.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    /// 특정 텍스트필드에 입력이 끝났을시 키보드가 텍스트필드를 가려질 경우를 만들기위한 메소드.
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
}

extension EmailVerifyViewController {
    
    /// 텍스트필드에 키보드가 맞닿을경우 해당 메소드가 실행됨
    func addKeyboardWillShow() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] noti in
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
        
    }
    
    
    /// 키보드 내리는 메소드
    func addKeyboardWillHide() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
    }
  
}
