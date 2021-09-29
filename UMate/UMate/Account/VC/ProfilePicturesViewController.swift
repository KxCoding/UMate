//
//  ProfilePicturesViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/04.
//

import UIKit

/// 새로운 노티피케이션 이름 생성
/// 사진을 탭할시 포스팅에 필요한 노티피케이션 이름
extension Notification.Name {
    static let didTapProfilePics = Notification.Name("didTapProfilePics")
}

/// 프로파일이미지를 선택할수있는 클래스
/// Author: 황신택
class ProfilePicturesViewController: UIViewController {
    /// UserDefaults에 button의 tag값을 저장할때 사용되는 키
    static let picsKey = "picsKey"
    
    /// 사진을 선택시 dismiss, 취소 버튼도 동일
    /// - Parameter sender: Any
    @IBAction func cancelProfileView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}



extension ProfilePicturesViewController {
    /// 노티피케이션을 포스팅하고, 유저인포 딕셔너리를 이용하여 해당 이미지들의 tag 값을 전달
    /// - Parameter sender: UIButton
    @IBAction func matchTheSelectedPicture(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: sender.tag / 100])
        
    }
    
}
