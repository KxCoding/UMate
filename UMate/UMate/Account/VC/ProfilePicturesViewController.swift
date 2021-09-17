//
//  ProfilePicturesViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/04.
//

import UIKit

/// 새로운 노티피케이션 이름을 만듬.
extension Notification.Name {
    static let didTapProfilePics = Notification.Name("didTapProfilePics")
}

class ProfilePicturesViewController: UIViewController {
    
    /// 오타방지를 유저 인포 ID를 만듬
    static let picsKey = "picsKey"
    
    /// 사진을 선택시 dismiss, 취소 버튼도 동일.
    @IBAction func cancelProfileView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}



extension ProfilePicturesViewController {
    /// 노티피케이션 포스트를 등록하고, 유저인포 딕셔너리를 이용하여 Assets 이미지 id와 매칭시킴.
    @IBAction func matchTheSelectedPicture(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: sender.tag / 100])
        
    }
    
}
