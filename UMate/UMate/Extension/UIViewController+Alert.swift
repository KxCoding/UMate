//
//  UIViewController+Alert.swift
//  UMate
//
//  Created by 안상희 on 2021/07/21.
//

import UIKit

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
    ///
    /// 액션시트 입니다.
    ///
    /// - Parameters:
    ///   - title: 알림 타이틀입니다.
    ///   - message: 알림 메시지입니다.
    func alertComment(title: String, message: String) {
        let alertCommnet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertCommnet.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertCommnet.addAction(cancelAction)
        
        present(alertCommnet, animated: true, completion: nil)
    }
    
    
    /// 알림 메소드4
    ///
    /// 게시판 댓글 삭제 알림 메소드 입니다.
    ///
    /// - Parameters:
    ///   - title: 알림 타이틀. 기본값은 nil입니다.
    ///   - message: 알림 메시지. 기본값은 nil입니다.
    ///   - completion: 핸들러, 취소버튼은 nil이고, 확인 버튼은 handler로 직접 구현합니다.
    func alertDelete(title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertDelete = UIAlertController(title: "알림", message: "댓글을 삭제하시겠습니까?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .destructive, handler: handler)
        alertDelete.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertDelete.addAction(cancelAction)
        
        present(alertDelete, animated: true, completion: nil)
    }
    
    
    /// 게시판 댓글 신고 알림 메소드입니다.
    ///
    /// 액션시트입니다.
    ///
    /// - Parameters:
    ///   - title: 알림 타이틀. 기본값은 nil입니다.
    ///   - message: 알림 메시지입니다.
    func alertComment(title: String? = nil, message: String = "댓글을 신고하시겠습니까?") {
        let alertCommnet = UIAlertController(title: title, message: message , preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "확인", style: .destructive) { (action) in
            let reasonAlert = UIAlertController(title: "", message: "신고 사유를 선택해주세요.", preferredStyle: .actionSheet)
            
            let firstAction = UIAlertAction(title: "음란물/불건전한 만남 및 대화", style: .default) { _ in
                print("댓글 신고가 접수되었습니다.")
            }
            reasonAlert.addAction(firstAction)
            
            let secondAction = UIAlertAction(title: "낙씨/놀람/도배", style: .default) { _ in
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
}
