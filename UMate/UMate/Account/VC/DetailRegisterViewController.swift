//
//  DetailRegisterViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/03.
//

import UIKit
import KeychainSwift
import RxSwift
import RxCocoa
import NSObject_Rx

/// 키체인 키
/// - Author: 황신택 (sinadsl1457@gmail.com), 안상희
struct Keys {
    /// 인스턴스 키
    static let prefixKey = "prefixKey"
    
    /// 패스워드 키
    static let passwordKey = "passwordKey"
    
    /// 이메일 키
    static let userEmailKey = "userEmailKey"
    
    /// 앱 시작 키
    static let hasLaunchedKey = "hasLaunchedKey"
    
    /// 앱 잠금 키
    static let appLockPasswordKey = "appLockPasswordKey"
    
    /// 생체인증 키
    static let bioLockPasswordKey = "bioLockPasswordKey"
}



/// 회원가입 화면
/// - Author: 황신택 (sinadsl1457@gmail.com), 장현우(heoun3089@gmail.com)
class DetailRegisterViewController: CommonViewController {
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
    
    /// 사용자가 선택한 이미지 뷰
    @IBOutlet weak var profileImageView: UIImageView!
    
    /// 프로파일 이미지 버튼
    @IBOutlet weak var changeProfilePicButton: UIButton!
    
    /// 검증된 이메일 주소
    var verifiedEmail: String?
    
    /// 대학교 이름
    ///
    /// 이전 화면에서 전달됩니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    var universityName: String?
    
    /// 입학 연도
    ///
    /// 이전 화면에서 전달됩니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    var entranceYear: String?
        
    
    /// 회원가입에 필요한 조건들을 검사하고 다음 화면으로 이동합니다.
    /// - Parameter sender: nextButton
    /// - Author: 황신택 (sinadsl1457@gmail.com), 장현우(heoun3089@gmail.com)
    @IBAction func checkToRegisterConditions(_ sender: Any) {
        guard let password = passwordTextField.text,
              isPasswordValid(password),
              password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  alert(title: "알림", message: "비밀번호는 반드시 영문 숫자 특수문자를 포함해야합니다냐.")
                  return
              }
        
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
        
        guard let email = emailTextField.text,
              let entranceYear = entranceYear else {
                  return
              }

        UniversityDataManager.shared.fetchUniversity(vc: self) {
            if let universityName = self.universityName {
                let targetUniversity = UniversityDataManager.shared.universityList.filter { $0.name == universityName }
                if let university = targetUniversity.first {
                    print(university.universityId)
                    
                    let emailJoinPostData = EmailJoinPostData(email: email,
                                                              password: password,
                                                              realName: name,
                                                              nickName: nickName,
                                                              universityId: university.universityId,
                                                              yearOfAdmission: entranceYear)
                    
                    LoginDataManager.shared.singup(emailJoinPostData: emailJoinPostData, vc: self)
                }
            }
        }
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        [emailTextField, passwordTextField, repeatPasswordTextField, nameTextField, nickNameTextField, changeProfilePicButton].forEach({
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
            
        })
        
        nextButton.setToEnabledButtonTheme()
        
        // 검증받은 이메일을 가져옵니다.
        if let safeEmail = keychainPrefix.get(Keys.userEmailKey) {
            emailTextField.text = safeEmail
        }
        
        // 옵저버를 등록하고 userInfo 키를 통해 Int값을 받아서 이미지로 바인딩합니다.
        // 바인딩 한 이미지를 UserDefaults에 저장합니다.
        NotificationCenter.default.rx.notification(.didTapProfilePics, object: nil)
            .compactMap { $0.userInfo?[ProfilePicturesViewController.picsKey] as? Int }
            .compactMap { UIImage(named: "\($0)") }
            .subscribe(onNext: { [unowned self] image in
                self.profileImageView.image = image
                if let pngData = image.pngData() {
                    UserDefaults.standard.set(pngData, forKey: "profile")
                }
            })
            .disposed(by: rx.disposeBag)
        
        // 프로파일 이미지 뷰를 원모양으로 초기화 합니다.
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        didTapMakeLowerKeyboard()
        
        makeChangeNavigationItemColor()
        
        AddkeyboardNotification()
    }
    
}



extension DetailRegisterViewController: UITextFieldDelegate {
    /// 내용을 편집할 때마다 반복적으로 호출됩니다.
    /// 입력할 수 있는 문자를 제한합니다.
    /// - Parameters:
    ///   - textField: 이메일 텍스트필드
    ///   - range: 교체될 문자열의 범위
    ///   - string: 입력된 문자 또는 문자열
    /// - Returns: true를 리턴하면 편집된 내용을 반영하고, false를 리턴하면 무시합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let char = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@.,/';[]=-!@#$%^&*()_+\"")
            return string.rangeOfCharacter(from: char) == nil
        }
        return true
    }
}


