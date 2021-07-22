//
//  BoardViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


//##section접었다 펼쳤을 때 스크롤 조정해야함.##


class BoardViewController: UIViewController {
    

    @IBOutlet weak var boardListTableView: UITableView!
    
    var bookmarks: [Int:Bool] = [:]
   
    @IBAction func updateBookmarK(_ sender: UIButton) {
        
        sender.tintColor = sender.tintColor == .darkGray ? .systemBlue : .darkGray 
    
        if bookmarks.keys.contains(sender.tag) {
            if let isBookmarked = bookmarks[sender.tag] {
                bookmarks[sender.tag] = !isBookmarked
            }
        }

        //print(bookmarks[sender.tag])
        
        
    }
    

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            if identifier == "freeSegue" && indexPath.row == 0 {
                return false
            } else if identifier == "freeSegue" && indexPath.row == 5 {
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? FreeBoardViewController {
                
                switch indexPath.row {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        postDic["abc123"]?.forEach({ comment in
        //            print(comment.commentContent)
        //        })
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

    let freeBoard = Board(boardTitle: "자유 게시판",
                          posts: [Post(image: UIImage(named:"image1"),
                                       postTitle: "아자아자",
                                       postContent: "5개월동안 열심히하자!",
                                       postWriter: "정은",
                                       insertDate: Date(timeIntervalSinceNow: -3000),
                                       likeCount: 3,
                                       commentCount: 12),
                                  Post(image: UIImage(named:"image2"),
                                       postTitle: "to catch this in the",
                                       postContent: "5UIConstraintBasedLayoutDebugging!",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -200),
                                       likeCount: 3,
                                       commentCount: 13),
                                  Post(image: UIImage(named:""),
                                       postTitle: "Lorem ipsum dolor sit ame",
                                       postContent: " consectetur adipiscing elit,labore et dolore magna aliqua. Ut enim ad minim anim id est laborum.",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -388),
                                       likeCount: 3,
                                       commentCount: 32),
                                  Post(image: UIImage(named:""),
                                       postTitle: "H. Rackham",
                                       postContent: "s mistaken idea of denouncing pleasure and praising pain was born and I will giv!",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -3600 * 100),
                                       likeCount: 3,
                                       commentCount: 18),
                                  Post(image: UIImage(named:""),
                                       postTitle: "foregroundColor",
                                       postContent: "n macOS, the value of this attribute is an NSColor instance. In iOS, tvOS, watchOS, and Mac Catalyst, the value of this attribute is a UICo",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -23 * 100),
                                       likeCount: 4,
                                       commentCount: 18),
                                  Post(image: UIImage(named:"image1"),
                                       postTitle: "Where does it come from",
                                       postContent: "consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -23 * 100),
                                       likeCount: 4,
                                       commentCount: 18),
                                  Post(image: UIImage(named:""),
                                       postTitle: "foregroundColor",
                                       postContent: "n macOS, the value of this attribute is an NSColor instance. In iOS, tvOS, watchOS, and Mac Catalyst, the value of this attribute is a UICo",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -23 * 100),
                                       likeCount: 4,
                                       commentCount: 18),
                                  Post(image: UIImage(named:"image2"),
                                       postTitle: "Where can I get some?",
                                       postContent: "ave suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are g",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -23 * 100),
                                       likeCount: 4,
                                       commentCount: 18),
                                  Post(image: UIImage(named:""),
                                       postTitle: "Why do we use it?",
                                       postContent: "nterested. Sections 1.10.32 an",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -23 * 100),
                                       likeCount: 4,
                                       commentCount: 18),
                                  Post(image: UIImage(named:"image1"),
                                       postTitle: "Where does it come from",
                                       postContent: "consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -23 * 100),
                                       likeCount: 4,
                                       commentCount: 18),
                                  Post(image: UIImage(named:""),
                                       postTitle: "foregroundColor",
                                       postContent: "n macOS, the value of this attribute is an NSColor instance. In iOS, tvOS, watchOS, and Mac Catalyst, the value of this attribute is a UICo",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -23 * 100),
                                       likeCount: 4,
                                       commentCount: 18),
                                  Post(image: UIImage(named:"image2"),
                                       postTitle: "Where can I get some?",
                                       postContent: "ave suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are g",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -23 * 100),
                                       likeCount: 4,
                                       commentCount: 18),
                                  Post(image: UIImage(named:"image1"),
                                       postTitle: "아자아자",
                                       postContent: "5개월동안 열심히하자!",
                                       postWriter: "정은",
                                       insertDate: Date(timeIntervalSinceNow: -3000),
                                       likeCount: 3,
                                       commentCount: 12),
                                  Post(image: UIImage(named:"image2"),
                                       postTitle: "to catch this in the",
                                       postContent: "5UIConstraintBasedLayoutDebugging!",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -200),
                                       likeCount: 3,
                                       commentCount: 13),
                                  Post(image: UIImage(named:""),
                                       postTitle: "Lorem ipsum dolor sit ame",
                                       postContent: " consectetur adipiscing elit,labore et dolore magna aliqua. Ut enim ad minim anim id est laborum.",
                                       postWriter: "category",
                                       insertDate: Date(timeIntervalSinceNow: -388),
                                       likeCount: 3,
                                       commentCount: 32),
                                 ])
    let popularPostBoard = Board(boardTitle: "인기글 게시판",
                                 posts: [Post(image: UIImage(named:"image3"),
                                              postTitle: "아자아자",
                                              postContent: "5개월동안 열심히하자!",
                                              postWriter: "정은",
                                              insertDate: Date(),
                                              likeCount: 3,
                                              commentCount: 12),
                                         Post(image: UIImage(named:"image4"),
                                              postTitle: "to catch this in the",
                                              postContent: "5UIConstraintBasedLayoutDebugging!",
                                              postWriter: "category",
                                              insertDate: Date(),
                                              likeCount: 3,
                                              commentCount: 13),
                                        ])
    let graduateBoard = Board(boardTitle: "졸업생 게시판",
                              posts: [Post(image: UIImage(named:"image5"),
                                           postTitle: "아자아자",
                                           postContent: "5개월동안 열심히하자!",
                                           postWriter: "정은",
                                           insertDate: Date(),
                                           likeCount: 3,
                                           commentCount: 12),
                                      Post(image: UIImage(named:"image6"),
                                           postTitle: "Lorem ipsum dolor sit ame",
                                           postContent: " consectetur adipiscing elit,labore et dolore magna aliqua. Ut enim ad minim anim id est laborum.",
                                           postWriter: "category",
                                           insertDate: Date(),
                                           likeCount: 3,
                                           commentCount: 32),
                                     ])
    let freshmanBoard =  Board(boardTitle: "신입생 게시판",
                               posts: [Post(image: UIImage(named:"image7"),
                                            postTitle: "Lorem ipsum dolor sit ame",
                                            postContent: " consectetur adipiscing elit,labore et dolore magna aliqua. Ut enim ad minim anim id est laborum.",
                                            postWriter: "category",
                                            insertDate: Date(),
                                            likeCount: 3,
                                            commentCount: 32),
                                       Post(image: UIImage(named:"image8"),
                                            postTitle: "H. Rackham",
                                            postContent: "s mistaken idea of denouncing pleasure and praising pain was born and I will giv!",
                                            postWriter: "category",
                                            insertDate: Date(),
                                            likeCount: 3,
                                            commentCount: 18),
                                      ])
    
    var nonExpandableBoardList = [BoardUI(sectionName: nil, boardNames: ["스크랩"]),
                                  BoardUI(sectionName: nil, boardNames: ["자유 게시판"]),
                                  BoardUI(sectionName: nil, boardNames: ["인기글 게시판"]),
                                  BoardUI(sectionName: nil, boardNames: ["졸업생 게시판"]),
                                  BoardUI(sectionName: nil, boardNames: ["신입생 게시판"]),
                                  BoardUI(sectionName: nil, boardNames: ["강의평가 게시판"]),]
    
    var expandableBoardList = [BoardUI(sectionName: "홍보", isExpanded: true ,boardNames: ["홍보 게시판", "동아리, 학회"]),
                               BoardUI(sectionName: "정보", isExpanded: true ,boardNames: ["정보 게시판", "취업, 진로"]),]
    
    let commentsInPost: [String: [Comment]] = ["abc123": [Comment(commentContent: "화이팅!!", commentWriter: "1004"),
                                                          Comment(commentContent: "바나나", commentWriter: "119"),
                                                          Comment(commentContent: "사과!!", commentWriter: "나무")]]
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
        cell.configure(boardList: expandableBoardList, indexPath: indexPath)
        cell.board = self
        return cell
    }
}



extension BoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
       //게시판 index에 맞는 게시판으로 이동해야함.
        switch indexPath.section {
        case 0:
            
            //1,2,3,4는 같은 viewController사용하고 게시글 목록만 바꿔줘도 될 듯
            switch indexPath.row {
            case 0:
                //스크랩 게시판으로 이동
                break
            case 1,2,3,4:
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
            return 70
        default: break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Header에 들어갈 버튼
        if section != 0 {
            let button = UIButton(type: .custom)
            
            button.setTitle(expandableBoardList[section - 1].sectionName, for: .normal)
            
            button.titleLabel?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           
            
            button.addTarget(self, action: #selector(handleExpandClose(button:)), for: .touchUpInside)
            
            button.tag = section//  버튼 태그는 1,2
            return button
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


