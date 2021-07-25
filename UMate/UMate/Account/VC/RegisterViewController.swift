//
//  RegisterViewController.swift
//  RegisterViewController
//
//  Created by 황신택 on 2021/07/24.
//

import UIKit
import DropDown

class RegisterViewController: UIViewController {
    
 
    @IBOutlet weak var enterenceYearView: UIView!
    @IBOutlet weak var universityView: UIView!
    @IBOutlet weak var nextButton: UIView!
    @IBOutlet weak var enterenceTextField: UITextField!
    
    
    let menu: DropDown = {
        let menu = DropDown()
          menu.dataSource = [
            "2021학번",
            "2020학번",
            "2019학번",
            "2018학번",
            "2017학번",
            "2016학번",
            "2015학번",
            "2013학번",
            "2012학번",
            "2011학번",
            "2010학번",
            "2009학번",
            "2008학번",
            "2007학번"
        ]
    
        return menu
    }()
    
    @IBAction func enterenceYearButton(_ sender: UIButton) {
        menu.show()
        menu.selectionAction = { [weak self] index, item in
            self?.enterenceTextField.text = item
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [enterenceYearView, universityView, nextButton].forEach { $0?.layer.cornerRadius = 14
            $0?.clipsToBounds = true
        }
        
        menu.anchorView = enterenceYearView
        guard let height = menu.anchorView?.plainView.bounds.height else { return }
        menu.bottomOffset = CGPoint(x: 0, y: height)
        menu.width = 150
        enterenceTextField.text = ""
        
    }
    
}
