//
//  SetPasswordViewController.swift
//  SetPasswordViewController
//
//  Created by 안상희 on 2021/08/08.
//

import UIKit
import LocalAuthentication

class SetPasswordViewController: UIViewController {

    /// UI 업데이트 중에 사용할 수 있도록 클래스 범위에 저장된 인증 컨텍스트입니다.
    var context = LAContext()
    
    enum AuthenticationState {
        case locked
        case unlocked
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var setPasswordSwitch: UISwitch!
    

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
        }
    }
    
    
    @IBAction func changePasswordButtonDidTapped(_ sender: Any) {
        
    }
    
    
    @IBOutlet weak var touchIDSwitch: UISwitch!
    @IBAction func touchIDPasswordStatusChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("isONNNNN")
            context = LAContext()

            context.localizedCancelTitle = "Enter Username/Password"

            // First check if we have the needed hardware support.
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                    if success {
                        // FaceID 성공시
                        print("success")
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
//                            self.state = .loggedin
                        }

                    } else {
                        /// FaceID 허용하지 않고, 비밀번호 입력창으로 바뀌는데 사용자가 취소한 것.
                        print(error?.localizedDescription ?? "Failed to authenticate")

                        // Fall back to a asking for username and password.
                        // ...
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")

                // Fall back to a asking for username and password.
                // ...
            }
        } else {
            print("thisssss")
        }
    }
    
    
    @objc func process(notification: Notification) {
        /// 비밀번호가 설정되지 않았을 경우, 암호 잠금 스위치는 비활성화.
        setPasswordSwitch.isOn = false
    }
    
    @objc func completeProcess(notification: Notification) {
        /// 비밀번호가 설정되었을 경우, 암호 잠금 스위치는 활성화.
        setPasswordSwitch.isOn = true
        
        guard let password = notification.userInfo?["password"] as? String else {
                    return
        }
                
        dummyPassword = password
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.setViewTheme()
        
        touchIDSwitch.isEnabled = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(process(notification:)),
                                               name: Notification.Name.PasswordNotSet, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(completeProcess(notification:)),
                                               name: Notification.Name.PasswordDidSet, object: nil)
        
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
