//
//  DetailRegisterViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/03.
//

import UIKit
import KeychainSwift

/// 오타 방지를위한 Identifier 구조체만듬
struct Keys {
    static let prefixKey = "prefixKey"
    static let passwordKey = "passwordKey"
    static let userEmailKey = "userEmailKey"
    static let hasLaunchedKey = "hasLaunchedKey"
    static let appLockPasswordKey = "appLockPasswordKey"
    static let bioLockPasswordKey = "bioLockPasswordKey"
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

    /// 특정 텍스트필드에 조건을 추가 하기위해 선언
    var activeTextField: UITextField? = nil
    
    /// 이메일 데이타를 저장하기위해서 선언.
    var verifiedEmail: String?
    
    /// 키체인에 유저 계정을 저장하기위해 선언
    var keyChain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// 회원가입에 필요한 조건들을 검사함.
    /// Register Button
    /// - Parameter sender: nextButton
    @IBAction func checkToRegisterConditions(_ sender: Any) {
        guard let password = passwordTextField.text,
              isPasswordValid(password),
              password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  alert(title: "알림", message: "비밀번호는 반드시 영문 숫자 특수문자를 포함해야합니다냐.")
            return
        }
        
        /// 암호를 키체인 저장
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
        
        /// 유저디폴트에 사용자 이름 닉네임 저장.
        UserDefaults.standard.set(name, forKey: "nameKey")
        UserDefaults.standard.set(nickName, forKey: "nickNameKey")
        
        
        /// 성공시 홈화면으로 가게한다
        CommonViewController.transitionToHome()
        
    }
    
    /// 노티피케이션센터를 저장하기위한 속성
    var token: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 키보드 올리고 내리는 메소드
        keyboardWillShow()
        keyboardWillHide()
        
        /// 아울렛의 바운드를 10포인트 깎는다.
        [emailTextField, passwordTextField, repeatPasswordTextField, nameTextField, nickNameTextField, changeProfilePicButton].forEach({
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
            
        })
        
        /// 규격해놓은 버튼으로 모양을 만듬.
        nextButton.setToEnabledButtonTheme()
       
        /// 이메일 검증 화면에서 검증받은 이메일을 가져옴.
            if let safeEmail = keyChain.get(Keys.userEmailKey) {
                emailTextField.text = safeEmail
            }
        
        /// ProfilePicturesController에서 선택한 사진을 가져오고 유저디폴트에 저장.
        token = NotificationCenter.default.addObserver(forName: .didTapProfilePics, object: nil, queue: .main, using: { [weak self] noti  in
            guard let strongSelf = self else { return }
            guard let profileImage = noti.userInfo?[ProfilePicturesViewController.picsKey] as? Int else { return }
            
            guard let image = UIImage(named: "\(profileImage)") else { return }
            
            strongSelf.profileImageView.image = image
            
            if let pngData = image.pngData() {
                UserDefaults.standard.set(pngData, forKey: "profile")
            }
            
        })
        
        /// 프로파일 이미지뷰를 동그란 이미지로 바꿈.
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        
        /// 사용자가 뷰를 탭할시 키보드 내려감.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        /// 텍스트필드 델리게이트 선언
        nameTextField.delegate = self
        repeatPasswordTextField.delegate = self
        nickNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    

    /// 노티피케이션 옵저버를 제거한다
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
}

extension DetailRegisterViewController: UITextFieldDelegate {
    /// 선언해놓은 activeTextField 텍스트필드 편집시 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    /// 선언해놓은 activeTextField 텍스트필드 편집 끝날시 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    /// 이미 검증된 이메일 외에 그 어떠한 다른 문자가 들어올수없음.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let char = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
            return string.rangeOfCharacter(from: char) == nil
        }
        
        return true
    }
}


extension DetailRegisterViewController {
    /// 키보드가 텍스트필드에 맞닿을시에만 해당 메소드 호출.
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
    
    /// 키보드를 내려가게한다.
    func keyboardWillHide() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
    }

}
