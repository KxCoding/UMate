//
//  DetailRegisterViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/03.
//

import UIKit
import KeychainSwift

struct Keys {
    static let prefixKey = "prefixKey"
    static let passwordKey = "passwordKey"
    static let userEmailKey = "userEmailKey"
}

class DetailRegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeProfilePicButton: UIButton!

    /// To configure specific textfield
    var activeTextField: UITextField? = nil
    
    /// To save email data
    var verifiedEmail: String?
    
    /// declarion Keychain Instance
    var keyChain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// Register Button
    /// - Parameter sender: nextButton
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let password = passwordTextField.text,
              isPasswordValid(password),
              password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  alert(title: "알림", message: "비밀번호는 반드시 영문 숫자 특수문자를 포함해야합니다냐.")
            return
        }
        
        if keyChain.set(password, forKey: Keys.passwordKey, withAccess: .accessibleAfterFirstUnlock) {
            print("Set")
        } else {
            print("Faild Set")
        }
        
        
        guard let repeatPassword = repeatPasswordTextField.text,
              repeatPassword == password else {
                  alert(title: "알림", message: "비밀번호가 같지 않습니다.")
            return
        }
    
        guard let name = nameTextField.text,
              let nickName = nickNameTextField.text,
              name.count >= 2, nickName.count >= 2 else {
                  alert(title: "알림", message: "잘못된 형식의 이름 혹은 닉네임입니다.")
            return
        }
        
        // Save name, nickName data in userDefaults
        UserDefaults.standard.set(name, forKey: "nameKey")
        UserDefaults.standard.set(nickName, forKey: "nickNameKey")
        
        
        // Make transition to HomeViewController
        CommonViewController.shared.transitionToHome()
        
    }
    

    // 노티피케이션센터를 저장하기위한 속성
    var token: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// call keyboard notification method
        keyboardWillShow()
        keyboardWillHide()
        
        /// configure textField's view
        [emailTextField, passwordTextField, repeatPasswordTextField, nameTextField, nickNameTextField, nextButton, changeProfilePicButton].forEach({
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
            
        })
        
        /// load Previous data in emailTextField.text
            if let safeEmail = keyChain.get(Keys.userEmailKey) {
                emailTextField.text = safeEmail
            }
        
        /// received a notification from ProfilePicturesViewController and save image data
        token = NotificationCenter.default.addObserver(forName: .didTapProfilePics, object: nil, queue: .main, using: { [weak self] noti  in
            guard let strongSelf = self else { return }
            guard let profileImage = noti.userInfo?[ProfilePicturesViewController.picsKey] as? Int else { return }
            
            guard let image = UIImage(named: "\(profileImage)") else { return }
            
            strongSelf.profileImageView.image = image
            
            StorageDataSource.shard.save(image: image)
            
            
        })
        
        /// configure profileImageView's shape like a circle
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        
        /// when user didTap background made a keyboard down
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        nameTextField.delegate = self
        repeatPasswordTextField.delegate = self
        nickNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        /// dummy data
        nameTextField.text = "황신택"
        nickNameTextField.text = "TaekToy"
        passwordTextField.text = "Qwer1234567!"
        repeatPasswordTextField.text = "Qwer1234567!"
        
        
    }
    
    /// verify using regular expression
    func isPasswordValid(_ password : String) -> Bool{
        if let range = password.range(of: Regex.password, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (password.startIndex, password.endIndex) {
            return true
        }
        
        return false
    }
    
    /// verify using regular expression
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        
        return false
    }
    
    /// remove observer
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
}

extension DetailRegisterViewController: UITextFieldDelegate {
    /// To recognize when user enter a value in textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    /// To recognize when user stop enter a value in textfield
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    /// emailTextField can't enter any chracters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let char = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
            return string.rangeOfCharacter(from: char) == nil
        }
        
        return true
    }
}


extension DetailRegisterViewController {
    
    
    /// Invoke only this method when keyboard in case of contact with textField
    func keyboardWillShow() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return  }
            guard let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
            var shouldMoveViewUp = false
            
            if let activeTextField = strongSelf.activeTextField {
                let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: strongSelf.view).maxY
                let topOfKeyboard = strongSelf.view.frame.height - keyboardSize.height
                
                if bottomOfTextField > topOfKeyboard {
                    shouldMoveViewUp = true
                }
            }
            
            if shouldMoveViewUp {
                UIView.animate(withDuration: 0.3) {
                    strongSelf.view.frame.origin.y = 0 - keyboardSize.height
                }
                
            }
        }
    }
    
    /// Make lower the keyboard
    func keyboardWillHide() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
    }
    
    
    /// once didtap background forced to make lower the keyboard
    /// - Parameter sender: UITapGestureRecognizer
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}


