//
//  EmptyViewController.swift
//  EmptyViewController
//
//  Created by 안상희 on 2021/09/10.
//

import KeychainSwift
import LocalAuthentication
import UIKit


/// 아무것도 없는 빈 화면 ViewController 클래스. Touch ID/Face ID 작업을 처리할 때 나타납니다.
///
/// 잠금이 설정된 경우에 앱이 백그라운드에 있다가 사용자가 다시 앱으로 돌아가면 이 화면이 나타납니다.
/// - Author: 안상희
class EmptyViewController: UIViewController {
    /// UI 업데이트 중에 사용할 수 있도록 클래스 범위에 저장된 인증 컨텍스트
    var context = LAContext()
    
    /// keyPrefix로 전달된 값을 통해 KeychainSwift 객체를 초기화하기 위한 속성.생체인증을 위한 키체인입니다.
    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
    
    
    /// 생체 인증을 진행합니다.
    func useBioAuthentication(){
        context = LAContext()

        // 취소 버튼을 누르면 Touch ID / Face ID 작업이 취소됩니다.
        context.localizedCancelTitle = "취소"

        var error: NSError?
        // 인증을 시도하기 전에, 먼저 canEvaluatePolicy 메소드를 통해 실제로 인증이 가능한지 체크합니다.
        // 만약 생체 인식에 실패하거나, 사용할 수 없을 경우 암호를 입력하도록 합니다.
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "앱 잠금을 해제합니다."
            
            // TouchID/FaceID로 인증할 준비가 될 경우
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) {
                success, error in
                if success {
                    // TouchID/FaceID 암호 입력 성공하면 bioKeychain에 저장해줍니다.
                    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
                    
                    bioKeychain.set(true,
                                       forKey: Keys.bioLockPasswordKey,
                                       withAccess: .accessibleWhenUnlocked)
                    
                    DispatchQueue.main.async {
                        CommonViewController.transitionToHome()
                    }
                } else {
                    // TouchID/FaceID 창은 떴지만, 사용자가 생체 인증을 취소한 경우입니다.
                    // 사용자가 설정한 비밀번호를 입력하는 화면으로 바뀝니다.
                    #if DEBUG
                    print("EmptyViewController fail to authenticate")
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    #endif
                    
                    DispatchQueue.main.async {
                        CommonViewController.showPasswordViewController()
                    }
                }
            }
        } else {
            #if DEBUG
            print(error?.localizedDescription ?? "Can't evaluate policy")
            #endif
            DispatchQueue.main.async {
                self.alert(message: "생체 인증에 실패하였습니다.")
            }
        }
    }
    

    /// ViewController가 메모리에 로드되면 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        useBioAuthentication()
    }
}
