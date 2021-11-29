//
//  UniversityDataManager.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/28.
//

import Foundation
import KeychainSwift
import Moya
import RxSwift


/// 대학교 데이터 관리
/// - Author: 장현우(heoun3089@gmail.com)
class UniversityDataManager {
    
    /// 싱글톤
    static let shared = UniversityDataManager()
    
    /// 싱글톤
    private init() { }
    
    /// 리소스 정리
    private let bag = DisposeBag()
    
    /// 로그인 키체인 인스턴스
    private let loginKeychain = KeychainSwift()
    
    /// 임시 토큰
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiOWFkYTkwZjItMWYyMC00MTM2LWI0NmEtZGExNjk1ZTcxNmNlIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiI5YWRhOTBmMi0xZjIwLTQxMzYtYjQ2YS1kYTE2OTVlNzE2Y2UiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ0ZXN0MTdAdGVzdC5jb20iLCJleHAiOjE2Njk2NTc0NTUsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjU1NDE1IiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NTU0MTUifQ.LTyYjszBcPv_yq9tZgdheY5LfH9NIlU3aF_EMhB2dag"
    
    /// 네트워크 서비스 객체
    ///
    /// Bearer 토큰 인증 방식을 사용합니다.
    private lazy var provider: MoyaProvider<UniversityService> = {
        let authPlugin = AccessTokenPlugin { _ in self.token }
        
        return MoyaProvider<UniversityService>(plugins: [authPlugin])
    }()
    
    /// 대학교 목록
    var universityList = [UniversityList.University]()
    
    
    /// 대학교 목록을 다운로드합니다.
    /// - Parameter vc: 메소드를 실행하는 뷰컨트롤러
    /// - Author: 장현우(heoun3089@gmail.com)
    func fetchUniversity(vc: CommonViewController, completion: @escaping () -> ()) {
        provider.rx.request(.universityList)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case .success(let response):
                    self.universityList = UniversityList.parse(data: response.data, vc: vc)
                    
                    completion()
                case .failure(let error):
                    vc.alert(message: error.localizedDescription)
                }
            }
            .disposed(by: bag)
    }
}
