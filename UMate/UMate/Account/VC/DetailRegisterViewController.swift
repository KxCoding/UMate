//
//  DetailRegisterViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/03.
//

import UIKit
import KeychainSwift

/// 오타 방지를위한 키체인 Identifier를 구조체로 선언
/// Author: 황신택, 안상희
struct Keys {
    static let prefixKey = "prefixKey"
    static let passwordKey = "passwordKey"
    static let userEmailKey = "userEmailKey"
    static let hasLaunchedKey = "hasLaunchedKey"
    static let appLockPasswordKey = "appLockPasswordKey"
    static let bioLockPasswordKey = "bioLockPasswordKey"
}

/// 회원정보를 입력하고 프로필 이미지를 저장하는 클래스
/// Author: 황신택
class DetailRegisterViewController: UIViewController {
    /// 이메일을 입력하는 텍스트 필드
    @IBOutlet weak var emailTextField: UITextField!
    
    /// 비밀번호를 입력하는 텍스트 필드
    @IBOutlet weak var passwordTextField: UITextField!
    
    /// 입력한 비밀번호를 한번더 입력하는 텍스트필드
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    /// 사용자 이름을 입력하는 텍스트 필드
    @IBOutlet weak var nameTextField: UITextField!
    
    /// 사용자 닉네임을 입력하는 텍스트 필드
    @IBOutlet weak var nickNameTextField: UITextField!
    
    /// 회원가입을 완료하는 버튼
    @IBOutlet weak var nextButton: UIButton!
    
    /// 사용자가 선택한 이미지뷰
    @IBOutlet weak var profileImageView: UIImageView!
    
    /// 프로파일 이미지 버튼
    @IBOutlet weak var changeProfilePicButton: UIButton!

    /// 특정 텍스트필드에 조건을 추가 하기위해 선언
    var activeTextField: UITextField? = nil
    
    /// 키체인에 저장된 이메일 데이타를 저장
    var verifiedEmail: String?
    
    /// 키체인에 유저 계정을 저장
    var keyChain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// 옵저버 제거를 위한 변수
    var token: NSObjectProtocol?
    
    /// 회원가입에 필요한 조건들을 검사합니다.
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
        
        /// 사용자가 입력한 비밀번호와 동일하게 조건을 만듭니다. 조건이 false라면 경고를 출력
        guard let repeatPassword = repeatPasswordTextField.text,
              repeatPassword == password else {
                  alert(title: "알림", message: "비밀번호가 같지 않습니다.")
            return
        }
    
        /// 이름과 닉네임의 최소 문자수의 조건을 지정합니다. 조건이 false라면 경고를 출력
        guard let name = nameTextField.text,
              let nickName = nickNameTextField.text,
              name.count >= 2, nickName.count >= 2 else {
                  alert(title: "알림", message: "잘못된 형식의 이름 혹은 닉네임입니다.")
            return
        }
        
        /// 유저디폴트에 사용자 이름과 닉네임 저장
        UserDefaults.standard.set(name, forKey: "nameKey")
        UserDefaults.standard.set(nickName, forKey: "nickNameKey")
        
        /// 성공시 홈화면
        CommonViewController.shared.transitionToHome()
        
    }
    
   
    
    
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
        
        /// 버튼에 공통 스타일을 적용.
        nextButton.setButtonTheme()
       
        /// 이메일 검증 화면에서 검증받은 이메일을 가져옴.
            if let safeEmail = keyChain.get(Keys.userEmailKey) {
                emailTextField.text = safeEmail
            }
        
        /// ProfilePicturesController에서 선택한 사진을 가져오고 유저디폴트에 저장.
        token = NotificationCenter.default.addObserver(forName: .didTapProfilePics, object: nil, queue: .main, using: { [weak self] noti  in
            guard let strongSelf = self else { return }
            /// 유저인포로 전달된 tag를 int로 타입 캐스팅을 합니다.
            guard let profileImage = noti.userInfo?[ProfilePicturesViewController.picsKey] as? Int else { return }
            /// Int타입으로 에셋에 있는 이미지를 저장하고 바인딩합니다.
            guard let image = UIImage(named: "\(profileImage)") else { return }
            strongSelf.profileImageView.image = image
            /// pngdata로 바인딩한다음에 유저 디폴츠에 저장합니다.
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
        
        /// 텍스트필드 델리게이트 설정.
        nameTextField.delegate = self
        repeatPasswordTextField.delegate = self
        nickNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    /// 뷰를 탭할시 키보드 내려감.
    /// - Parameter sender: UITapGestureRecognizer
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
    /// - Parameter textField: activeTextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    
    /// 선언해놓은 activeTextField 텍스트필드 편집 끝날시 호출
    /// - Parameter textField: activeTextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    /// 이미 검증된 이메일 외에 그 어떠한 다른 문자가 들어올수없습니다, .
    /// - Parameters:
    ///   - textField: 이메일 텍스트필드
    ///   - range: 교체될 문자열의 범위
    ///   - string: 유저가 타이핑하는 동안 대체될 문자
    /// - Returns: return true이면 새로운문자가 대체 되고, false면 문자입력불가.
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
