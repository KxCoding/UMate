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
        guard idTextField.text == User.emailAddress && passwordTextField.text == User.password else {
            return
        }
        guard let id = idTextField.text,
              id.count > 0,
              id.contains("@") && id.contains("."),
              id.trimmingCharacters(in: .whitespacesAndNewlines)  != "" else {

                  showError(title: "알림", message: "존재하지않는 아이디 입니다.")

                  return
              }

        guard let password = passwordTextField.text,
              isPasswordValid(password),
              password.count >= 8,
              password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {

                  showError(title: "알림", message: "아이디 비밀번호가 맞지 않습니다.")

                  return
              }
        
        
        transitionToHome()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
     
        idTextField.text = User.emailAddress
        passwordTextField.text = User.password
        
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
    
}

