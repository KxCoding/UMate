//
//  EmploymentInfoViewController.swift
//  EmploymentInfoViewController
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

/// 채용정보 뷰를 담당하는 클래스
/// Author: 황신택
class EmploymentInfoViewController: UIViewController {
    /// 테이블뷰 아울렛
    @IBOutlet weak var listTableView: UITableView!
    
    /// 디밍뷰
    let transParentView = UIView()
    
    /// Json파싱 데이타
    var jobList = [JobData.Job]()
    
    /// 특정 조건에 데이타를 가져오기위한 속성
    var hasMore = true
    
    /// 패치 중복 유무에 대한 속성
    var isFetching = false
    
    /// 이전화면
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
        

    /// 제이슨 파싱 메소드
    func fetchJobData() {
        /// 패치를 안했거나 hasMore가 트루인 경우에만 접근 가능
        guard hasMore && !isFetching else { return }
        
        /// 접근이 가능하면 isFetching을 true
        isFetching = true
        
        /// 파싱할 url을 바인딩
        guard let urlStr = jobList.first?.url else { return }
        
        /// urlStr을 URL타입으로 바인딩
        if let url = URL(string: urlStr) {
            let session = URLSession.shared
            /// 제이슨 형식을 파싱함
            let task = session.dataTask(with: url) { data, response, error in
                defer {
                    self.isFetching = false
                }
                
                if let error = error {
                    self.hasMore = false
                    print(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    self.hasMore = false
                    return
                }
                
                guard let  data = data else {
                    self.hasMore = false
                    return
                }
                
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(JobData.self, from: data)
                    self.hasMore = result.jobs.count > 0
                    self.jobList.append(contentsOf: result.jobs)
                    DispatchQueue.main.async {
                        self.listTableView.reloadData()
                    }
                } catch  {
                    self.hasMore = false
                    print(error)
                }
                
            }
            
            task.resume()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        guard let jobData = DataManager.shared.getObject(of: JobData.self, fromJson: "companies") else { return }
        jobList = jobData.jobs.sorted(by: { $0.id < $1.id })
        listTableView.prefetchDataSource = self
        fetchJobData()
    }
    
}


extension EmploymentInfoViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: { $0.row >= self.jobList.count - 5}) else {
            return
        }
         fetchJobData()
    }
}



extension EmploymentInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else  {
            return jobList.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! SearchBarTableViewCell
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
        } else {
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
