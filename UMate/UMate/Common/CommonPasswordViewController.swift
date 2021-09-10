//
//  CommonPasswordViewController.swift
//  CommonPasswordViewController
//
//  Created by 안상희 on 2021/09/09.
//

import UIKit
import KeychainSwift

class CommonPasswordViewController: PasswordRootViewController {

    
    /// PasswordNotCorrect Notification이 전달되면 실행되는 메소드입니다.
    /// - Parameter notifcation: Notification
    @objc func HandlePasswordNotCorrectNotification(notifcation: Notification) {
        DispatchQueue.main.async {
            self.passwordField.text = ""
            
            [self.firstContainerView, self.secondContainerView,
             self.thirdContainerView, self.fourthContainerView].forEach {
                $0?.backgroundColor = UIColor.white
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.becomeFirstResponder()
        
        password = keychain.get(Keys.appLockPasswordKey)
        print("CommonPasswordViewController \(password))")
        
        
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(HandlePasswordNotCorrectNotification(notifcation:)),
                         name: Notification.Name.PasswordNotCorrect,
                         object: nil)
    }

}



extension CommonPasswordViewController: UITextFieldDelegate {
    
    /// 지정된 텍스트를 변경할 것인지 delegate에게 묻는 메소드입니다.
    ///
    /// 비밀번호는 4자리로 제한합니다.
    ///
    /// - Parameters:
    ///   - textField: 텍스트를 포함하고 있는 TextField.
    ///   - range: 지정된 문자 범위입니다.
    ///   - string: 지정된 범위에 대한 대체 문자열입니다.
    /// - Returns: Bool
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)
        
        
        switch textField {
        case passwordField:
            // 숫자만 입력 가능하고, 숫자는 4자리로 제한합니다.
            if let _ = string.rangeOfCharacter(from: charSet) { return false }
            
            if finalText.count == 0 {
                firstContainerView.backgroundColor = UIColor.white
            } else if finalText.count == 1 {
                firstContainerView.backgroundColor = UIColor.black
                secondContainerView.backgroundColor = UIColor.white
            } else if finalText.count == 2 {
                secondContainerView.backgroundColor = UIColor.black
                thirdContainerView.backgroundColor = UIColor.white
            } else if finalText.count == 3 {
                thirdContainerView.backgroundColor = UIColor.black
                fourthContainerView.backgroundColor = UIColor.white
            } else if finalText.count == 4 {
                passwordCheck = finalText
                
                fourthContainerView.backgroundColor = UIColor.black
                
                
                guard password == passwordCheck else {
                    alert(message: "비밀번호가 일치하지 않습니다. 다시 시도하십시오.")
                    
                    /// 비밀번호가 일치하지 않을 때 사용하는 Notifcation.
                    /// MakingPasswordViewController에 옵저버 존재.
                    NotificationCenter.default.post(name: Notification.Name.PasswordNotCorrect,
                                                    object: nil)
                    return false
                }
                
                
                CommonViewController.shared.transitionToHome()
            }
            
        default:
            
            return true
        }
        return true
    }
}
