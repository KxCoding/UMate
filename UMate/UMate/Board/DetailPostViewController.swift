//
//  DetailPostViewController.swift
//  DetailPostViewController
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


extension Notification.Name {
    static let newCommentDidInsert = Notification.Name(rawValue: "newCommentDidInsert")
    static let newReCommentDidInsert = Notification.Name(rawValue: "newReCommentDidInsert")
}




class DetailPostViewController: UIViewController {
    
    var selectedPost: Post?
    
    @IBOutlet weak var writeCommentContainerView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var detailPostTableView: UITableView!
    @IBOutlet weak var commentPlaceholderLabel: UILabel!
    @IBOutlet weak var commentContainerViewBottomConstraint: NSLayoutConstraint!
    
    var tokens = [NSObjectProtocol]()
    var imageObserver: NSObjectProtocol?
    
    var commentId: Int = 0
    var originalCommentId: Int = 0
    var isReComment = false
    var reCommentId: Int = 0
    
    
    /// 댓글 및 대댓글 저장하는 메소드
    /// - Parameter sender: DetailPostViewController
    @IBAction func saveCommentBtn(_ sender: Any) {
        let originalComment = dummyCommentList.filter { $0.isReComment == false }
        commentId = (dummyCommentList.count) + 1
        
        #if DEBUG
        print(#function, commentId, originalCommentId, originalComment.count)
        #endif
        
        if isReComment == false {
            
            guard let comment = commentTextView.text, comment.count > 0 else {
                alertVersion2(message: "댓글을 입력하세요")
                return
            }
            
            let newComment = [Comment(image: UIImage(systemName: "person"),
                                      writer: "익명2",
                                      content: comment,
                                      insertDate: Date(),
                                      commentId: commentId,
                                      isReComment: false,
                                      postId: "")]
            dummyCommentList.append(contentsOf: newComment)
            
            
            #if DEBUG
            print("Comment", "CommentId", commentId, "originalCommentId", originalCommentId, "reCommentId", reCommentId)
            #endif
            
            NotificationCenter.default.post(name: .newCommentDidInsert, object: nil)
        } else {
            
            if commentTextView.isFirstResponder {
                guard let comment = commentTextView.text, comment.count > 0 else {
                    alertVersion2(message: "대댓글 입력하세요")
                    return
                }
                
                let reComment = dummyCommentList.filter { $0.isReComment }
                reCommentId = (reComment.count) + 1
                
                let newReComment = [Comment(image: UIImage(systemName: "person"),
                                            writer: "익명2",
                                            content: comment,
                                            insertDate: Date(),
                                            commentId: dummyCommentList.first?.commentId ?? 0,
                                            originalCommentId: originalCommentId,
                                            isReComment: true,
                                            postId: "")]
                dummyCommentList.append(contentsOf: newReComment)
                
                #if DEBUG
                print("Recomment", "CommentId", commentId, "originalCommentId", originalCommentId, "reCommentId", reCommentId)
                #endif
                
                NotificationCenter.default.post(name: .newReCommentDidInsert, object: nil)
                
                commentTextView.resignFirstResponder()
                self.isReComment = false
            }
        }
    }
    
    
    @IBAction func reCommentBtn(_ sender: Any) {
        let alertReComment = UIAlertController(title: "알림", message: "대댓글을 작성하시겠습니까?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.isReComment = true
            self.commentTextView.becomeFirstResponder()
        }
        alertReComment.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertReComment.addAction(cancelAction)
        
        
        present(alertReComment, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writeCommentContainerView.layer.cornerRadius = 14
        
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                           object: nil,
                                                           queue: .main,
                                                           using: { [weak self]  noti in
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
        
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                       object: nil,
                                                       queue: .main,
                                                       using: { [weak self] (noti) in
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
            self?.detailPostTableView.reloadData()
            self?.commentTextView.text = nil
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .newReCommentDidInsert,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            self?.detailPostTableView.reloadData()
            self?.commentTextView.text = nil
        }
        tokens.append(token)
    }
    
    
    /// view계층에 모든 view들이 추가된 이후 호출되는 메소드
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 이미지를 클릭시에 ExpandImageViewController로 이동
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
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = imageObserver {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    /// 댓글을 왼쪽으로 Swipre해서 댓글을 신고하는 메소드
    /// - Parameter indexPath: 댓글의 IndexPath
    func performNoti(_ indexPath: IndexPath) {
        #if DEBUG
        print(#function)
        print("댓글을 신고하시겠습니까?")
        #endif
        
        self.alertComment()
    }
    
    
    /// 댓글을 오른쪽으로 Swipe해서 댓글을 삭제하는 메소드
    /// - Parameter indexPath: 댓글의 IndexPath
    func performDelete(_ indexPath: IndexPath) {
        #if DEBUG
        print(#function)
        print("댓글이 삭제되었습니다.")
        #endif
        
        // 댓글 삭제할 것인지 다시 한 번 묻는 알림창
        alertDelete(title: "알림", message: "댓글을 삭제할까요?") { _ in
            if indexPath.section == 3 {
                dummyCommentList.remove(at: indexPath.row)
            }
            
            self.detailPostTableView.reloadData()
        }
    }
}




extension DetailPostViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        /// Post Content
        case 0:
            return 1
            
        /// Post Image
        case 1:
            if let post = selectedPost, post.images.count == 0 {
                return 0
            }
            return 1
            
        /// Post Count Lable
        case 2:
            return 1
            
        /// Post Comment
        case 3:
            return dummyCommentList.count
            
        default: return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        /// 게시글 내용 표시하는 셀
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostContentTableViewCell", for: indexPath) as! PostContentTableViewCell
            guard let post = selectedPost else { return cell }
            
            cell.configure(post: post)
            return cell
            
        /// 이미지 표시하는 셀
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageTableViewCell", for: indexPath) as! PostImageTableViewCell
            guard let post = selectedPost else { return cell }
            
            cell.configure(post: post)
            return cell
            
        /// 카운트 라벨 표시하는 셀
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountLabelTableViewCell", for: indexPath) as! CountLabelTableViewCell
            guard let post = selectedPost else { return cell }
            
            cell.configure(post: post)
            return cell
            
        /// 댓글 및 대댓글 표시하는 셀
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            
            let target = dummyCommentList
            cell.configure(with: target[indexPath.row])
            
            return cell
            
        default: break
        }
        
        return UITableViewCell()
    }
    
    
    /// 댓글을 오른쪽으로 Swipe하여 댓글을 신고할 수 있는 메소드
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    /// - Returns: Leading끝에 표시될 SwipeAction
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
    
    
    /// 댓글을 왼쪽으로 Swipe하여 댓글을 삭제할 수 있는 메소드
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    /// - Returns: Trailing끝에 표시될 SwipeAction
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
    
    
    /// 댓글에 ContextMenu를 표시하는 메소드
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    ///   - point:
    /// - Returns: 해당 indexPath의 ContextMenu
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        if indexPath.section == 3 {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
                let notiAction =
                    UIAction(title: NSLocalizedString("댓글 신고", comment: "")) { action in
                        self.performNoti(indexPath)
                    }
                
                let deleteAction =
                    UIAction(title: NSLocalizedString("댓글 삭제", comment: ""),
                             attributes: .destructive) { action in
                        self.performDelete(indexPath)
                    }
                
                return UIMenu(title: "", children: [notiAction, deleteAction])
            })
        }
        
        return nil
    }
}



// 댓글의 Placeholder 표시 여부를 결정
extension DetailPostViewController: UITextViewDelegate {
    
    /// 댓글을 작성하려고할 때 Placeholder를 숨기는 메소드
    /// - Parameter textView: commentTextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentPlaceholderLabel.isHidden = true
    }
    
    
    /// 댓글 작성 완료했는데, 댓글이 없는 경우 다시 댓글 Placeholder를 표시하는 메소드
    /// - Parameter textView: commentTextView
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let comment = commentTextView.text, comment.count > 0 else {
            commentPlaceholderLabel.isHidden = false
            return
        }
        
        commentPlaceholderLabel.isHidden = true
    }
}



