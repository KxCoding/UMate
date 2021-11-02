//
//  CommonViewController.swift
//  CommonViewController
//
//  Created by 안상희 on 2021/08/06.
//

import UIKit
import KeychainSwift

/// 공통되는 기능을 포함한 뷰 컨트롤러
///  - Author: 안상희, 남정은(dlsl7080@gmail.com), 황신택
class CommonViewController: UIViewController {
    /// 데이터 엔코더
    ///  - Author: 남정은(dlsl7080@gmail.com)
    let encoder = JSONEncoder()
    
    /// 날짜 파싱 포매터
    /// - Author: 남정은(dlsl7080@gmail.com)
    let postDateFormatter: ISO8601DateFormatter = {
       let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return f
    }()
    
    /// 서버 요청 API
    /// - Author: 남정은(dlsl7080@gmail.com)
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        return session
    }()
    
    /// 메인 화면인 홈으로 이동합니다.
    /// - Author: 황신택, 안상희
    static func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController =
        storyboard.instantiateViewController(withIdentifier: "MainTabBarController")

        (UIApplication.shared.connectedScenes.first?.delegate as?
         SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    

    /// 암호 입력 화면을 보여줍니다.
    /// - Author: 안상희
    static func showPasswordViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let passwordViewController =
        storyboard.instantiateViewController(withIdentifier: "CommonPasswordSB")
        
        (UIApplication.shared.connectedScenes.first?.delegate as?
         SceneDelegate)?.changeRootViewController(passwordViewController)
    }
    
    
    /// Touch ID / Face ID 암호 화면을 보여줍니다.
    /// - Author: 안상희
    static func showFaceIdViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let emptyViewController =
        storyboard.instantiateViewController(withIdentifier: "EmptySB")
        
        (UIApplication.shared.connectedScenes.first?.delegate as?
         SceneDelegate)?.changeRootViewController(emptyViewController)
    }

    
    /// 편집이 활성화 된 텍스트 필드
    /// - Author: 황신택
    var activatedTextField: UITextField? = nil
    
    /// 옵저버 제거를 위해 토큰을 담는 배열
    /// - Author: 남정은(dlsl7080@gmail.com)
    var tokens = [NSObjectProtocol]()
    
    /// 키체인 인스턴스
    /// - Author: 황신택
    let keychainPrefix = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// 인기 대외활동 데이터 목록
    /// - Author: 황신택
    var contestDataList = [ContestSingleData.PopularContests]()
    
    /// 대외활동 데이터 목록
    /// - Author: 황신택
    var contestDetailDataList = [ContestSingleData.Contests]()
    
    /// 검색된 대외활동 목록
    /// - Author: 황신택
    var searchedContestDataList = [ContestSingleData.Contests]()
    
    /// 채용 데이터 목록
    /// - Author: 황신택
    var jobList = [JobData.Job]()
    
    /// 검색된 채용 데이터 목록
    /// - Author: 황신택
    var searchedList = [JobData.Job]()

    /// 검색 진행 플래그
    /// - Author: 황신택
    var isSearching = false
    
    /// 대외활동 데이터 패칭 플래그
    /// - Author: 황신택
    var isFetching = false
    
    
    /// 제이슨 데이터를 파싱 하고 파싱 된 데이터를 아이디로 정렬해서 오름차순으로 저장합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func getContestData() {
        guard !isFetching else { return }
        isFetching = true
        
        DispatchQueue.global().async {
            guard let contestData = PlaceDataManager.shared.getObject(of: ContestSingleData.self, fromJson: "contests") else { return }
            
            self.contestDataList = contestData.favoriteList
            self.contestDetailDataList = contestData.contestList.sorted(by: { $0.id < $1.id})
        }
    }
    
    
    /// 제이슨 데이터를 파싱 하고 파싱 된 데이터를 아이디로 정렬해서 오름차순으로 저장합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func getJobData() {
        guard !isFetching else { return }
        
        isFetching = true
        
        DispatchQueue.global().async {
            defer {
                self.isFetching = false
            }
            
            guard let jobData = PlaceDataManager.shared.getObject(of: JobData.self, fromJson: "companies") else { return }
            self.jobList = jobData.jobs.sorted(by: { $0.id < $1.id })
        }
    }
    
    
    /// 소멸자에서 옵저버를 제거
    /// - Author: 남정은(dlsl7080@gmail.com)
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}



/// local에서 인증서 문제가 발생할 때 사용
///  - Author: 남정은(dlsl7080@gmail.com)
extension CommonViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let trust = challenge.protectionSpace.serverTrust!
        
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
}





