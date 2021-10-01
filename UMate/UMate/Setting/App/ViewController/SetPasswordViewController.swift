//
//  SetPasswordViewController.swift
//  SetPasswordViewController
//
//  Created by 안상희 on 2021/08/08.
//

import KeychainSwift
import LocalAuthentication
import UIKit


/// 사용자 계정 설정의 암호 잠금 메뉴 화면 ViewController 클래스
///
/// 암호 잠금과 관련된 작업을 수행할 수 있습니다.
/// - Author: 안상희
class SetPasswordViewController: RemoveObserverViewController {
    /// keyPrefix로 전달된 값을 통해 KeychainSwift 객체를 초기화하기 위한 속성. 생체인증을 위한 키체인입니다.
    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
    
    /// UI 업데이트 중에 사용할 수 있도록 클래스 범위에 저장된 인증 컨텍스트
    var context = LAContext()
    
    
    /// 암호 잠금 메뉴들을 표시하는 UIView
    @IBOutlet weak var containerView: UIView!
    
    /// 암호 잠금 설정하는 UISwitch
    @IBOutlet weak var setPasswordSwitch: UISwitch!
    
    /// 암호 변경 UIButton. 암호 잠금이 설정되었을 때만 활성화됩니다.
    @IBOutlet weak var changePasswordButton: UIButton!
    
    /// Touch ID / Face ID 설정하는 UISwitch. 암호 잠금이 설정되었을 때만 활성화됩니다.
    @IBOutlet weak var touchIDSwitch: UISwitch!
    
    
    /// 암호 잠금 스위치 값이 변경되면 호출됩니다.
    /// - Parameter sender: 암호 잠금 설정하는 스위치
    @IBAction func setPasswordStatusChanged(_ sender: UISwitch) {
        // 암호 잠금이 활성화된 상태
        if sender.isOn {
            // 암호 잠금이 활성화되면 Touch ID / Face ID 스위치가 활성화됩니다.
            touchIDSwitch.isEnabled = true
        } else {
            // 암호 잠금이 비활성화된 상태
            // 암호 잠금이 비활성화되면 Touch ID 스위치가 비활성화됩니다.
            // Touch ID가 이미 활성화된 상태인 경우, 비활성화 상태로 변경됩니다.
            touchIDSwitch.isOn = false
            touchIDSwitch.isEnabled = false
            changePasswordButton.isEnabled = false
        }
    }
    
    
    /// Touch ID / Face ID 스위치 값이 변경되면 호출됩니다.
    /// - Parameter sender: 생체 인증 설정하는 스위치
    @IBAction func touchIDPasswordStatusChanged(_ sender: UISwitch) {
        // 스위치가 on 상태라면 아래의 작업을 수행합니다.
        if sender.isOn {
            context = LAContext()
            
            // 취소 버튼을 누르면 Touch ID / Face ID 작업이 취소됩니다.
            context.localizedCancelTitle = "취소"
            
            var error: NSError?
            // 인증을 시도하기 전에, 먼저 canEvaluatePolicy 메소드를 통해 실제로 인증이 가능한지 체크합니다.
            // 만약 생체 인식에 실패하거나, 사용할 수 없을 경우 암호를 입력하도록 합니다.
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                #if DEBUG
                print("111111111")
                #endif
                
                let reason = "앱 잠금을 해제합니다."
                
                // TouchID/FaceID로 인증할 준비가 될 경우
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                    success, error in
                    if success {
                        // TouchID/FaceID 암호 입력 성공하면 bioKeychain에 저장해줍니다.
                        #if DEBUG
                        print("face id success")
                        #endif
                        
                        let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
                        
                        if bioKeychain.set(true,
                                           forKey: Keys.bioLockPasswordKey,
                                           withAccess: .accessibleWhenUnlocked) {
                            #if DEBUG
                            print("bio password set")
                            #endif
                        } else {
                            // 생체 인증에 실패한 경우
                            #if DEBUG
                            print("bio password fail")
                            #endif
                            
                            DispatchQueue.main.async {
                                self.touchIDSwitch.isOn = false
                                self.alert(message: "생체 인증에 실패하였습니다.")
                            }
                        }
                    } else {
                        // TouchID/FaceID 창은 떴지만, 사용자가 생체 인증을 취소한 경우입니다.
                        // 비밀번호 입력창으로 바뀝니다.
                        #if DEBUG
                        print("face id 취소한것. face id 창이 떴는데 사용자가 취소한것.")
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        #endif
                        
                        DispatchQueue.main.async {
                            self.touchIDSwitch.isOn = false
                            self.alert(message: "생체 암호 잠금 설정이 취소되었습니다.")
                        }
                    }
                }
            } else {
                #if DEBUG
                print("222222222222")
                print(error?.localizedDescription ?? "Can't evaluate policy")
                print("face id not set")
                #endif
                
                DispatchQueue.main.async {
                    self.touchIDSwitch.isOn = false
                    self.alert(message: "생체 인증에 실패하였습니다.")
                }
            }
        } else {
            #if DEBUG
            print("333333333")
            #endif
            
            // 스위치가 off 상태라면 생체인증 정보를 키체인에서 제거합니다.
            bioKeychain.delete(Keys.bioLockPasswordKey)
            touchIDSwitch.isOn = false
            alert(message: "생체 암호 잠금 설정이 해제되었습니다.")
        }
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행하고, Notification Observer를 등록합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.setViewTheme()
        
        setPasswordSwitch.isOn = true
        changePasswordButton.isEnabled = false
        
        
        // 비밀번호가 설정되지 않았을 때, 암호 변경 버튼과 암호 잠금 스위치는 비활성화합니다.
        var token = NotificationCenter.default.addObserver(forName: .PasswordNotSet,
                                                           object: nil,
                                                           queue: .main) { [weak self] _ in
            self?.setPasswordSwitch.isOn = false
            self?.changePasswordButton.isEnabled = false
        }
        tokens.append(token)

        // 비밀번호가 설정되었을 경우, 암호 변경 버튼과 암호 잠금 스위치를 활성화합니다.
        token = NotificationCenter.default.addObserver(forName: .PasswordDidSet,
                                                           object: nil,
                                                           queue: .main) { [weak self] noti in
            self?.setPasswordSwitch.isOn = true
            self?.changePasswordButton.isEnabled = true
            
            guard let _ = noti.userInfo?["password"] as? String else {
                return
            }
        }
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: .PasswordNotUse,
                                                       object: nil,
                                                       queue: .main) { _ in }
        tokens.append(token)
        
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
        
        // 암호가 이미 설정되어있는지 체크하기 위한 상수들
        let keychain = KeychainSwift(keyPrefix: Keys.appLockPasswordKey)
        let isPasswordSet = keychain.get(Keys.appLockPasswordKey)
        let bioPasswordSet = bioKeychain.getBool(Keys.bioLockPasswordKey)

        
        #if DEBUG
        print("bioPasswordDidSet \(bioPasswordSet ?? false)")
        #endif
        
        
        // 암호가 설정되어있지 않다면 암호 변경 버튼, TouchID/FaceID 스위치를 비활성화합니다.
        guard let _ = isPasswordSet else {
            setPasswordSwitch.isOn = false
            changePasswordButton.isEnabled = false
            touchIDSwitch.isEnabled = false
            return
        }
        
        // 암호 잠금 스위치에 따라 작업을 분기합니다.
        if setPasswordSwitch.isOn {
            // 암호 잠금 스위치가 on일 경우,
            // 암호 변경 버튼과 TouchID/FaceID 사용 스위치를 활성화시킵니다.
            touchIDSwitch.isEnabled = true
            changePasswordButton.isEnabled = true
        } else {
            // 암호 잠금 스위치가 off일 경우,
            // 암호 변경 버튼과 TouchID/FaceID 사용 스위치를 비활성화시킵니다.
            touchIDSwitch.isEnabled = false
            changePasswordButton.isEnabled = false
        }
        
        // bioPasswordSet 값이 true가 아니라면 TouchID/FaceID 스위치는 비활성화합니다.
        guard let bioPasswordSet = bioPasswordSet, bioPasswordSet == true else {
            touchIDSwitch.isOn = false
            return
        }
        
        // 앞에서 리턴되지 않았다면 생체인증이 설정된 것입니다.
        touchIDSwitch.isOn = true
    }

    
    /// 암호 잠금 스위치의 상태가 변경되면, 비밀번호 설정 화면으로 넘어가기 전에 호출됩니다.
    /// - Parameters:
    ///   - segue: 뷰컨트롤러에 포함된 segue에 대한 정보를 갖는 객체
    ///   - sender: 암호 잠금 설정하는 스위치
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MakingPasswordViewController {
            // Switch의 상태에 따라 작업을 분기합니다.
            if setPasswordSwitch.isOn {
                // 암호 잠금 스위치가 on으로 변경된 상태일 경우, 암호가 아직 설정되지 않은 상태이므로 false
                vc.isPasswordSet = false
            } else {
                // 암호 잠금 스위치가 off로 변경된 상태일 경우, 암호가 아직 설정된 상태이므로 true
                vc.isPasswordSet = true
            }
        }
    }
}



extension Notification.Name {
    /// 앱 암호 잠금이 해제되었을 경우 전달되는 노티피케이션
    static let PasswordDidCancel = NSNotification.Name("PasswordDidCancelNotification")
}
