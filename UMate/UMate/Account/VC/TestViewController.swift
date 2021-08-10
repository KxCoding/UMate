//
//  TestViewController.swift
//  TestViewController
//
//  Created by 황신택 on 2021/08/10.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: .didTapProfilePics, object: nil, queue: .main) { noti in
            guard let image = noti.userInfo?[ProfilePicturesViewController.picsKey] as? UIImageView else { return }
            
            self.imageView.image = image.image
        }
        
    }
    



}
