//
//  CommonViewController.swift
//  CommonViewController
//
//  Created by 안상희 on 2021/08/06.
//

import UIKit

class CommonViewController {

    static let shared = CommonViewController()
//    var faceIdDidSet: Bool?
    
    private init() { }
    
 
    /// go to homeVC
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        print("vc \(mainTabBarController)")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
    func showPasswordViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let passwordViewController = storyboard.instantiateViewController(withIdentifier: "CommonPasswordSB")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(passwordViewController)
    }
}
