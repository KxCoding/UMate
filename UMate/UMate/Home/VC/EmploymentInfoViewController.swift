//
//  EmploymentInfoViewController.swift
//  EmploymentInfoViewController
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

class EmploymentInfoViewController: UIViewController {
    /// 직무 분류 리스트
    var classsificationList = generateClassificationModelList()
    /// 회사 정보 리스트
    var companyList = generateCompanyList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
}

extension EmploymentInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        } else if section == 1 {
            return 0
        } else {
            return companyList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath)
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmploymentTableViewCell", for: indexPath) as! EmploymentTableViewCell
            cell.configure(with: classsificationList)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell", for: indexPath) as! CompanyTableViewCell
            let model = companyList[indexPath.row]
            
            cell.configureCompany(with: model)
            return cell
        }
        
    }
    
}



extension EmploymentInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else if indexPath.row == 1 {
            return 80
        } else {
            return 150
        }
    }
}
