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


/// 로그인 데이터 관리
/// - Author: 장현우(heoun3089@gmail.com)
class LoginDataManager {
    
    /// 싱글톤 인스턴스
    static let shared = LoginDataManager()
    private init() { }
    
    /// 리소스 정리
    let bag = DisposeBag()
    
    /// 로그인 키체인 인스턴스
    let loginKeychain = KeychainSwift()
    
    /// userId를 리턴
    /// - Author: 남정은(dlsl7080@gmail.com)
    var userId: String {
        return LoginDataManager.shared.loginKeychain.get(AccountKeys.userId.rawValue) ?? ""
    }
    
    /// 네트워크 서비스 객체
    ///
    /// Bearer 토큰 인증 방식을 사용합니다.
    lazy var provider: MoyaProvider<LoginAndPlaceReviewService> = {
        if let token = loginKeychain.get(AccountKeys.apiToken.rawValue) {
            let authPlugin = AccessTokenPlugin { _ in token }
            
            return MoyaProvider<LoginAndPlaceReviewService>(plugins: [authPlugin])
        } else {
            return MoyaProvider<LoginAndPlaceReviewService>()
        }
    }()
    
    
    /// 입력한 정보로 회원가입합니다.
    /// - Parameters:
    ///   - emailJoinPostData: 회원가입 정보를 담은 객체
    /// - Returns: 회원가입 응답 정보를 방출하는 옵저버블
    /// - Author: 장현우(heoun3089@gmail.com)
    func signup(emailJoinPostData: EmailJoinPostData) -> Observable<JoinResponse> {
        provider.rx
            .request(.signup(emailJoinPostData))
            .map(JoinResponse.self)
            .retry(3)
            .asObservable()
    }
    
    
    /// 이메일과 비밀번호로 로그인합니다.
    /// - Parameters:
    ///   - emailLoginPostData: 로그인 정보를 담은 객체
    /// - Returns: 로그인 응답 정보를 방출하는 옵저버블
    /// - Author: 장현우(heoun3089@gmail.com)
    func login(emailLoginPostData: EmailLoginPostData) -> Observable<LoginResponse> {
        provider.rx
            .request(.login(emailLoginPostData))
            .map(LoginResponse.self)
            .retry(3)
            .asObservable()
    }
    
    
    /// 저장된 토큰을 확인합니다.
    ///
    /// 유효한 토큰일 경우, 메인 화면으로 이동합니다.
    /// 유효한 토큰이 아닐 경우, 로그인 화면으로 이동합니다.
    /// - Returns: 네트워크 응답 정보를 방출하는 옵저버블
    /// - Author: 장현우(heoun3089@gmail.com)
    func validateToken() -> Single<Response> {
        provider.rx
            .request(.validateToken)
    }
    
    
    /// 계정 정보를 저장합니다.
    /// - Parameter responseData: 계정 응답 데이터 객체
    /// - Author: 장현우(heoun3089@gmail.com)
    func saveAccount(responseData: CommonAccountResponseType) {
        loginKeychain.delete(responseData.userId ?? "")
        loginKeychain.delete(responseData.token ?? "")
        loginKeychain.delete(responseData.realName ?? "")
        loginKeychain.delete(responseData.nickName ?? "")
        loginKeychain.delete(responseData.yearOfAdmission ?? "")
        
        if let userId = responseData.userId,
           let email = responseData.email,
           let token = responseData.token {
            loginKeychain.set(userId, forKey: AccountKeys.userId.rawValue)
            loginKeychain.set(email, forKey: AccountKeys.email.rawValue)
            loginKeychain.set(token, forKey: AccountKeys.apiToken.rawValue)
            loginKeychain.set(responseData.realName ?? "", forKey: AccountKeys.realName.rawValue)
            loginKeychain.set(responseData.nickName ?? "", forKey: AccountKeys.nickName.rawValue)
            loginKeychain.set(responseData.universityName ?? "", forKey: AccountKeys.universityName.rawValue)
            loginKeychain.set(responseData.yearOfAdmission ?? "", forKey: AccountKeys.yearOfAdmission.rawValue)
            UserDefaults.standard.set([true, true], forKey: "expand")
        }
    }
}
