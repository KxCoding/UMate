//
//  RegisterViewController.swift
//  RegisterViewController
//
//  Created by 황신택 on 2021/07/24.
//

import UIKit

class RegisterViewController: UIViewController {

 
    @IBOutlet weak var enterenceYearView: UIView!
    
    @IBOutlet weak var universityView: UIView!
    
    @IBOutlet weak var nextButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        [enterenceYearView, universityView, nextButton].forEach { $0?.layer.cornerRadius = 14
            $0?.clipsToBounds = true
        }
            
        
        
    }
    

    

}
