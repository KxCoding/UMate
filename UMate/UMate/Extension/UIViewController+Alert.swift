//
//  UIViewController+Alert.swift
//  UMate
//
//  Created by 안상희 on 2021/07/21.
//

import UIKit
import RxSwift


extension UIViewController {
    
    /// 알림 메소드1 (alert)
    ///
    /// 확인 버튼만 존재하는 알림 메소드입니다.
    ///
    /// 추가적인 작업을 하고 싶을 경우, handler 파라미터를 이용해주세요.
    ///
    /// - Parameters:
    ///   - title: 알림 타이틀. 기본 값은 "알림"입니다.
    ///   - message: 알림 메시지.
    ///   - handler: 핸들러. handler의 기본값은 nil입니다.
    func alert(title: String = "알림", message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// 알림 메소드2  (alert)
    ///
    /// 확인, 취소 버튼이 존재하는 알림 메소드입니다.
    ///
    /// 추가적인 작업을 하고 싶을 경우, handler 파라미터를 이용해주세요. handler의 기본값은 nil입니다.
    ///
    /// - Parameters:
    ///   - title: 알림 타이틀. 기본 값은 "알림"입니다.
    ///   - message: 알림 메시지.
    ///   - handler: 첫번째 핸들러. handler의 기본값은 nil입니다.
    ///   - handler2: 두번째 핸들러. handler의 기본값은 nil입니다.
    func alertVersion2(title: String = "알림", message: String, handler: ((UIAlertAction) -> Void)? = nil, handler2: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: handler2)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// 알림 메소드3
    /// 액션시트 입니다.
    /// - Parameters:
    ///   - title: 알림 타이틀입니다.
    ///   - message: 알림 메시지입니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func alertComment(title: String, message: String) {
        let alertCommnet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertCommnet.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertCommnet.addAction(cancelAction)
        
        present(alertCommnet, animated: true, completion: nil)
    }
    
    
    /// 취소를 강조하는 알림메소드 입니다.
    /// '확인'버튼을 주의해서 눌러야할 경우 사용합니다.
    /// - Parameters:
    ///   - title: 제목
    ///   - message: 메시지
    ///   - handler: 버튼 처리 동작
    ///   - Author: 남정은(dlsl7080@gmail.com)
    func alertVersion3(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// 게시판 댓글 신고 알림입니다.
    /// - Parameters:
    ///   - title: 알림 타이틀. 기본값은 nil입니다.
    ///   - message: 알림 메시지입니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func alertComment(title: String? = nil, message: String = "댓글을 신고하시겠습니까?") {
        let alertCommnet = UIAlertController(title: title,
                                             message: message ,
                                             preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "확인", style: .destructive) { (action) in
            let reasonAlert = UIAlertController(title: "",
                                                message: "신고 사유를 선택해주세요.",
                                                preferredStyle: .actionSheet)
            
            let firstAction = UIAlertAction(title: "음란물/불건전한 만남 및 대화", style: .default) { _ in
                print("댓글 신고가 접수되었습니다.")
            }
            reasonAlert.addAction(firstAction)
            
            let secondAction = UIAlertAction(title: "낚시/놀람/도배", style: .default) { _ in
                print("댓글 신고가 접수되었습니다.")
            }
            reasonAlert.addAction(secondAction)
            
            let thirdAction = UIAlertAction(title: "상업적 광고 및 판매", style: .default) { _ in
                print("댓글 신고가 접수되었습니다.")
            }
            reasonAlert.addAction(thirdAction)
            
            let fourthAction = UIAlertAction(title: "정당/정치인 비하 및 선거운동", style: .default) { _ in
                print("댓글 신고가 접수되었습니다.")
            }
            reasonAlert.addAction(fourthAction)
            
            let fifthAction = UIAlertAction(title: "유출/사칭/사기", style: .default) { _ in
                print("댓글 신고가 접수되었습니다.")
            }
            reasonAlert.addAction(fifthAction)
            
            let sixthAction = UIAlertAction(title: "욕설/비하", style: .default) { _ in
                print("댓글 신고가 접수되었습니다.")
            }
            reasonAlert.addAction(sixthAction)
            
            let seventhAction = UIAlertAction(title: "게시판 성격에 부적절함", style: .default) { _ in
                print("댓글 신고가 접수되었습니다.")
            }
            reasonAlert.addAction(seventhAction)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            reasonAlert.addAction(cancelAction)
            
            self.present(reasonAlert, animated: true, completion: nil)
        }
        alertCommnet.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertCommnet.addAction(cancelAction)
        
        present(alertCommnet, animated: true, completion: nil)
    }
    

    /// 이미지 첨부 방법을 선택하는 알림입니다.
    /// - Parameters:
    ///   - title: 알림의 Title
    ///   - message: 알림의 Message
    /// - Returns: SelectImageAttachActionType을 방출하는 옵저버블
    func alertToSelectImageAttachWay(title: String, message: String) -> Observable<SelectImageAttachActionType> {
        return Observable.create { [unowned self] observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let findAction = UIAlertAction(title: "앨범에서 찾기", style: .default) { _ in
                observer.onNext(.find)
                observer.onCompleted()
            }
            alert.addAction(findAction)
            
            let takePhotoAction = UIAlertAction(title: "캡쳐하기", style: .default) { _ in
                observer.onNext(.take)
                observer.onCompleted()
            }
            alert.addAction(takePhotoAction)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                observer.onNext(.close)
                observer.onCompleted()
            }
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    /// 앨범 접근 권한에 따른 알림을 표시합니다.
    /// - Parameters:
    ///   - title: 알림의 title
    ///   - message: 알림의 message
    ///   - hanlder1: laterAction 클릭 이후의 동작
    /// - Author: 김정민(kimjm010@icloud.com)
    func alertToAccessPhotoLibrary(title: String = "사진 액세스 허용", message: String = "카메라 롤에서 콘텐츠를 공유하고 사진 및 동영상에 관한 다른 기능을 사용할 수 있게 됩니다. 설정으로 이동하여 '사진'을 누르세요 :)", hanlder1: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let laterAction = UIAlertAction(title: "나중에 하기", style: .cancel, handler: hanlder1)
        alert.addAction(laterAction)
        
        let goToSettingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(goToSettingAction)
        
        present(alert, animated: true, completion: nil)
    }
}
