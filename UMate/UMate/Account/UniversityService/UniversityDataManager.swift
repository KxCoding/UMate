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
    
    /// 싱글톤 인스턴스
    static let shared = UniversityDataManager()
    private init() { }
    
    /// 리소스 정리
    private let bag = DisposeBag()
    
    /// 로그인 키체인 인스턴스
    private let loginKeychain = KeychainSwift()
    
    /// 네트워크 서비스 객체
    private let provider = MoyaProvider<LoginAndPlaceReviewService>()
    
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
