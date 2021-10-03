//
//  DetailRegisterViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/03.
//

import UIKit
import KeychainSwift

/// 키체인 저장용 키
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
    /// 이메일 필드
    @IBOutlet weak var emailTextField: UITextField!
    
    /// 비밀번호  필드
    @IBOutlet weak var passwordTextField: UITextField!
    
    /// 비밀번호 확인 필드
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    /// 이름  필드
    @IBOutlet weak var nameTextField: UITextField!
    
    /// 닉네임  필드
    @IBOutlet weak var nickNameTextField: UITextField!
    
    /// 완료  버튼
    @IBOutlet weak var nextButton: UIButton!
    
    /// 프로필 이미지 뷰
    /// 사용자가 선택한 프로필 이미지가 표시됩니다.
    @IBOutlet weak var profileImageView: UIImageView!
    
    /// 프로파일 이미지 변경  버튼
    @IBOutlet weak var changeProfilePicButton: UIButton!
    
    /// 키체인에 저장된 이메일 데이타를 저장
    var verifiedEmail: String?
    
    /// 키체인 인스턴스
    /// 사용자의 계정을 저장할 때 사용합니다.
    var keyChain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// 옵저버 제거를 위한 NSObjectProtocol  배열
    var tokens = [NSObjectProtocol]()
    
    /// 회원가입에 필요한 조건들을 검사합니다.
    /// Register Button
    /// - Parameter sender: nextButton으로 전달되고 조건이 충족되면 다음화면으로 갑니다.
    @IBAction func checkToRegisterConditions(_ sender: Any) {
        // 유저가 작성한 패스워드를 정규식 메소드에서 검사하고 패스워드가 빈 문자열이 아닌경우만 다음 문장으로 가게합니다.
        guard let password = passwordTextField.text,
              isPasswordValid(password),
              password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  alert(title: "알림", message: "비밀번호는 반드시 영문 숫자 특수문자를 포함해야합니다냐.")
                  return
              }
        
        // 암호를 키체인 저장하고 액세스 레벨을 accessibleAfterFirstUnlock로 설정합니다.(앱을 재시작하기 전까지 언락)
        if keyChain.set(password, forKey: Keys.passwordKey, withAccess: .accessibleAfterFirstUnlock) {
            #if DEBUG
            print("set Password")
            #endif
        } else {
            #if DEBUG
            print("faild set Password")
            #endif
        }
        
        // 사용자가 입력한 비밀번호와 동일하게 조건을 만듭니다. 조건이 false라면 경고를 출력
        guard let repeatPassword = repeatPasswordTextField.text,
              repeatPassword == password else {
                  alert(title: "알림", message: "비밀번호가 같지 않습니다.")
                  return
              }
        
        // 이름과 닉네임의 최소 문자수의 조건을 지정합니다. 조건이 false라면 경고를 출력
        guard let name = nameTextField.text,
              let nickName = nickNameTextField.text,
              name.count >= 2, nickName.count >= 2 else {
                  alert(title: "알림", message: "잘못된 형식의 이름 혹은 닉네임입니다.")
                  return
              }
        
        // 유저디폴트에 사용자 이름과 닉네임 저장
        UserDefaults.standard.set(name, forKey: "nameKey")
        UserDefaults.standard.set(nickName, forKey: "nickNameKey")
        
        
        // 성공시 홈화면
        CommonViewController.shared.transitionToHome()
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 키보드 올리고 내리는 메소드
        keyboardWillShow()
        keyboardWillHide()
        
        [emailTextField, passwordTextField, repeatPasswordTextField, nameTextField, nickNameTextField, changeProfilePicButton].forEach({
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
            
        })
        
        // 버튼에 공통 스타일을 적용
        nextButton.setButtonTheme()
        
        // 이메일 검증 화면에서 검증받은 이메일을 가져옴
        if let safeEmail = keyChain.get(Keys.userEmailKey) {
            emailTextField.text = safeEmail
        }
        
        var token: NSObjectProtocol
        
        // ProfilePicturesController에서 선택한 사진을 가져오고 유저디폴트에 저장
        token = NotificationCenter.default.addObserver(forName: .didTapProfilePics, object: nil, queue: .main, using: { [weak self] noti  in
            guard let strongSelf = self else { return }
            
            // 유저인포로 전달된 tag를 int로 타입 캐스팅을 합니다.
            guard let profileImage = noti.userInfo?[ProfilePicturesViewController.picsKey] as? Int else { return }
            
            // Int타입으로 에셋에 있는 이미지를 저장하고 바인딩합니다.
            guard let image = UIImage(named: "\(profileImage)") else { return }
            strongSelf.profileImageView.image = image
            
            // pngdata로 바인딩한다음에 유저 디폴츠에 저장합니다.
            if let pngData = image.pngData() {
                UserDefaults.standard.set(pngData, forKey: "profile")
            }
            
        })
        
        // 등록된 옵저버를 제거하기 위해서 tokens 배열에 token을 추가
        tokens.append(token)
        
        // 프로파일 이미지뷰를 원으로 만듭니다.
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        // 사용자가 뷰를 탭할시 키보드 내려감
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // 텍스트 필드 델리게이트 설정
        nameTextField.delegate = self
        repeatPasswordTextField.delegate = self
        nickNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    /// 뷰를 탭할시 키보드 내려갑니다.
    /// - Parameter sender: 파라미터가 UITapGestureRecognizer의 생성자 액션 파라미터로 전달됩니다.
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    
    /// 등록된 옵저버를 제거합니다.
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
           
    }
    
}

extension DetailRegisterViewController: UITextFieldDelegate {
    /// 선언해놓은 activeTextField 텍스트 필드 편집시 호출됩니다.
    /// - Parameter textField: UITextField에 전달되고  activetedTextField가 편집시 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        CommonViewController.shared.activetedTextField = textField
    }
    
    
    /// 선언해놓은 activeTextField 텍스트 필드 편집 끝날시 호출됩니다.
    /// - Parameter textField: UITextField 전달되고 activetedTextField 편집이 끝날시 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        CommonViewController.shared.activetedTextField = nil
    }
    
    /// 사용자가 다른 이메일을 입력하려고 할 때 호출됩니다.
    /// 입력할 수 있는 문자를 제한합니다.
    /// - Parameters:
    ///   - textField: 이메일 텍스트필드
    ///   - range: 교체될 문자열의 범위
    ///   - string: 유저가 타이핑하는 동안 대체될 문자
    /// - Returns: 입력한 문자를 텍스트 필드에 반영할 경우 true를 리턴하고, 나머지 경우에는 false를 리턴합니다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let char = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
            return string.rangeOfCharacter(from: char) == nil
        }
        
        return true
    }
    
}


extension DetailRegisterViewController {
    /// KeyboardWillHideNotification을 처리하는 옵저버를 등록합니다.
    /// activeTextField를 이용하여 키보드가 화면에 표시되기 직전에 키보드 높이만큼 Bottom 여백을 추가해서 UI와 겹치는 문제를 방지합니다.
    func keyboardWillShow() {
        var token: NSObjectProtocol
       token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return  }
            guard let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            var shouldMoveViewUp = false
            
            if let activeTextField = CommonViewController.shared.activetedTextField {
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
    func keyboardWillHide() {
        var token: NSObjectProtocol
      token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
        
        tokens.append(token)
    }
    
}
