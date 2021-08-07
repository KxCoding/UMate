//
//  ChooseEmailPasswordViewController.swift
//  ChooseEmailPasswordViewController
//
//  Created by 안상희 on 2021/08/08.
//

import UIKit

class ChooseEmailPasswordViewController: UIViewController {

    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailButton.setButtonTheme()
        passwordButton.setButtonTheme()
    }
}
