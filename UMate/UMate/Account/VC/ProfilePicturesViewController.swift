//
//  ProfilePicturesViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/04.
//

import UIKit

/// 새로운 노티피케이션 이름을 만듭니다.
extension Notification.Name {
    static let didTapProfilePics = Notification.Name("didTapProfilePics")
}

/// 프로파일이미지를 선택할수있는 클래스입니다.
/// Author: 황신택
class ProfilePicturesViewController: UIViewController {
    /// 오타방지를 유저 인포 ID입니다
    static let picsKey = "picsKey"
    
    /// 사진을 선택시 dismiss, 취소 버튼도 동일.
    /// - Parameter sender: Any
    @IBAction func cancelProfileView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}



extension ProfilePicturesViewController {
    /// 노티피케이션 포스트를 등록하고, 유저인포 딕셔너리를 이용하여 해당 이미지들의 tag 값을 전달합니다.
    /// - Parameter sender: UIButton
    @IBAction func matchTheSelectedPicture(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: sender.tag / 100])
        
    }
    
}
