//
//  SceneDelegate.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import KeychainSwift
import UIKit


/// Scene에서 발생하는 Life Cycle 이벤트에 대응하는 데 사용하는 core methods들을 포함합니다.
/// - Author: 안상희, 황신택
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    /// keyPrefix로 전달된 값을 통해 KeychainSwift 객체를 초기화하기 위한 속성. 앱에서 사용하는 비밀번호를 위한 키체인입니다.
    /// - Author: 안상희
    let keychain = KeychainSwift(keyPrefix: Keys.appLockPasswordKey)
    
    /// keyPrefix로 전달된 값을 통해 KeychainSwift 객체를 초기화하기 위한 속성. 생체인증을 위한 키체인입니다.
    /// - Author: 안상희
    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
    

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        
        if let _ = UserDefaults.standard.string(forKey: "username") {
            let mainTabbarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            window?.rootViewController = mainTabbarController
        } else {
            let loginNavContoller = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
            window?.rootViewController = loginNavContoller
        }
    }
    
    
    /// Scene의 연결이 해제될 때 호출됩니다.
    /// - Parameter scene: UIScene
    /// - Author: 안상희
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    
    /// Scene과의 상호작용이 시작될 때 호출됩니다.
    ///
    /// Background로 갔다가 다시 Foreground로 들어올 때에도 호출됩니다.
    /// - Parameter scene: UIScene
    /// - Author: 안상희
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    
    /// 사용자가 Scene과의 상호작용을 중지할 때 호출됩니다.
    ///
    /// 앱 밖으로 나갈 때 호출됩니다.
    /// - Parameter scene: UIScene
    /// - Author: 안상희
    func sceneWillResignActive(_ scene: UIScene) {
    }

    
    /// Scene이 Foreground로 진입할 때 호출됩니다.
    ///
    /// 사용자가 앱 밖에서 앱으로 다시 들어올 때 호출됩니다.
    /// - Parameter scene: UIScene
    /// - Author: 안상희
    func sceneWillEnterForeground(_ scene: UIScene) {
        // 암호가 이미 설정되어있는지 체크합니다.
        let isPasswordSet = keychain.get(Keys.appLockPasswordKey)
        let isBioUnlockSet = bioKeychain.getBool(Keys.bioLockPasswordKey)
        
        #if DEBUG
        print("isPasswordSet \(isPasswordSet), bioSet \(isBioUnlockSet)")
        #endif
        
        if let isPasswordSet = isPasswordSet {
            guard let isBioUnlockSet = isBioUnlockSet, isBioUnlockSet == true else {
                CommonViewController.showPasswordViewController()
                return
            }
            CommonViewController.showFaceIdViewController()
        }
    }
    
    
    /// Scene이 Background에 진입한 직후에 호출됩니다.
    /// - Parameter scene: UIScene
    /// - Author: 안상희
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
    /// RootViewController를 변경합니다.
    /// - Parameters:
    ///   - vc: 변경하려고 하는 UIViewController
    ///   - animated: 기본값은 true로 true면 애니메이션 효과를 사용하고, false이면 애니메이션 효과를 사용하지 않습니다.
    /// - Author: 황신택, 안상희
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = window else {
            return
        }
        
        window.rootViewController = vc
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }
}

