//
//  CommonPasswordViewController.swift
//  CommonPasswordViewController
//
//  Created by 안상희 on 2021/09/09.
//

import KeychainSwift
import UIKit


/// 공통적으로 사용되는 비밀번호 입력 화면 ViewController 클래스
///
/// PasswordRootViewController 클래스를 상속하며, 암호 잠금 화면이 나올 때 사용됩니다.
/// - Author: 안상희
class CommonPasswordViewController: PasswordRootViewController {
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// 옵저버를 등록합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.becomeFirstResponder()
        password = keychain.get(Keys.appLockPasswordKey)
        
        #if DEBUG
        print("CommonPasswordViewController \(password ?? "NO PASSWORD"))")
        #endif
        
        
        // PasswordNotCorrect Notification이 전달되면 실행됩니다.
        let token = NotificationCenter.default.addObserver(forName: .PasswordNotCorrect,
                                                           object: nil,
                                                           queue: .main) { _ in
            self.passwordField.text = ""
            
            [self.firstPasswordImageView, self.secondPasswordImageView,
             self.thirdPasswordImageView, self.fourthPasswordImageView].forEach {
                $0?.image = UIImage(named: "line")
            }
        }
        tokens.append(token)
    }
}



extension CommonPasswordViewController: UITextFieldDelegate {
    /// 사용자가 입력하는 비밀번호를 확인합니다. 입력은 숫자 4개로 제한합니다.
    ///
    /// - Parameters:
    ///   - textField: 텍스트를 포함하고 있는 TextField
    ///   - range: 지정된 문자 범위
    ///   - string: 지정된 범위에 대한 대체 문자열
    /// - Returns: 지정된 텍스트를 변경할 경우 true, 아니라면 false를 리턴합니다.
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
                firstPasswordImageView.image = UIImage(named: "line")
            } else if finalText.count == 1 {
                firstPasswordImageView.image = UIImage(named: "lock")
                secondPasswordImageView.image = UIImage(named: "line")
            } else if finalText.count == 2 {
                secondPasswordImageView.image = UIImage(named: "lock")
                thirdPasswordImageView.image = UIImage(named: "line")
            } else if finalText.count == 3 {
                thirdPasswordImageView.image = UIImage(named: "lock")
                fourthPasswordImageView.image = UIImage(named: "line")
            } else if finalText.count == 4 {
                passwordCheck = finalText
                
                fourthPasswordImageView.image = UIImage(named: "lock")
                
                guard password == passwordCheck else {
                    alert(message: "비밀번호가 일치하지 않습니다. 다시 시도하십시오.")
                    
                    // 비밀번호가 일치하지 않을 때 사용하는 Notifcation
                    // MakingPasswordViewController에 옵저버가 존재합니다.
                    NotificationCenter.default.post(name: Notification.Name.PasswordNotCorrect,
                                                    object: nil)
                    return false
                }
                CommonViewController.transitionToHome()
            }
        default:
            return true
        }
        return true
    }
}
