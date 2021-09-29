//
//  DetailPostViewController.swift
//  DetailPostViewController
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 게시글 상세화면에대한 클래스
/// - Author: 남정은, 김정민(kimjm010@icloud.com)
class DetailPostViewController: RemoveObserverViewController {
    @IBOutlet weak var writeCommentContainerView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var detailPostTableView: UITableView!
    @IBOutlet weak var commentPlaceholderLabel: UILabel!
    @IBOutlet weak var commentContainerViewBottomConstraint: NSLayoutConstraint!
    
    /// 선택된 게시글에대한 속성
    /// - Author: 남정은
    var selectedPost: Post?
    
    /// 이미지를 클릭시에 추가되는 옵저버를 저장할 토큰
    /// - Author: 남정은
    var imageObserver: NSObjectProtocol?
    
    
    /// 댓글, 대댓글 작성을 위한 속성
    /// - Author: 김정민
    var commentId: Int?
    var originalCommentId: Int?
    var isReComment: Bool = false
    var sortedCommentList = dummyCommentList.sorted {
        if $0.originalCommentId == $1.originalCommentId {
            return $0.commentId < $1.commentId
        }
        
        return $0.originalCommentId < $1.originalCommentId
    }
    
    var depth: Int = 0
    
    /// 댓글 및 대댓글 저장하는 메소드
    /// - Parameter sender: 댓글 저장 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func saveComment(_ sender: Any) {
        
        guard let content = commentTextView.text, content.count > 0 else {
            alert(message: "댓글 내용을 입력해주세요 :)")
            return
        }
        
        if !isReComment {
            commentId = (sortedCommentList.max { $0.commentId < $1.commentId }?.commentId ?? 1) + 1
            originalCommentId = commentId
        }
        
        let newComment = Comment(image: UIImage(named: "3"),
                                 writer: "익명입니다",
                                 content: content,
                                 insertDate: Date(),
                                 heartCount: 0,
                                 commentId: commentId ?? 1,
                                 originalCommentId: originalCommentId ?? 1,
                                 isReComment: isReComment,
                                 postId: "")
        
        
        NotificationCenter.default.post(name: .newCommentDidInsert,
                                        object: nil,
                                        userInfo: ["data": newComment])
        isReComment = false
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 댓글을 단 사용자에게 쪽지를 보낼 수 있는 메소드
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func sendNote(_ sender: Any) {
        // TODO: 서버 구현 후 작업 예정입니다.
        #if DEBUG
        print("쪽지 보내기 성공!")
        #endif
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        writeCommentContainerView.layer.cornerRadius = 14
        
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main,using: { [weak self]  noti in
            guard let strongSelf = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let height = frame.height - 70
                let tableViewHeight = frame.height
                
                strongSelf.commentContainerViewBottomConstraint.constant = height
                
                var inset = strongSelf.detailPostTableView.contentInset
                inset.bottom = tableViewHeight
                strongSelf.detailPostTableView.contentInset = inset
                strongSelf.detailPostTableView.scrollIndicatorInsets = inset
            }
        })
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            strongSelf.commentContainerViewBottomConstraint.constant = 8
            
            var inset = strongSelf.detailPostTableView.contentInset
            inset.bottom = 8
            strongSelf.detailPostTableView.contentInset = inset
            strongSelf.detailPostTableView.scrollIndicatorInsets = inset
        })
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .newCommentDidInsert,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            if let newComment = noti.userInfo?["data"] as? Comment {
                self?.sortedCommentList.append(newComment)
                
                self?.sortedCommentList.sort {
                    if $0.originalCommentId == $1.originalCommentId {
                        return $0.commentId < $1.commentId
                    }
                    
                    return $0.originalCommentId < $1.originalCommentId
                }
                
                self?.detailPostTableView.reloadData()
                self?.commentTextView.text = nil
            }
        }
        
        tokens.append(token)
        
    }
    
    
    /// 뷰 계층에 모든 뷰들이 추가된 이후 호출
    /// - Author: 남정은
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 이미지를 클릭시에 ExpandImageViewController로 이동
        /// 이미지를 한 번 이상 클릭했을 때 중복되어서 옵저버가 등록되는 것을 방지
        /// - Author: 남정은
        if imageObserver == nil {
            imageObserver = NotificationCenter.default.addObserver(forName: .showImageVC,
                                                                   object: nil,
                                                                   queue: .main) {[weak self] _ in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "imageSegue", sender: nil)
            }
        }
    }
    
    
    deinit {
        if let token = imageObserver {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    /// 댓글을 왼쪽으로 Swipre해서 댓글을 신고하는 메소드입니다.
    /// - Parameter indexPath: 댓글의 IndexPath
    /// - Author: 김정민(kimjm010@icloud.com)
    func alertCommentDelete(_ indexPath: IndexPath) {
        // TODO: 서버 구현 후 작업 예정입니다.
        #if DEBUG
        print(#function)
        print("댓글을 신고하시겠습니까?")
        #endif
        
        self.alertComment()
    }
    
    
    /// 댓글을 오른쪽으로 Swipe해서 댓글을 삭제합니다
    /// - Parameter indexPath: 댓글의 IndexPath
    /// - Author: 김정민
    func deleteComment(_ indexPath: IndexPath) {
        
        alertDelete(title: "알림", message: "댓글을 삭제할까요?") { _ in
            if indexPath.section == 3 {
                dummyCommentList.remove(at: indexPath.row)
            }
            
            self.detailPostTableView.reloadData()
        }
    }
}



/// 게시글 상세화면에 대한 테이블뷰 데이터소스
/// - Author: 남정은
extension DetailPostViewController: UITableViewDataSource {
    /// 섹션의 개수를 리턴
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    /// 하나의 섹션안에 나타낼 row수를 지정
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - section: 테이블 뷰의 섹션
    /// - Returns: 섹션안에 나타낼 row수
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        /// 작성자, 제목, 내용
        case 0:
            return 1
            
        /// 게시글에 첨부된 이미지
        case 1:
            if let post = selectedPost, post.images.count == 0 {
                return 0
            }
            return 1
            
        /// 게시글에 포함된 좋아요, 댓글, 스크랩 개수
        case 2:
            return 1
            
        /// 게시글에 포함된 댓글
        case 3:
            return sortedCommentList.count
            
        default: return 0
        }
    }
    
    
    /// 셀의 데이터소스를  테이블 뷰의 특정 위치에 추가하기위해 호출
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - indexPath: 테이블 뷰의 row의 위치를 나타내는 인덱스패스
    /// - Returns: 구현을 완료한 셀
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        /// 게시글 내용 표시하는 셀
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostContentTableViewCell", for: indexPath) as! PostContentTableViewCell
            if let post = selectedPost {
                
                cell.configure(post: post)
                return cell
            }
            
        /// 이미지 표시하는 셀
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageTableViewCell", for: indexPath) as! PostImageTableViewCell
            if let post = selectedPost {
                
                cell.configure(post: post)
                return cell
            }
            
        /// 카운트 라벨 표시하는 셀
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountLabelTableViewCell", for: indexPath) as! CountLabelTableViewCell
            if let post = selectedPost {
                
                cell.configure(post: post)
                return cell
            }
            
        /// 댓글 및 대댓글 표시하는 셀
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            
            let target = sortedCommentList
            cell.configure(with: target[indexPath.row])
            
            return cell
            
        default: break
        }
        
        return UITableViewCell()
    }
}



extension DetailPostViewController: UITableViewDelegate {
    
    /// 댓글을 오른쪽으로 Swipe하여 댓글을 신고합니다.
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    /// - Returns: Leading끝에 표시될 SwipeAction
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 3  {
            let noti = UIContextualAction(style: .normal, title: "댓글 신고") { action, v, completion in
                self.alertComment()
                completion(true)
            }
            noti.backgroundColor = UIColor.darkGray
            
            let conf = UISwipeActionsConfiguration(actions: [noti])
            conf.performsFirstActionWithFullSwipe = true
            return conf
        }
        
        return nil
    }
    
    
    /// 댓글을 왼쪽으로 Swipe하여 댓글을 삭제합니다.
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    /// - Returns: Trailing끝에 표시될 SwipeAction
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 3 {
            let removeComment = UIContextualAction(style: .destructive, title: "댓글 삭제") { [weak self] action, v, completion in
                
                self?.alertDelete(title: "알림", message: "댓글을 삭제할까요?") { _ in
                    dummyCommentList.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
                completion(true)
            }
            
            removeComment.backgroundColor = .darkGray
            
            let conf = UISwipeActionsConfiguration(actions: [removeComment])
            conf.performsFirstActionWithFullSwipe = true
            return conf
        }
        
        return nil
    }
    
    
    /// 댓글에 ContextMenu를 표시합니다.
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    ///   - point: 컨텍스트 메뉴를 표시하기 위한
    /// - Returns: 선택한 indexPath의 포인트
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        if indexPath.section == 3 {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
                let notiAction =
                    UIAction(title: NSLocalizedString("댓글 신고", comment: "")) { action in
                        self.alertCommentDelete(indexPath)
                    }
                
                let deleteAction =
                    UIAction(title: NSLocalizedString("댓글 삭제", comment: ""),
                             attributes: .destructive) { action in
                        self.deleteComment(indexPath)
                    }
                
                return UIMenu(title: "", children: [notiAction, deleteAction])
            })
        }
        
        return nil
    }
    
    
    /// 댓글을 선택했을 때, 대댓글 작성 여부를 확인합니다.
    /// - Parameters:
    ///   - tableView: 디테일포스트 테이블 뷰
    ///   - indexPath: 선택될 셀의 indexPath
    /// - Returns: 선택된 셀의 indexPath
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let target = sortedCommentList[indexPath.row]
        
        if target.commentId != target.originalCommentId {
            return nil
        }
        
        return indexPath
    }
    
    
    /// 댓글을 선택할 때, 대댓글을 작성합니다.
    /// - Parameters:
    ///   - tableView: 디테일포슽트 테이블 뷰
    ///   - indexPath: 선택된 셀의 indexPath
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            alertVersion2(title: "알림", message: "대댓글을 작성하시겠습니까? :)") { _ in
                self.isReComment = true
                self.commentTextView.becomeFirstResponder()
            } handler2: { _ in
                self.commentTextView.resignFirstResponder()
            }
            
            let target = sortedCommentList[indexPath.row]
            commentId = (sortedCommentList.max { $0.commentId < $1.commentId }?.commentId ?? 1) + 1
            originalCommentId = target.commentId
        }
    }
}




extension DetailPostViewController: UITextViewDelegate {
    
    /// 댓글을 작성하려고할 때 Placeholder를 숨깁니다.
    /// - Parameter textView: commentTextView
    /// - Author: 김정민(kimjm010@icloud.com)
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentPlaceholderLabel.isHidden = true
    }
    
    
    /// 댓글 작성 완료했는데, 댓글이 없는 경우 다시 댓글 Placeholder를 표시합니다.
    /// - Parameter textView: commentTextView
    /// - Author: 김정민(kimjm010@icloud.com)
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let comment = commentTextView.text, comment.count > 0 else {
            commentPlaceholderLabel.isHidden = false
            return
        }
        
        commentPlaceholderLabel.isHidden = true
    }
}



