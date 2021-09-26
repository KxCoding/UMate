//
//  CommonViewController.swift
//  CommonViewController
//
//  Created by 안상희 on 2021/08/06.
//

import UIKit

class CommonViewController: UIViewController {
    /// go to homeVC
    static func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
    static func showPasswordViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let passwordViewController = storyboard.instantiateViewController(withIdentifier: "CommonPasswordSB")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(passwordViewController)
    }
    
    
    
    static func showFaceIdViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let emptyViewController = storyboard.instantiateViewController(withIdentifier: "EmptySB")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(emptyViewController)
    }
    
    
    /// 노티피케이션 제거를 위해 토큰을 담는 배열
    /// - Author: 남정은
    var tokens = [NSObjectProtocol]()
    
    /// 소멸자에서 옵저버를 제거
    /// - Author: 남정은
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
