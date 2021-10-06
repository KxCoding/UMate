//
//  DetailRegisterViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/03.
//

import UIKit
import KeychainSwift

/// 키체인 키 정리
/// Author: 황신택 (sinadsl1457@gmail.com), 안상희
struct Keys {
    /// 인스턴스 생성시 필요한 키
    static let prefixKey = "prefixKey"
    
    /// 패스워드 저장시 필요한 키
    static let passwordKey = "passwordKey"
    
    /// 이메일 저장시 필요한 키
    static let userEmailKey = "userEmailKey"
    
    /// 앱이 시작될시 필요한 키
    static let hasLaunchedKey = "hasLaunchedKey"
    static let appLockPasswordKey = "appLockPasswordKey"
    static let bioLockPasswordKey = "bioLockPasswordKey"
}

/// 회원가입화면
/// Author: 황신택 (sinadsl1457@gmail.com)
class DetailRegisterViewController: AccountCommonThingsViewController {
    /// 이메일 필드
    @IBOutlet weak var emailTextField: UITextField!
    
    /// 비밀번호 필드
    @IBOutlet weak var passwordTextField: UITextField!
    
    /// 비밀번호 확인 필드
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    /// 사용자 이름 필드
    @IBOutlet weak var nameTextField: UITextField!
    
    /// 사용자 닉네임 필드
    @IBOutlet weak var nickNameTextField: UITextField!
    
    /// 회원가입 완료 버튼
    @IBOutlet weak var nextButton: UIButton!
    
    /// 사용자가 선택한 이미지뷰
    @IBOutlet weak var profileImageView: UIImageView!
    
    /// 프로파일 이미지 버튼
    @IBOutlet weak var changeProfilePicButton: UIButton!
    
    /// 키체인에 저장된 이메일 데이타를 저장
    var verifiedEmail: String?
    
     
    /// 회원가입에 필요한 조건들을 검사하고 다음 화면 으로 이동합니다.
    /// - Parameter sender: nextButton
    @IBAction func checkToRegisterConditions(_ sender: Any) {
        guard let password = passwordTextField.text,
              isPasswordValid(password),
              password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  alert(title: "알림", message: "비밀번호는 반드시 영문 숫자 특수문자를 포함해야합니다냐.")
                  return
              }
        
        // 암호를 키체인 저장하고 액세스 레벨을 accessibleAfterFirstUnlock로 설정합니다.
        // 앱을 재시작하기 전까지 언락 합니다.
        if keychain.set(password, forKey: Keys.passwordKey, withAccess: .accessibleAfterFirstUnlock) {
            #if DEBUG
            print("set Password")
            #endif
        } else {
            #if DEBUG
            print("Faild Set")
            #endif
        }
        
        // 사용자가 입력한 비밀번호 확인합니다.
        guard let repeatPassword = repeatPasswordTextField.text,
              repeatPassword == password else {
                  alert(title: "알림", message: "비밀번호가 같지 않습니다.")
                  return
              }
        
        // 이름과 닉네임의 최소 문자 개수를 확인합니다.
        guard let name = nameTextField.text,
              let nickName = nickNameTextField.text,
              name.count >= 2, nickName.count >= 2 else {
                  alert(title: "알림", message: "잘못된 형식의 이름 혹은 닉네임입니다.")
                  return
              }
        
        // 유저디폴트에 사용자 이름과 닉네임 저장 합니다.
        UserDefaults.standard.set(name, forKey: "nameKey")
        UserDefaults.standard.set(nickName, forKey: "nickNameKey")
        
        // 성공시 홈화면으로 갑니다.
        transitionToHome()
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 키보드 옵저버를 등록합니다.
        addkeyboardWillHideObserver()
        addkeyboardWillShowObserver()
        
        [emailTextField, passwordTextField, repeatPasswordTextField, nameTextField, nickNameTextField, changeProfilePicButton].forEach({
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
            
        })
        
        // 버튼에 공통 스타일을 적용합니다.
        nextButton.setToEnabledButtonTheme()
        
        // 검증받은 이메일을 가져옵니다.
        if let safeEmail = keychain.get(Keys.userEmailKey) {
            emailTextField.text = safeEmail
        }
        
        
        // 옵저버를 등록하고 유저인포 키를 통해서 int값을 받아서 이미지로 바인딩합니다.
        // 바인딩 한 이미지를 UserDefaults에 저장합니다.
        let token = NotificationCenter.default.addObserver(forName: .didTapProfilePics, object: nil, queue: .main, using: { [weak self] noti  in
            guard let strongSelf = self else { return }
            guard let profileImage = noti.userInfo?[ProfilePicturesViewController.picsKey] as? Int else { return }
            
            // Int타입으로 에셋에 있는 이미지를 저장하고 바인딩
            guard let image = UIImage(named: "\(profileImage)") else { return }
            strongSelf.profileImageView.image = image
            
            // pngdata로 바인딩한다음에 유저 디폴츠에 저장
            if let pngData = image.pngData() {
                UserDefaults.standard.set(pngData, forKey: "profile")
            }
            
        })
        
        
        tokens.append(token)
        
        // 프로파일 이미지뷰를 원모양으로 초기화 합니다.
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        // 사용자가 뷰를 탭할시 키보드를 내립니다.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // 텍스트 필드 델리게이트 설정합니다.
        nameTextField.delegate = self
        repeatPasswordTextField.delegate = self
        nickNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    /// 뷰를 탭할시 키보드가 내려갑니다.
    /// UITapGestureRecognizer 의 생성자 액션 파라미터 #selector로 쓰이는 메소드입니다.
    /// - Parameter sender: 파라미터가 UITapGestureRecognizer 전달
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
}

extension DetailRegisterViewController: UITextFieldDelegate {
    /// 텍스트 필드가 편집이 시작될때 호출됩니다
    /// - Parameter textField: 텍스트 필드 편집시 전달
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    
    
    /// 텍스트 필드가 편집이 끝나면 nil로 초기화 합니다.
    /// - Parameter textField: 텍스트 필드 편집이 끝날시 전달
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    
    /// 사용자가 다른 이메일을 입력하려고 할 때 호출됩니다.
    /// 입력할 수 있는 문자를 제한합니다.
    /// - Parameters:
    ///   - textField: 이메일 텍스트필드
    ///   - range: 교체될 문자열의 범위
    ///   - string: 유저가 타이핑하는 동안 대체될 문자
    /// - Returns: return true이면 새로운 문자가 대체 되고, false면 문자입력불가 합니다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let char = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
            return string.rangeOfCharacter(from: char) == nil
        }
        
        return true
    }
    
}

/// 키보드 노티피케이션 확장자
/// Author: 황신택
extension DetailRegisterViewController {
    /// keyboardWillShowNotification을 처리하는 옵저버를 등록합니다.
    /// 키보드가 화면에 표시되기 직전에 키보드 높이만큼 Bottom 여백을 추가해서 UI와 겹치는 문제를 방지합니다.
    func addkeyboardWillShowObserver() {
        let token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] noti in
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
        
        tokens.append(token)
    }
    
    /// keyboardWillHideNotification을 처리하는 옵저버를 등록합니다.
    func addkeyboardWillHideObserver() {
        let token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
        
        tokens.append(token)
    }
}
