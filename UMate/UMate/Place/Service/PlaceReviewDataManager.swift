//
//  PlaceReviewDataManager.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/23.
//

import Foundation
import KeychainSwift
import Moya
import RxSwift


extension Notification.Name {
    /// 리뷰 작성 화면에서 확인 버튼을 누르면 보낼 노티피케이션
    /// - Author: 장현우(heoun3089@gmail.com)
    static let reviewDidApplied = Notification.Name(rawValue: "reviewDidApplied")
    static let reviewPostFailed = Notification.Name(rawValue: "reviewPostFailed")
    static let reviewDidEdited = Notification.Name(rawValue: "reviewDidEdited")
    static let reviewEditFailed = Notification.Name(rawValue: "reviewEditFailed")
    static let errorOccured = Notification.Name(rawValue: "errorOccured")
}



/// 상점 리뷰 데이터 관리
/// - Author: 장현우(heoun3089@gmail.com)
class PlaceReviewDataManager {
    
    /// 싱글톤 인스턴스
    static let shared = PlaceReviewDataManager()
    private init() { }
    
    /// 리소스 정리
    let bag = DisposeBag()
    
    /// 로그인 키체인 인스턴스
    let loginKeychain = KeychainSwift()
    
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
    
    /// 전체 상점 리뷰 목록
    var allPlaceReviewList = [PlaceReviewList.PlaceReview]()
    
    /// 유저 아이디와 일치하는 상점 리뷰 목록
    var placeReviewList = [PlaceReviewList.PlaceReview]()
    
    
    /// 전체 상점 리뷰 목록을 다운로드합니다.
    /// - Parameters:
    ///   - vc: 이 메소드를 호출하는 뷰컨트롤러
    ///   - completion: 완료 블록
    /// - Author: 장현우(heoun3089@gmail.com)
    func fetchAllReview(vc: CommonViewController, completion: @escaping () -> ()) {
        provider.rx.request(.allPlaceReivewList)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case .success(let response):
                    self.allPlaceReviewList = PlaceReviewList.parse(data: response.data, vc: vc)
                    
                    completion()
                case .failure(let error):
                    vc.alert(message: error.localizedDescription)
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 유저 아이디와 일치하는 상점 리뷰 목록을 다운로드합니다.
    /// - Parameters:
    ///   - vc: 이 메소드를 호출하는 뷰컨트롤러
    ///   - completion: 완료 블록
    /// - Author: 장현우(heoun3089@gmail.com)
    func fetchReview(vc: CommonViewController, completion: @escaping () -> ()) {
        provider = {
            if let token = loginKeychain.get(AccountKeys.apiToken.rawValue) {
                let authPlugin = AccessTokenPlugin { _ in token }
                
                return MoyaProvider<LoginAndPlaceReviewService>(plugins: [authPlugin])
            } else {
                return MoyaProvider<LoginAndPlaceReviewService>()
            }
        }()
        
        provider.rx.request(.placeReviewList)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case .success(let response):
                    self.placeReviewList = PlaceReviewList.parse(data: response.data, vc: vc)
                    
                    completion()
                case .failure(let error):
                    vc.alert(message: error.localizedDescription)
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 상점 리뷰를 삭제합니다.
    /// - Parameters:
    ///   - reviewId: 리뷰 아이디
    ///   - vc: 이 메소드를 호출하는 뷰컨트롤러
    /// - Author: 장현우(heoun3089@gmail.com)
    func deleteReview(reviewId: Int, vc: ReviewManagingViewController) {
        provider.rx.request(.removePlaceReview(reviewId))
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case ResultCode.ok.rawValue:
                        vc.reviewDeletedLoaf.show(.custom(1.2))
                    default:
                        vc.alert(message: "서버에서 리뷰 정보를 찾을 수 없습니다.")
                    }
                    
                case .failure(let error):
                    vc.alert(message: error.localizedDescription)
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 상점 리뷰를 저장합니다.
    /// - Parameter placeReviewPostData: 저장할 상점 리뷰 데이터
    /// - Author: 장현우(heoun3089@gmail.com)
    func saveReview(placeReviewPostData: PlaceReviewPostData) {
        provider.rx.request(.savePlaceReview(placeReviewPostData))
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case ResultCode.ok.rawValue:
                        NotificationCenter.default.post(name: .reviewDidApplied, object: nil)
                    default:
                        NotificationCenter.default.post(name: .reviewPostFailed, object: nil)
                    }
                    
                case .failure(_):
                    NotificationCenter.default.post(name: .errorOccured, object: nil)
                }
            }
            .disposed(by: bag)
    }
    
    
    /// 상점 리뷰를 수정합니다.
    /// - Parameter placeReviewPutData: 수정된 리뷰 데이터
    /// - Author: 장현우(heoun3089@gmail.com)
    func editReview(placeReviewPutData: PlaceReviewPutData) {
        provider.rx.request(.editPlaceReview(placeReviewPutData))
            .subscribe { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case ResultCode.ok.rawValue:
                        NotificationCenter.default.post(name: .reviewDidEdited, object: nil)
                    default:
                        NotificationCenter.default.post(name: .reviewEditFailed, object: nil)
                    }
                    
                case .failure(_):
                    NotificationCenter.default.post(name: .errorOccured, object: nil)
                }
            }
            .disposed(by: bag)
    }
}
