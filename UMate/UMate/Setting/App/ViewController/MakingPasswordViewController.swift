//
//  MakingPasswordViewController.swift
//  MakingPasswordViewController
//
//  Created by 안상희 on 2021/08/08.
//

import KeychainSwift
import UIKit


/// 사용자 계정 설정의 비밀번호 생성 화면 ViewController 클래스.
///
/// 비밀번호를 생성합니다.
/// - Author: 안상희
class MakingPasswordViewController: PasswordRootViewController {
    /// 비밀번호가 설정되었는지 파악하기 위한 속성.
    var isPasswordSet: Bool?
    
    /// 노티피케이션 제거를 위해 토큰을 담는 배열.
    var tokens = [NSObjectProtocol]()
    
    /// NSObjectProtocol를 리턴하는 속성. Notification에 이용합니다.
    var token: NSObjectProtocol?
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행하고, Notification Observer를 등록합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyPrefix로 전달된 값을 통해 KeychainSwift 객체를 초기화하기 위한 속성.생체인증을 위한 키체인입니다.
        let keychainPassword = keychain.get(Keys.appLockPasswordKey)
        
        token = NotificationCenter.default.addObserver(forName: .PasswordNotCorrect,
                                                       object: nil,
                                                       queue: .main) { [weak self] noti in
            self?.checkPasswordField.text = ""
            
            [self?.firstPasswordImageView, self?.secondPasswordImageView,
             self?.thirdPasswordImageView, self?.fourthPasswordImageView].forEach {
                $0?.image = UIImage(named: "line")
            }
        }
        
        #if DEBUG
        print("ispassword Set \(isPasswordSet!)")
        #endif
        
        if isPasswordSet! {
            // 비밀번호가 설정되어있을 경우, 비밀번호를 키체인에서 가져옵니다.
            // 설정된 비밀번호를 입력받도록 합니다.
            #if DEBUG
            print("password already set")
            #endif
            checkPasswordField.becomeFirstResponder()
            password = keychainPassword
        } else {
            // 비밀번호가 설정되어있지 않을 경우, 생성할 비밀번호를 입력받도록 합니다.
            #if DEBUG
            print("password not set")
            #endif
            passwordField.becomeFirstResponder()
        }
    }
    
    
    /// 소멸자에서 Observer를 제거합니다.
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}




extension MakingPasswordViewController: UITextFieldDelegate {
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
            // 비밀번호가 설정되어있지 않을 경우, 비밀번호를 생성합니다.
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
                password = finalText
                
                fourthPasswordImageView.image = UIImage(named: "lock")
                
                // 4자리 비밀번호를 입력하면 비밀번호를 다시 입력하도록 합니다.
                navigationItem.title = "비밀번호 확인"
                
                [firstPasswordImageView, secondPasswordImageView,
                 thirdPasswordImageView, fourthPasswordImageView].forEach {
                    $0?.image = UIImage(named: "line")
                }
                
                checkPasswordField.becomeFirstResponder()
            }
        case checkPasswordField:
            // 비밀번호가 설정되어있을 경우는 암호 잠금을 해제하기 위한 것이므로
            // 비밀번호 한번만 입력받아서 기존의 비밀번호와 확인하고 키체인의 비밀번호 정보를 제거합니다.
            if isPasswordSet! {
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
                              
                        // 비밀번호가 일치하지 않을 때 사용하는 Notifcation.
                        NotificationCenter.default.post(name: Notification.Name.PasswordNotCorrect,
                                                        object: nil)
                        return false
                    }
                    
                    alert(message: "비밀번호 잠금이 해제되었습니다.")
                    
                    // 키체인에서 비밀번호를 제거합니다.
                    keychain.delete(Keys.appLockPasswordKey)
                    
                    /// 비밀번호 설정이 취소되면 보내는 Notification. SetPasswordViewController에 옵저버 존재.
                    NotificationCenter.default.post(name: Notification.Name.PasswordNotUse,
                                                    object: nil)
                    
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
            } else {
                // 비밀번호가 설정되어있을 경우, 비밀번호 한번만 입력받도록 합니다.
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
                              
                        /// 비밀번호가 일치하지 않을 때 사용하는 Notifcation.
                        /// MakingPasswordViewController에 옵저버 존재.
                        NotificationCenter.default.post(name: Notification.Name.PasswordNotCorrect,
                                                        object: nil)
                        return false
                    }
                    
                    guard let finalPassword = password else { return false }
                    
                    if keychain.set(finalPassword,
                                    forKey: Keys.appLockPasswordKey,
                                    withAccess: .accessibleWhenUnlocked) {
                        #if DEBUG
                        print("App Lock Password Set")
                        #endif
                    } else {
                        #if DEBUG
                        print("App Lock Password Fail")
                        #endif
                    }
                    
                    alert(message: "비밀번호가 설정되었습니다.")
                    
                    // 비밀번호 설정이 최종적으로 완료되면 보내는 Notification.
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
            }
        default:
            return true
        }
        return true
    }
}



extension NSNotification.Name {
    /// 비밀번호가 설정되다가 사용자에 의해 또는 크래시로 인해 중간에 중단되었을 때 전달되는 노티피케이션
    static let PasswordNotSet = NSNotification.Name("PasswordNotSetNotification")
    
    /// 비밀번호가 처음으로 모두 입력되었을 때 전달되는 노티피케이션
    static let PasswordDidEntered = NSNotification.Name("PasswordDidEnteredNotification")
    
    /// 비밀번호가 제대로 설정되었을 때 전달되는 노티피케이션
    static let PasswordDidSet = NSNotification.Name("PasswordDidSetNotification")
    
    /// 비밀번호 확인 입력 시, 이전 비밀번호와 일치하지 않을 때 전달되는 노티피케이션
    static let PasswordNotCorrect = NSNotification.Name("PasswordNotCorrectNotification")
    
    /// 비밀번호 변경 시, 이전 비밀번호와 동일한 비밀번호로 설정할 때 전달되는 노티피케이션
    static let PasswordIsSame = NSNotification.Name("PasswordIsSameNotification")
    
    /// 비밀번호 잠금 설정 취소 시 전달되는 노티피케이션
    static let PasswordNotUse = NSNotification.Name("PasswordNotUseNotification")
}
