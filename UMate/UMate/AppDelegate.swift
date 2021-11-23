//
//  AppDelegate.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import DropDown
import KeychainSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// window 객체
    /// - Author: 장현우(heoun3089@gmail.com)
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropDown.startListeningToKeyboard()
        
        let keychain = KeychainSwift(keyPrefix: Keys.prefixKey)
        
        if UIApplication.isFirstLaunch() {
            keychain.clear()
            print("first launched")
        } else {
            keychain.allKeys
            print("second launched")
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}


/// 앱 시작 시점에 처리할 작업을 위한 익스텐션
/// - Author: 황신택 (sinadsl1457@gmail.com)
extension UIApplication {
    /// UserDefaults의 HasLaunched 키가 저장되어 있는지 체크합니다.
    /// 해당 키가 없다면 앱 시작 시점을 UserDefaults에 저장합니다.
    /// - Returns: UserDefaults에 HasLaunched키가 존재하면 false이고 키가 존재하면 true입니다.
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "HasLaunched") {
            UserDefaults.standard.set(true, forKey: "HasLaunched")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
