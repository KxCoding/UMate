//
//  EmailChangeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/08/04.
//

import UIKit

class EmailChangeViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func changeButtonDidTapped(_ sender: UIButton) {
        
        alert(title: "알림", message: "비밀번호가 변경되었습니다.")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
