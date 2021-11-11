//
//  CommonViewController.swift
//  CommonViewController
//
//  Created by 안상희 on 2021/08/06.
//

import UIKit
import KeychainSwift
import RxCocoa
import RxSwift
import NSObject_Rx

/// 공통되는 기능을 포함한 뷰 컨트롤러
///  - Author: 안상희, 남정은(dlsl7080@gmail.com), 황신택
class CommonViewController: UIViewController {
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
    
    /// 키보드를 내리는 탭 제스쳐
    /// - Author: 황신택
    var tapGesture = UITapGestureRecognizer()
    
    
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
    
    
    /// 뷰를 탭하면 키보드를 내립니다.
    /// 뷰전체가 탭 영역입니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func didTapMakeLowerKeyboard() {
        tapGesture.rx.event
            .subscribe(onNext: { gesture in
                guard let targetView = gesture.view else { return }
                targetView.endEditing(true)
            })
            .disposed(by: rx.disposeBag)
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    /// 키보드 노티피케이션 옵저버를 추가해서 화면을 가리지않게합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func AddkeyboardNotification () {
        let willShowKeyboard = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }
        
        let willHideKeyboard = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            
        Observable.merge(willShowKeyboard, willHideKeyboard)
            .bind(to: view.rx.keyboardInset)
            .disposed(by: rx.disposeBag)
    
    }
      
    /// 라이트 모드 다크모드에 따라서  버튼 색상을 지정합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func makeChangeButtonColor(_ button: UIButton) {
        Observable.just(UIColor.dynamicColor(light: .white, dark: .white))
            .subscribe(onNext: { button.setTitleColor($0, for: .normal) })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 라이트 모드 다크모드에 따라서  네비게이션바 색상을 지정합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func makeChangeNavigationItemColor() {
        Observable.just(UIColor.dynamicColor(light: .darkGray, dark: .lightGray))
            .bind(to: (navigationController?.navigationBar.rx.tintColor)!)
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 소멸자에서 옵저버를 제거
    /// - Author: 남정은(dlsl7080@gmail.com)
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}


/// 커스텀 Binder익스텐션
/// 뷰의 높이를 키보드 높이만큼 올립니다.
/// - Author: 황신택 (sinadsl1457@gmail.com)
extension Reactive where Base: UIView {
    var keyboardInset: Binder<CGFloat> {
        return Binder(self.base) { view, height in
            UIView.animate(withDuration: 0.3) {
                view.frame.origin.y = 0 - height
            }
        }
    }
}

