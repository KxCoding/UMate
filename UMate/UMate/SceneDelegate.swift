//
//  SceneDelegate.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let keychain = KeychainSwift(keyPrefix: Keys.appLockPasswordKey)
    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
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
    
    
    /// Scene의 연결이 해제될 때 호출되는 메소드.
    /// - Parameter scene: UIScene
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    
    /// Scene과의 상호작용이 시작될 때 호출되는 메소드.
    ///
    /// Background로 갔다가 다시 Foreground로 들어올 때에도 호출된다.
    /// - Parameter scene: UIScene
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    
    /// 사용자가 Scene과의 상호작용을 중지할 때 호출되는 메소드.
    ///
    /// 앱 밖으로 나갈 때 호출된다.
    /// - Parameter scene: UIScene
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    
    /// Scene이 Foreground로 진입할 때 호출되는 메소드.
    ///
    /// 사용자가 앱 밖에서 앱으로 다시 들어올 때 호출된다.
    /// - Parameter scene: UIScene
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    
        
        // 암호가 이미 설정되어있는지 체크
        let isPasswordSet = keychain.get(Keys.appLockPasswordKey)
        let isBioUnlockSet = bioKeychain.getBool(Keys.bioLockPasswordKey)
        print("isPasswordSet \(isPasswordSet), bioSet \(isBioUnlockSet)")

        if let isPasswordSet = isPasswordSet {
            guard let isBioUnlockSet = isBioUnlockSet, isBioUnlockSet == true else {
                CommonViewController.showPasswordViewController()
                return
            }
            CommonViewController.showFaceIdViewController()
        }
    }
    
    
    /// Scene이 Background에 진입한 직후에 호출되는 메소드.
    /// - Parameter scene: UIScene
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = window else {
            return
        }
        
        window.rootViewController = vc
        
        // add.animation
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)

    }


}

