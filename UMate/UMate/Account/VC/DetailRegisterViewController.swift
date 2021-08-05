//
//  DetailRegisterViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/03.
//

import UIKit

class DetailRegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var changeProfilePicButton: UIButton!
    var verifiedEmail: String?
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let password = passwordTextField.text,
              isPasswordValid(password),
              password.count >= 8,
              password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  alertWithNoAction(title: "알림", message: "비밀번호는 반드시 영문 숫자 특수문자를 포함해야합니다냐.")
                  return
              }
        guard let repeatPassword = repeatPasswordTextField.text,
              repeatPassword == password else {
                  alertWithNoAction(title: "알림", message: "비밀번호가 같지 않습니다.")
                  return
              }
        guard let name = nickNameTextField.text,
              let nickName = nickNameTextField.text,
              name.count >= 2, nickName.count >= 2 else {
                  alertWithNoAction(title: "알림", message: "잘못된 형식의 이름 혹은 닉네임입니다.")
                  return
              }
        
        
        
        
    }
    
    
    var token: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [emailTextField, passwordTextField, repeatPasswordTextField, nameTextField, nickNameTextField, nextButton, changeProfilePicButton].forEach({
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
            
        })
        if let  verifiedEmail = verifiedEmail {
            emailTextField.text = verifiedEmail
        }
        
        token = NotificationCenter.default.addObserver(forName: .didTapProfilePics, object: nil, queue: .main, using: { [weak self] noti  in
            guard let strongSelf = self else { return }
            guard let profileImageView = noti.userInfo?["picsKey"] as? UIImageView else { return }
            
            strongSelf.profileImageView.image = profileImageView.image
            
        })
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
}
