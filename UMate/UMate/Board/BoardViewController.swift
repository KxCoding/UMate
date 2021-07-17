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

    private var sections = [Section]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sections = [
            Section(title: "스크랩", options: []),
            Section(title: "자유게시판", options: []),
            Section(title: "인기글 게시판", options: []),
            Section(title: "졸업생 게시판", options: []),
            Section(title: "새내기 게시판", options: []),
            Section(title: "강의평가 게시판", options: []),
            Section(title: "홍보", options: ["  #홍보 게시판", "  #동아리, 학회"], isOpened: false),
            Section(title: "정보", options: ["  #정보 게시판", "  #취업, 진로"], isOpened: false)
        ]

    }
}


extension BoardViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpened {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardListTableViewCell", for: indexPath) as! BoardListTableViewCell
        
        if indexPath.row == 0 {
            cell.boardName?.text = sections[indexPath.section].title
            
            switch sections[indexPath.section].options.count {
            case 0:
                cell.bookmarkImageView.isHidden = false
            default:
                cell.bookmarkImageView.isHidden = true
            }
        } else {
            cell.boardName?.text = sections[indexPath.section].options[indexPath.row - 1]
            cell.bookmarkImageView.isHidden = false
        }
        
    
        return cell
    }
}



extension BoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            print("tapped sub cell")
        }
        
        
    }
}

