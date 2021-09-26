//
//  EmptyViewController.swift
//  EmptyViewController
//
//  Created by 안상희 on 2021/09/10.
//

import UIKit
import LocalAuthentication
import KeychainSwift

class EmptyViewController: UIViewController {

    var context = LAContext()
    
    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
    
    func faceId(){
        context = LAContext()

        context.localizedCancelTitle = "취소"

        // First check if we have the needed hardware support.
        var error: NSError?
        var status = false
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                if success {
                    // FaceID 성공시
                    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
                    
                    
                    bioKeychain.set(true,
                                       forKey: Keys.bioLockPasswordKey,
                                       withAccess: .accessibleWhenUnlocked)
                    
                    DispatchQueue.main.async { [unowned self] in
                        CommonViewController.transitionToHome()
                    }

                } else {
                    /// FaceID 허용하지 않고, 비밀번호 입력창으로 바뀌는데 사용자가 취소한 것. 직접 지정한 비밀번호 입력하게 해야함.
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    status = false
                    
                    DispatchQueue.main.async {
                        CommonViewController.showPasswordViewController()
                    }
                    
                }
            }
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        faceId()
    }
}
