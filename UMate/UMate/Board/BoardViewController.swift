//
//  BoardViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit

struct Section {
    let title: String
    let options: [String]
    var isOpened = false
    var isBookmarked = false
}

class BoardViewController: UIViewController {

   
    @IBOutlet weak var boardListTableView: UITableView!
    
    
    var NonTitleboardList = [
        BoadNames(isExpanded: false, names: ["스크랩"].map{ Contact(name: $0, isBookmarked: false) }),
        BoadNames(isExpanded: false, names: ["자유게시판"].map{ Contact(name: $0, isBookmarked: false) }),
        BoadNames(isExpanded: false, names: ["인기글 게시판"].map{ Contact(name: $0, isBookmarked: false) }),
        BoadNames(isExpanded: false, names: ["졸업생 게시판"].map{ Contact(name: $0, isBookmarked: false) }),
        BoadNames(isExpanded: false, names: ["새내기 게시판"].map{ Contact(name: $0, isBookmarked: false) }),
        BoadNames(isExpanded: false, names: ["강의평가 게시판"].map{ Contact(name: $0, isBookmarked: false) })
    ]
    
    var TitleboardList = [
        BoadNames(title: "홍보", isExpanded: true, names: ["홍보 게시판", "동아리, 학회"].map{ Contact(name: $0, isBookmarked: false) }),
        BoadNames(title: "정보", isExpanded: true, names: ["정보 게시판", "취업, 진로"].map{ Contact(name: $0, isBookmarked: false) }),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


extension BoardViewController: UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return NonTitleboardList.count
        default:
            if !TitleboardList[section - 1]
                .isExpanded {
                return 0
            }
            return TitleboardList[section - 1].names.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NonTitleTableViewCell", for: indexPath) as! NonTitleTableViewCell
            cell.link = self
            
            cell.textLabel?.text = NonTitleboardList[indexPath.row].names.first?.name
            cell.accessoryView?.tintColor = NonTitleboardList[indexPath.section].names[0].isBookmarked ? UIColor.red : .lightGray
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
        cell.link = self
        cell.textLabel?.text = TitleboardList[indexPath.section - 1].names[indexPath.row].name
        cell.accessoryView?.tintColor = TitleboardList[indexPath.section - 1].names[indexPath.row].isBookmarked ? UIColor.red : .lightGray
        
        
        return cell
    }
    
}



extension BoardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section != 0 {
            let button = UIButton(type: .system)
            button.setTitle(TitleboardList[section - 1].title, for: .normal)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .brown
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            
            button.tag = section
            
            return button
        }
        let header = UIView()
        header.backgroundColor = .yellow
        return header
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section")
        
        //section은 0,1,2 그런데 버튼 태그도 0,1,2
        let section = button.tag
        
        var indexPathArr = [IndexPath]()
        
        //0일 때는 할 필요 없음
        if section != 0 {
            //배열은 0부터 시작이므로 button1,2인 경우만이니까 -1을 해주어야함.
            for row in TitleboardList[section - 1].names.indices {
                print(0, row)
                let indexPath = IndexPath(row: row, section: section)
                indexPathArr.append(indexPath)
            }
            
            let isExpanded = TitleboardList[section - 1].isExpanded
            TitleboardList[section - 1].isExpanded = !isExpanded
            
            
            if isExpanded {
                boardListTableView.deleteRows(at: indexPathArr, with: .fade)
            } else {
                boardListTableView.insertRows(at: indexPathArr, with: .fade)
            }
        }
    }
    
    
    
    func changeNonTitleBookmarkColor(cell: UITableViewCell) {
        //section이 0일 때 먼저
        guard let indexPathTapped = boardListTableView.indexPath(for: cell) else { return }
        
        guard let contact = NonTitleboardList[indexPathTapped.row].names.first else { return }
        
        let isBookmarked = contact.isBookmarked
        NonTitleboardList[indexPathTapped.row].names[0].isBookmarked = !isBookmarked
        
        cell.accessoryView?.tintColor = isBookmarked ? UIColor.lightGray : .red
    }
    
    func changeTitleBookmarkColor(cell: UITableViewCell) {
        //section이 1,2
        guard let indexPathTapped = boardListTableView.indexPath(for: cell) else { return }
        
        let contact = TitleboardList[indexPathTapped.section - 1].names[indexPathTapped.row]
        
        let isBookmarked = contact.isBookmarked
        TitleboardList[indexPathTapped.section - 1].names[indexPathTapped.row].isBookmarked = !isBookmarked
        
        cell.accessoryView?.tintColor = isBookmarked ? UIColor.lightGray : .red
    }
}
