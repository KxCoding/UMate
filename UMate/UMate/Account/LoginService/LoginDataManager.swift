//
//  LoginDataManager.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/17.
//

import Foundation
import KeychainSwift
import Moya
import RxSwift


/// 로그인 서비스
/// - Author: 장현우(heoun3089@gmail.com)
enum LoginService {
    case signup(EmailJoinPostData)
    case login(EmailLoginPostData)
    case validateToken
}



extension LoginService: TargetType, AccessTokenAuthorizable {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://umateloginserver.azurewebsites.net")!
    }
    
    /// 기본 URL을 제외한 나머지 경로
    var path: String {
        switch self {
        case .signup:
            return "/join/email"
        case .login:
            return "/login/email"
        case .validateToken:
            return "/validation"
        }
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        switch self {
        case .signup, .login:
            return .post
        case .validateToken:
            return .get
        }
    }
    
    /// HTTP 작업 유형
    var task: Task {
        switch self {
        case .signup(let emailJoinPostData):
            return .requestJSONEncodable(emailJoinPostData)
        case .login(let emailLoginPostData):
            return .requestJSONEncodable(emailLoginPostData)
        case .validateToken:
            return .requestPlain
        }
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        
        return ["Content-Type": "application/json"]
    }
    
    /// 인증 타입
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}



/// 로그인 데이터 관리
/// - Author: 장현우(heoun3089@gmail.com)
class LoginDataManager {
    
    /// 싱글톤
    static let shared = LoginDataManager()
    
    /// 싱글톤
    private init() { }
    
    /// DisposeBag
    let bag = DisposeBag()
    
    /// 로그인 키체인 인스턴스
    let loginKeychain = KeychainSwift()
    
    /// 네트워크 서비스 객체
    var provider = MoyaProvider<LoginService>()
    
    /// 네트워크 서비스 객체
    ///
    /// Bearer 토큰 인증 방식을 사용합니다.
    lazy var validationProvider: MoyaProvider<LoginService> = {
        let token = loginKeychain.get(AccountKeys.apiToken.rawValue) ?? ""
        let authPlugin = AccessTokenPlugin { _ in token }
        
        return MoyaProvider<LoginService>(plugins: [authPlugin])
    }()
    
    
    /// 입력한 정보로 회원가입합니다.
    /// - Parameters:
    ///   - emailJoinPostData: 회원가입 정보를 담은 객체
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    /// - Author: 장현우(heoun3089@gmail.com)
    func singup(emailJoinPostData: EmailJoinPostData, vc: CommonViewController) {
        provider.rx.request(.signup(emailJoinPostData))
            .map(JoinResponse.self)
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        self.saveAccount(responseData: response)
                        DispatchQueue.main.async {
                            vc.alert(message: "회원가입에 성공하였습니다.") { _ in
                                CommonViewController.transitionToHome()
                            }
                        }
                    case ResultCode.fail.rawValue:
                        DispatchQueue.main.async {
                            vc.alert(message: response.message ?? "오류가 발생했습니다.")
                        }
                    default:
                        break
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        vc.alert(message: error.localizedDescription)
                    }
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 이메일과 비밀번호로 로그인합니다.
    /// - Parameters:
    ///   - emailLoginPostData: 로그인 정보를 담은 객체
    ///   - transitionToHome: 홈 화면으로 이동하는 메소드
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    /// - Author: 장현우(heoun3089@gmail.com)
    func login(emailLoginPostData: EmailLoginPostData, transitionToHome: @escaping () -> (), vc: CommonViewController) {
        provider.rx.request(.login(emailLoginPostData))
            .map(LoginResponse.self)
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        self.saveAccount(responseData: response)
                        transitionToHome()
                    case ResultCode.fail.rawValue:
                        DispatchQueue.main.async {
                            vc.alert(message: response.message ?? "오류가 발생했습니다.")
                        }
                    default:
                        break
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        vc.alert(message: error.localizedDescription)
                    }
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 저장된 토큰을 확인합니다.
    ///
    /// 유효한 토큰일 경우, 메인 화면으로 이동합니다.
    /// 유효한 토큰이 아닐 경우, 로그인 화면으로 이동합니다.
    /// - Parameters:
    ///   - transitionToLoginScreen: 로그인 화면으로 이동하는 메소드
    ///   - transitionToHome: 홈 화면으로 이동하는 메소드
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    /// - Author: 장현우(heoun3089@gmail.com)
    func validateToken(transitionToLoginScreen: @escaping () -> (), transitionToHome: @escaping () -> (), vc: CommonViewController) {
        validationProvider.rx.request(.validateToken)
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case ResultCode.ok.rawValue:
                        transitionToHome()
                    default:
                        print(response)
                        transitionToLoginScreen()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        vc.alert(message: error.localizedDescription)
                    }
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 계정 정보를 저장합니다.
    /// - Parameter responseData: 계정 응답 데이터 객체
    /// - Author: 장현우(heoun3089@gmail.com)
    private func saveAccount(responseData: CommonAccountResponseType) {
        loginKeychain.delete(responseData.userId ?? "")
        loginKeychain.delete(responseData.token ?? "")
        loginKeychain.delete(responseData.userName ?? "")
        loginKeychain.delete(responseData.nickName ?? "")
        loginKeychain.delete(responseData.yearOfAdmission ?? "")
        
        if let userId = responseData.userId,
           let email = responseData.email,
           let token = responseData.token {
            loginKeychain.set(userId, forKey: AccountKeys.userId.rawValue)
            loginKeychain.set(email, forKey: AccountKeys.email.rawValue)
            loginKeychain.set(token, forKey: AccountKeys.apiToken.rawValue)
            loginKeychain.set(responseData.userName ?? "", forKey: AccountKeys.userName.rawValue)
            loginKeychain.set(responseData.nickName ?? "", forKey: AccountKeys.nickName.rawValue)
            loginKeychain.set(responseData.yearOfAdmission ?? "", forKey: AccountKeys.yearOfAdmission.rawValue)
            UserDefaults.standard.set([true, true], forKey: "expand")
        }
    }
}
