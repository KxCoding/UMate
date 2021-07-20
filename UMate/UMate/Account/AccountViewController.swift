//
//  AccountViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func findIDPassword(_ sender: Any) {
        
        
    }
    
    
    @IBAction func register(_ sender: Any) {
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        guard let id = idTextField.text,
              id.count > 0,
              id.contains("@") && id.contains("."),
              id.trimmingCharacters(in: .whitespacesAndNewlines)  != "" else {

                  showError(title: "알림", message: "이메일 형식으로 입력해야합니다.")

                  return
              }

        guard let password = passwordTextField.text,
              isPasswordValid(password),
              password.count >= 8,
              password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {

                  showError(title: "알림", message: "비밀번호는 최소 8자리 이상 특수문자 포함 해야합니다.")

                  return
              }
        
        
        transitionToHome()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        
    }
    
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    func logOutTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNaviationController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
    }
    
}

