//
//  BoardViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


//##section접었다 펼쳤을 때 스크롤 조정해야함.##


class BoardViewController: UIViewController {
    
    var bookmarks: [Int:Bool] = [:]
    
    @IBOutlet weak var boardListTableView: UITableView!
    
    @IBAction func updateBookmark(_ sender: UIButton) {
        sender.tintColor = sender.tintColor == .lightGray ? .systemBlue : .lightGray
        
        if bookmarks.keys.contains(sender.tag) {
            if let isBookmarked = bookmarks[sender.tag] {
                bookmarks[sender.tag] = !isBookmarked
            }
        }
        //print(bookmarks[sender.tag])
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            if identifier == "freeSegue" && indexPath.row == 5 {
                return false
            }
            if identifier == "infoSegue" && indexPath != IndexPath(row: 0, section: 2) {
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? FreeBoardViewController {
                
                if indexPath.section == 2 && indexPath.row == 0 {
                    vc.selectedBoard = infoBoard
                    
                } else if indexPath.section == 0 {
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
            }
        }
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
            if expandableBoardList[section - 1].isExpanded { return expandableBoardList[section - 1].boardNames.count }
            return 0
            
        default: return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NonExpandableBoardTableViewCell", for: indexPath) as! NonExpandableBoardTableViewCell
            //재사용 셀을 생성
            //그 셀을 설정해서 리턴해야함.
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
        
        //게시판 index에 맞는 게시판으로 이동해야함.
        switch indexPath.section {
            
        case 0:
            switch indexPath.row {
            case 0,1,2,3,4:
                //스크랩 게시판으로 이동
                //자유 게시판으로 이동
                //인기글 게시판으로 이동
                //졸업생 게시판으로 이동
                //새내기 게시판으로 이동
                //prepare(for segue)를 이용
                break
            case 5:
                //강의평가 게시판으로 이동
                performSegue(withIdentifier: "lectureSegue", sender: self)
                break
            default:
                break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                //홍보 게시판으로 이동
                break
            case 1:
                //동아리, 학회 게시판으로 이동
                break
            default:
                break
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                //정보 게시판으로 이동
                break
            case 1:
                //취업, 진로 게시판으로 이동
                break
            default:
                break
            }
            
        default: break
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
            view.image.tintColor = .lightGray
            view.image.alpha = 0.2
            
            
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                button.topAnchor.constraint(equalTo: view.topAnchor),
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            button.addTarget(self, action: #selector(handleExpandClose(button:)), for: .touchUpInside)
            
            button.tag = section//  버튼 태그는 1,2
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


