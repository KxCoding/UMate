//
//  BoardViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


// TODO: section접었다 펼쳤을 때 스크롤 조정해야함

class BoardViewController: UIViewController {
    
    var bookmarks: [Int:Bool] = [:]
    
    @IBOutlet weak var boardListTableView: UITableView!
    
    
    @IBAction func updateBookmark(_ sender: UIButton) {
        sender.tintColor = sender.tintColor == .lightGray ? .black : .lightGray
        
        if bookmarks.keys.contains(sender.tag) {
            if let isBookmarked = bookmarks[sender.tag] {
                bookmarks[sender.tag] = !isBookmarked
            }
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            if cell.reuseIdentifier == "NonExpandableBoardTableViewCell" && indexPath.row == 5 {
                return false //강의평가 게시판
            }
            if cell.reuseIdentifier == "ExpandableBoardTableViewCell" && indexPath == IndexPath(row: 0, section: 2){
                return false //정보게시판. 얘는 기본 게시판임.
            }
        }
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? FreeBoardViewController, segue.identifier == "infoSegue" {
            vc.selectedBoard = infoBoard
        } 
        
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? FreeBoardViewController {
              
                if indexPath.section == 0 {
                    switch indexPath.row {
                    case 0:
                        vc.selectedBoard = scrapBoard
                    case 1:
                        vc.selectedBoard = freeBoard
                    case 2:
                        vc.selectedBoard = popularPostBoard
                    case 3:
                        vc.selectedBoard = graduateBoard
                    case 4:
                        vc.selectedBoard = freshmanBoard
                    default: break
                    }
                }
            } else if let vc = segue.destination as? CategoryBoardViewController {
                switch indexPath.section {
                case 1:
                    if indexPath.row == 0 {
                        vc.selectedBoard = publicityBoard
                    } else if indexPath.row == 1 {
                        vc.selectedBoard = clubBoard
                    }
                case 2:
                   if indexPath.row == 1 {
                        vc.selectedBoard = careerBoard
                    }
                default: break
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardListTableView.register(BoardCustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        for row in 0..<nonExpandableBoardList.count {
            bookmarks[row + 100] = false
        }
        
        var sectionNum = 2
        for section in expandableBoardList {
            for row in 0..<section.boardNames.count {
                bookmarks[sectionNum * 100 + row] = false
            }
            sectionNum += 1
        }
    }
}




extension BoardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        //non expandable board
        case 0:
            return nonExpandableBoardList.count
            
        //expandable board
        case 1,2:
            if expandableBoardList[section - 1].isExpanded {
                return expandableBoardList[section - 1].boardNames.count
            }
            return 0
            
        default: return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NonExpandableBoardTableViewCell", for: indexPath) as! NonExpandableBoardTableViewCell
        
            cell.configure(boardList: nonExpandableBoardList, indexPath: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableBoardTableViewCell", for: indexPath) as! ExpandableBoardTableViewCell
        
        cell.board = self
        cell.configure(boardList: expandableBoardList, indexPath: indexPath)
        return cell
    }
}




extension BoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 5 {
            performSegue(withIdentifier: "lectureSegue", sender: self)
            
        } else if indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: "infoSegue", sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        case 1, 2:
            return 80
        default: break
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Header에 들어갈 버튼
        if section != 0 {
            let button = UIButton(type: .custom)
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! BoardCustomHeaderView
            view.title.text = expandableBoardList[section - 1].sectionName
            view.title.textColor = .darkGray
            view.title.font = UIFont.boldSystemFont(ofSize: 23)
            view.image.image = UIImage(named: "downarrow")
            view.image.tintColor = .darkGray
            
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                button.topAnchor.constraint(equalTo: view.topAnchor),
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            button.addTarget(self, action: #selector(handleExpandClose(button:)), for: .touchUpInside)
            
            button.tag = section// 버튼 태그는 1,2
            return view
        }
        
        let header = UIView()
        //header.alpha = 1
        return header
    }
    
    
    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag// 섹션은 1,2
        
        var indexPathArr = [IndexPath]()
        
        for row in expandableBoardList[section - 1].boardNames.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPathArr.append(indexPath)
        }
        
        expandableBoardList[section - 1].isExpanded = !expandableBoardList[section - 1].isExpanded
        
        if expandableBoardList[section - 1].isExpanded {
            boardListTableView.insertRows(at: indexPathArr, with: .fade)
        } else {
            boardListTableView.deleteRows(at: indexPathArr, with: .fade)
        }
    }
}


