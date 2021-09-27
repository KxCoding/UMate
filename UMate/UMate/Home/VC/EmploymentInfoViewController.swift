//
//  EmploymentInfoViewController.swift
//  EmploymentInfoViewController
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

class EmploymentInfoViewController: UIViewController {
    /// 테이블뷰 아울렛
    @IBOutlet weak var listTableView: UITableView!
    
    /// 직무 분류 리스트
    var classsificationList = generateClassificationModelList()
    
    /// 회사 정보 리스트
    var companyList = generateCompanyList()
    
    /// 디밍뷰
    let transParentView = UIView()
    
    var jobList = [JobData.Job]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConfigureListViewController {
            vc.dimmingView = transParentView
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func addTransParentView() {
       let window = UIApplication.shared.delegate?.window
       transParentView.frame = window??.frame ?? view.frame
       view.addSubview(transParentView)
       transParentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
       
       let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransParentView))
       transParentView.addGestureRecognizer(tapgesture)
       transParentView.alpha = 0
        
       UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut) {
           self.transParentView.alpha = 0.5
       } completion: { _ in
           
       }
  
    }
    
    
    @IBAction func showConfigureList(_ sender: Any)  {
      addTransParentView()
    }
    
    
    @objc func removeTransParentView () {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut) {
            self.transParentView.alpha = 0
        } completion: { completion in
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        guard let jobData = DataManager.shared.getObject(of: JobData.self, fromJson: "companies") else { return }
        jobList = jobData.jobs.sorted(by: { $0.id < $1.id })
        listTableView.prefetchDataSource = self
        
        
    }
    
}


extension EmploymentInfoViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: { $0.row >= self.jobList.count - 5}) else {
            return
        }
        
        listTableView.reloadData()
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
        } else  {
            return jobList.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! SearchBarTableViewCell
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmploymentTableViewCell", for: indexPath) as! EmploymentTableViewCell
            
            cell.configure(with: classsificationList)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell", for: indexPath) as! CompanyTableViewCell
            let model = jobList[indexPath.row]
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
            return 60
        } else {
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
