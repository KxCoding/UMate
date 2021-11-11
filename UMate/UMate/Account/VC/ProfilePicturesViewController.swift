//
//  ProfilePicturesViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/04.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

/// 사진 이미지를 포스팅할 새로운 이름을 생성
/// - Author: 황신택 (sinadsl1457@gmail.com)
extension Notification.Name {
    static let didTapProfilePics = Notification.Name("didTapProfilePics")
}

/// 이미지 선택화면
/// - Author: 황신택 (sinadsl1457@gmail.com)
class ProfilePicturesViewController: UIViewController {
    /// 유저 사진 키
    /// 유저 인포 키로 사용합니다.
    static let picsKey = "picsKey"
    
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: cancelButtton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func dismissProfileView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 사진을 선택하면 노티피케이션을 포스팅 합니다. 사진의 태그값을 userInfo에 담아서 전달합니다.
    /// - Parameter sender: 컨테이너 뷰안에 있는 버튼
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func matchTheSelectedPicture(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: sender.tag / 100])
    }
    

    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

    
