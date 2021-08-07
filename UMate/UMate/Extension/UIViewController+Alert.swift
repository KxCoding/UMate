//
//  UIViewController+Alert.swift
//  UMate
//
//  Created by 안상희 on 2021/07/21.
//

import UIKit

extension UIViewController {
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    func alertWithNoAction(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    func alertNoContent(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (noti) in
            self?.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    func alertComment(title: String, message: String) {
        let alertCommnet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertCommnet.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertCommnet.addAction(cancelAction)
        
        present(alertCommnet, animated: true, completion: nil)
    }
    
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
