//
//  PasswordRootViewController.swift
//  PasswordRootViewController
//
//  Created by 안상희 on 2021/09/02.
//

import UIKit

class PasswordRootViewController: UIViewController {

    var didPasswordSet = false
    var password: String?
    var passwordCheck: String?
    lazy var charSet = CharacterSet(charactersIn: "0123456789").inverted
    
    @IBOutlet weak var firstContainerView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var thirdContainerView: UIView!
    @IBOutlet weak var fourthContainerView: UIView!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkPasswordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true)
        
        passwordField.becomeFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
