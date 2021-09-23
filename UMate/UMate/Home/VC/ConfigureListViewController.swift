//
//  ConfigureListViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/09/22.
//

import UIKit

struct UserInfoIdentifires {
    static let fistJobData = "fistJobData"
    static let secondJobData = "secondJobData"
    static let finalfistJobData = "finalfistJobData"
    static let finalsecondJobData = "finalsecondJobData"
}

class ConfigureListViewController: UIViewController {
    
    @IBOutlet weak var configureListTableView: UITableView!
    var workList = generateWorkList()
    var regionList = generateWorkRegionList()
    var degreeList = generateDegreeList()
    var platFormList = generatePlatFormList()
    var dimmingView: UIView?
    var ischecked = false
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut) {
            if let dimmingView = self.dimmingView {
                dimmingView.alpha = 0
            }
            
        } completion: { completion in
            
        }
    }
    
    
    @IBAction func cancelConfigureList(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func resetAllConfigure(_ sender: Any) {
    }
    
    
    @IBAction func adaptConfigure(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let register = UINib(nibName: "ConfigureListHeader", bundle: nil)
        configureListTableView.register(register, forHeaderFooterViewReuseIdentifier: "ConfigureListHeader")
        
    }
    
}



extension ConfigureListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return workList.count
        case 1:
            return regionList.count
        case 2:
            return degreeList.count
        case 3:
            return 1
        case 4:
            return platFormList.count
        case 5:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigureTableViewCell", for: indexPath) as! ConfigureTableViewCell
            cell.selectionStyle = .none
            let target = workList[indexPath.row]
            cell.classificationLabel.text = target.classification1
            cell.classificationLabel2.text = target.classification2
          
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
            cell.selectionStyle = .none
            cell.region1.text = regionList[indexPath.row].region1
            cell.region2.text = regionList[indexPath.row].region2
            cell.region3.text = regionList[indexPath.row].region3
            cell.region4.text = regionList[indexPath.row].region4
            cell.region5.text = regionList[indexPath.row].region5
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentTableViewCell", for: indexPath) as! SegmentTableViewCell
            cell.selectionStyle = .none
            let target = degreeList[indexPath.row]
            cell.degreeSegment.setTitle(target.none, forSegmentAt: 0)
            cell.degreeSegment.setTitle(target.college, forSegmentAt: 1)
            cell.degreeSegment.setTitle(target.university, forSegmentAt: 2)
            cell.degreeSegment.setTitle(target.graduateSchool, forSegmentAt: 3)
            cell.degreeSegment.setTitle(target.doctorate, forSegmentAt: 4)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CareerTableViewCell", for: indexPath) as! CareerTableViewCell
            cell.selectionStyle = .none
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlatFormTableViewCell", for: indexPath) as! PlatFormTableViewCell
            cell.selectionStyle = .none
            let target = platFormList[indexPath.row]
            cell.firstPlatFormLabel.text = target.first
            cell.secondPlatFormLabel.text = target.second
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as!
            ButtonTableViewCell
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return workList.first?.header
        case 1:
            return regionList.first?.header
        case 2:
            return degreeList.first?.header
        case 3:
            return "경력"
        case 4:
            return platFormList.first?.header
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = configureListTableView.dequeueReusableHeaderFooterView(withIdentifier: "ConfigureListHeader") as! ConfigureListHeaderView
        switch section {
        case 0:
            header.headerTitle.text = workList.first?.header
            return header
        case 1:
            header.headerTitle.text = regionList.first?.header
            return header
        case 2:
            header.headerTitle.text = degreeList.first?.header
            return header
        case 3:
            header.headerTitle.text = "경력"
            return header
        case 4:
            header.headerTitle.text = platFormList.first?.header
            return header
        default:
            return UIView()
        }
    }
    
}


extension ConfigureListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  
        switch indexPath.section {
        case 0:
            return 50
        case 1:
            return 80
        case 2:
            return 70
        case 3:
            return 50
        case 4:
            return 50
        case 5:
            return 60
        default:
            return 70
        }
    }
    
}
