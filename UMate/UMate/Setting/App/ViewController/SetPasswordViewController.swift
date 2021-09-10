//
//  SetPasswordViewController.swift
//  SetPasswordViewController
//
//  Created by 안상희 on 2021/08/08.
//

import UIKit
import LocalAuthentication
import KeychainSwift

class SetPasswordViewController: UIViewController {

    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
    

    /// UI 업데이트 중에 사용할 수 있도록 클래스 범위에 저장된 인증 컨텍스트입니다.
    var context = LAContext()
    
    enum AuthenticationState {
        case locked
        case unlocked
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var setPasswordSwitch: UISwitch!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    /// 암호 잠금 스위치 값이 변경되면 호출됩니다.
    @IBAction func setPasswordStatusChanged(_ sender: UISwitch) {
        if sender.isOn { /// 암호 잠금이 활성화된 상태
            
            /// 암호 잠금이 활성화되면, TouchID 스위치 사용 가능
            touchIDSwitch.isEnabled = true
            
            
        } else { /// 암호 잠금이 비활성화된 상태
            
            /// 암호 잠금이 비활성화되면, TouchID 스위치 사용 불가.
            /// TouchID가 활성화된 상태인 경우, false로 변경
            touchIDSwitch.isOn = false
            touchIDSwitch.isEnabled = false
            changePasswordButton.isEnabled = false
        }
    }
    
    
    @IBAction func changePasswordButtonDidTapped(_ sender: Any) {
        
    }
    
    
    @IBOutlet weak var touchIDSwitch: UISwitch!
    @IBAction func touchIDPasswordStatusChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("isONNNNN")
            context = LAContext()

            context.localizedCancelTitle = "취소"

            // First check if we have the needed hardware support.
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) {
                    success, error in

                    if success {
                        // FaceID 성공시
                        print("face id success")
                        
                        
                        let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
                        
                        
                        
                        if bioKeychain.set(true,
                                           forKey: Keys.bioLockPasswordKey,
                                           withAccess: .accessibleWhenUnlocked) {
                            print("bio password set")
                        } else {
                            print("bio password fail")
                        }
                        

                    } else {
                        /// FaceID 허용하지 않고, 비밀번호 입력창으로 바뀌는데 사용자가 취소한 것.
                        print(error?.localizedDescription ?? "Failed to authenticate")
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")

                print("face id not set")
            }
        } else {
            bioKeychain.delete(Keys.bioLockPasswordKey)
        }
    }
    
    
    @objc func process(notification: Notification) {
        /// 비밀번호가 설정되지 않았을 경우, 암호 잠금 스위치는 비활성화.
        setPasswordSwitch.isOn = false
        changePasswordButton.isEnabled = false
    }
    
    @objc func completeProcess(notification: Notification) {
        /// 비밀번호가 설정되었을 경우, 암호 잠금 스위치는 활성화.
        setPasswordSwitch.isOn = true
        changePasswordButton.isEnabled = true
        
        guard let password = notification.userInfo?["password"] as? String else {
                    return
        }
            
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.setViewTheme()
        
        setPasswordSwitch.isOn = true
        changePasswordButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(process(notification:)),
                                               name: Notification.Name.PasswordNotSet, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(completeProcess(notification:)),
                                               name: Notification.Name.PasswordDidSet, object: nil)
        
        NotificationCenter.default.addObserver(forName: .PasswordNotUse,
                                               object: nil,
                                               queue: OperationQueue.main) { (noti) in
        }
        
        
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
        
        
        // 암호가 이미 설정되어있는지 체크
        let keychain = KeychainSwift(keyPrefix: Keys.appLockPasswordKey)
        let isPasswordSet = keychain.get(Keys.appLockPasswordKey)
        let bioPasswordSet = bioKeychain.getBool(Keys.bioLockPasswordKey)

        print("bioooooo \(bioPasswordSet)")
        
        
        guard let isPasswordSet = isPasswordSet else { // 암호가 설정되어있지 않다면 아래 코드는 실행 x
            setPasswordSwitch.isOn = false
            changePasswordButton.isEnabled = false
            return
        }
        
        
        // 암호 설정 스위치에 따라 분기
        if setPasswordSwitch.isOn {
            touchIDSwitch.isEnabled = true
            changePasswordButton.isEnabled = true
        } else {
            touchIDSwitch.isEnabled = false
            changePasswordButton.isEnabled = false
        }
        
        
        guard let bioPasswordSet = bioPasswordSet, bioPasswordSet == true else {
            touchIDSwitch.isOn = false
            return
        }
        
        touchIDSwitch.isOn = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MakingPasswordViewController {
            if setPasswordSwitch.isOn { // password가 설정되지 않은 상태
                vc.isPasswordSet = false
            } else { // password가 설정된 상태
                vc.isPasswordSet = true
            }
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}





extension Notification.Name {
    /// 앱 암호 잠금이 해제되었을 경우 사용되는 타입
    static let PasswordDidCancel = NSNotification.Name("PasswordDidCancelNotification")
}
