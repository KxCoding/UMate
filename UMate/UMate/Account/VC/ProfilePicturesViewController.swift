//
//  ProfilePicturesViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/08/04.
//

import UIKit

/// 사진 이미지를 포스팅할 새로운 이름 생성
extension Notification.Name {
    static let didTapProfilePics = Notification.Name("didTapProfilePics")
}

/// 이미지 선택화면
/// 황신택 (sinadsl1457@gmail.com)
class ProfilePicturesViewController: UIViewController {
    /// 유저 사진 키
    /// userInfo key로 사용합니다.
    static let picsKey = "picsKey"
    
    /// 이전화면으로 갑니다
    /// 사진을 선택하면 이전 화면으로 갑니다.
    /// - Parameter sender: cancelButtton
    @IBAction func cancelProfileView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 사진을 선택하면 노티피케이션 포스팅이 되고 사진의 태그값이 인포 키로 전달됩니다.
    /// - Parameter sender: 사진에 등록된 버튼
    @IBAction func matchTheSelectedPicture(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didTapProfilePics, object: nil, userInfo: [ProfilePicturesViewController.picsKey: sender.tag / 100])
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}

    
