//
//  SettingTableViewController.swift
//  SettingTableViewController
//
//  Created by 황신택 on 2021/07/23.
//

import KeychainSwift
import UIKit


/// 사용자 계정 설정 화면 TableViewController 클래스
///
/// 사용자 계정 설정과 관련된 메뉴를 선택하여 수행합니다.
/// - Author: 황신택, 안상희, 장현우(heoun3089@gmail.com)
class SettingTableViewController: UITableViewController {
    /// 선택한 메뉴 타이틀
    /// - Author: 안상희
    var selectedMenu: String?
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enterYearAndUniNameLabel: UILabel!
    
    /// 로그인 키체인 인스턴스
    /// - Author: 장현우(heoun3089@gmail.com)
    let loginKeychain = KeychainSwift()
    
    
    /// 커뮤니티 이용 규칙 메뉴가 클릭될 때 실행됩니다.
    /// - Parameter sender: 커뮤니티 이용 규칙 메뉴 (버튼)
    /// - Author: 안상희
    @IBAction func communityRuleButtonDidTapped(_ sender: UIButton) {
        selectedMenu = "커뮤니티 이용 규칙"
        sendMenuTitle()
    }
    
    
    /// 알림 설정 메뉴가 클릭될 때 실행됩니다.
    /// - Parameter sender: 알림 설정 메뉴 (버튼)
    /// - Author: 안상희
    @IBAction func alertButtonDidTapped(_ sender: UIButton) {
        alertVersion2(message: "알림 기능 이용을 위해 아이폰의 [설정] > [UMate]에서 알림을 허용해주세요.") { [weak self] action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } handler2: { _ in }
    }
    
    
    /// 캐시 삭제 메뉴가 클릭될 때 실행됩니다.
    /// - Parameter sender: 캐시 삭제 메뉴 (버튼)
    /// - Author: 안상희
    @IBAction func cacheDeleteButtonDidTapped(_ sender: UIButton) {
        alertVersion2(message: "캐시를 삭제하시겠습니까?") { [weak self] action in
        } handler2: { _ in }
    }
    
    
    /// 공지사항 메뉴가 클릭될 때 실행됩니다.
    /// - Parameter sender: 공지사항 메뉴 (버튼)
    /// - Author: 안상희
    @IBAction func noticeButtonDidTapped(_ sender: UIButton) {
    }
    
    
    /// 서비스 이용약관 메뉴가 클릭될 때 실행됩니다.
    /// - Parameter sender: 서비스 이용약관 메뉴 (버튼)
    /// - Author: 안상희
    @IBAction func serviceUseRuleButtonDidTapped(_ sender: UIButton) {
        selectedMenu = "서비스 이용약관"
        sendMenuTitle()
    }
    
   
    /// 개인정보 처리방침 메뉴가 클릭될 때 실행됩니다.
    /// - Parameter sender: 개인정보 처리방침 메뉴 (버튼)
    /// - Author: 안상희
    @IBAction func userInfoRuleButtonDidTapped(_ sender: UIButton) {
        selectedMenu = "개인정보 처리방침"
        sendMenuTitle()
    }
    
    
    /// 오픈소스 라이선스 메뉴가 클릭될 때 실행됩니다.
    /// - Parameter sender: 오픈소스 라이선스 메뉴 (버튼)
    /// - Author: 안상희
    @IBAction func openSourceButtonDidTapped(_ sender: UIButton) {
        selectedMenu = "오픈소스 라이선스"
        sendMenuTitle()
    }
    
    
    
    /// Declear to remove observer 
    var token: NSObjectProtocol?
    
    
    /// when user didTap this button, present to ProfilePicturesViewController and then get image
    @IBAction func ChangeToProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        if let nav = storyboard.instantiateViewController(withIdentifier: "profileNav") as? UINavigationController {
            
            present(nav, animated: true, completion: nil)
            
            token = NotificationCenter.default.addObserver(forName: .didTapProfilePics, object: nil, queue: .main, using: { [weak self] noti in
                guard let strongSelf = self else { return }
                guard let profileImages = noti.userInfo?[ProfilePicturesViewController.picsKey] as? Int else { return }
                guard let image = UIImage(named: "\(profileImages)") else { return }
                
                strongSelf.profileImageView.image = image
                if let converToPng = image.pngData() {
                    UserDefaults.standard.set(converToPng, forKey: "profile")
                }
            })
        }
    }
    
    
    /// 로그아웃합니다.
    ///
    /// 로그인 키체인 인스턴스에 저장된 모든 데이터를 지우고 인트로 화면으로 돌아갑니다.
    /// - Parameter sender: 로그아웃 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func logout(_ sender: Any) {
        alertLogoutMessage(alertTitle: "로그아웃", alertMessage: "로그아웃하시겠습니까?", okActionTitle: "로그아웃") { _ in
            self.loginKeychain.clear()

            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    /// 선택한 메뉴 타이틀을 다음 뷰컨트롤러로 보내주는 역할을 합니다.
    /// - Author: 안상희
    func sendMenuTitle() {
        guard let vc =
                self.storyboard?.instantiateViewController(withIdentifier: "AppInformationVC") as?
                AppInformationTextViewController else { return }
        
        vc.menu = selectedMenu
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// 알림창을 띄웁니다.
    ///
    /// 핸들러가 포함된 AlertAction의 타이틀을 설정할 수 있습니다.
    /// - Parameters:
    ///   - alertTitle: 알림 타이틀
    ///   - alertMessage: 알림 메시지
    ///   - okActionTitle: 액션 타이틀
    ///   - handler: 완료 블록
    /// - Author: 장현우(heoun3089@gmail.com)
    func alertLogoutMessage(alertTitle: String, alertMessage: String, okActionTitle: String? = "확인", handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: handler)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// To prevent remained observer
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// get register Profileimage data
        if let imageData =  UserDefaults.standard.object(forKey: "profile") as? Data {
            let image = UIImage(data: imageData)
            
            profileImageView.image = image
        }
        
        /// To initialize user information in setting
        if let email = loginKeychain.get(AccountKeys.email.rawValue),
           let userName = loginKeychain.get(AccountKeys.realName.rawValue),
           let nickName = loginKeychain.get(AccountKeys.nickName.rawValue),
           let universityName = loginKeychain.get(AccountKeys.universityName.rawValue),
           let enterYearOfUniversity = (loginKeychain.get(AccountKeys.yearOfAdmission.rawValue)) {
            emailLabel.text = email
            nameLabel.text = "\(userName) / \(nickName)"
            enterYearAndUniNameLabel.text = "\(enterYearOfUniversity) / \(universityName)"
        }
        
        /// initialize
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        /// To support color depend on dark mode or light mode
        nameLabel.textColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        enterYearAndUniNameLabel.textColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        emailLabel.textColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        navigationController?.navigationBar.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
    }
}
