//
//  ChangeAppPasswordViewController.swift
//  ChangeAppPasswordViewController
//
//  Created by 안상희 on 2021/08/10.
//

import KeychainSwift
import UIKit


/// 사용자 계정 설정의 비밀번호 변경 화면 ViewController 클래스
///
/// 비밀번호를 변경합니다.
/// - Author: 안상희
class ChangeAppPasswordViewController: PasswordRootViewController {
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행하고, Notification Observer를 등록합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.becomeFirstResponder()
        
        var token = NotificationCenter.default.addObserver(forName: .PasswordNotCorrect,
                                                           object: nil,
                                                           queue: .main) { [weak self] _ in
            self?.passwordField.text = ""
            
            [self?.firstPasswordImageView, self?.secondPasswordImageView,
             self?.thirdPasswordImageView, self?.fourthPasswordImageView].forEach {
                $0?.image = UIImage(named: "line")
            }
        }
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: .PasswordIsSame,
                                                       object: nil,
                                                       queue: .main) { [weak self] _ in
            self?.checkPasswordField.text = ""
            
            [self?.firstPasswordImageView, self?.secondPasswordImageView,
             self?.thirdPasswordImageView, self?.fourthPasswordImageView].forEach {
                $0?.image = UIImage(named: "line")
            }
        }
        tokens.append(token)
        
        
        // 이미 설정된 비밀번호를 가져옵니다.
        password = keychain.get(Keys.appLockPasswordKey)
        #if DEBUG
        print("ChangeAppPassword pasword \(password))")
        #endif
    }
}



extension ChangeAppPasswordViewController: UITextFieldDelegate {
    /// 지정된 텍스트를 변경할 것인지 delegate에게 묻는 메소드입니다.
    ///
    /// 비밀번호는 4자리로 제한합니다.
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
                
                fourthPasswordImageView.image = UIImage(named: "line")
                
                guard password == passwordCheck else {
                    alert(message: "비밀번호가 일치하지 않습니다. 다시 시도하십시오.")
                    
                    // 비밀번호가 일치하지 않을 때 사용하는 Notifcation
                    // MakingPasswordViewController에 옵저버가 존재합니다.
                    NotificationCenter.default.post(name: Notification.Name.PasswordNotCorrect,
                                                    object: nil)
                    return false
                }
                
                navigationItem.title = "비밀번호 변경"
                [firstPasswordImageView, secondPasswordImageView,
                 thirdPasswordImageView, fourthPasswordImageView].forEach {
                    $0?.image = UIImage(named: "line")
                }
                checkPasswordField.becomeFirstResponder()
            }
        default:
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
                fourthPasswordImageView.image = UIImage(named: "lock")
                passwordCheck = finalText
                
                guard password != passwordCheck else {
                    alert(message: "이전 비밀번호와 동일한 비밀번호입니다. 다른 비밀번호를 설정해주세요.")
                    
                    // 비밀번호가 일치하지 않을 때 사용하는 Notifcation
                    NotificationCenter.default.post(name: Notification.Name.PasswordIsSame,
                                                    object: nil)
                    return false
                }
                
                keychain.delete(Keys.appLockPasswordKey)
                
                guard let changedPassword = passwordCheck else { return false }
                
                keychain.set(changedPassword,
                             forKey: Keys.appLockPasswordKey,
                             withAccess: .accessibleWhenUnlocked)
                
                alert(message: "비밀번호가 변경되었습니다.")
                
                // 비밀번호 설정이 최종적으로 완료되면 보내는 Notification
                // SetPasswordViewController에 옵저버가 존재합니다.
                NotificationCenter.default.post(name: Notification.Name.PasswordDidSet,
                                                object: nil,
                                                userInfo: ["password": passwordCheck])
                
                // navigationController를 자동으로 pop합니다.
                let completion = {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                guard let coordinator = transitionCoordinator else {
                    completion()
                    return false
                }
                
                coordinator.animate(alongsideTransition: nil) { _ in
                    completion()
                }
            }
            return true
        }
        return true
    }
}
