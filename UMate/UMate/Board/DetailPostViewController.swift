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
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    var newCommentToken: NSObjectProtocol?
    var newReCommentToken: NSObjectProtocol?
    var imageObserver: NSObjectProtocol?
    
    
    @IBAction func saveCommentBtn(_ sender: Any) {
        guard let comment = commentTextView.text, comment.count > 0 else {
            alertVersion2(message: "댓글을 입력하세요")
            return
        }
        
        let newComment = Comment(image: UIImage(systemName: "person"),
                                 writer: "익명2",
                                 content: comment,
                                 insertDate: Date(),
                                 heartCount: 3)
        dummyCommentList.append(newComment)
        
        NotificationCenter.default.post(name: .newCommentDidInsert, object: nil)
    }
    
    
    @IBAction func reCommentBtn(_ sender: Any) {
        let alertReComment = UIAlertController(title: "알림", message: "대댓글을 작성하시겠습니까?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.commentTextView.becomeFirstResponder()
        }
        alertReComment.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertReComment.addAction(cancelAction)
        
        present(alertReComment, animated: true, completion: nil)
        
        if commentTextView.isFirstResponder {
            guard let comment = commentTextView.text, comment.count > 0 else {
                alertVersion2(message: "대댓글 입력하세요")
                return
            }
            
            let newReComment = [Comment(image: UIImage(systemName: "person"),
                                        writer: "익명2",
                                        content: comment,
                                        insertDate: Date(),
                                        heartCount: 3)]
            dummyReCommentList.append(newReComment)
            
            NotificationCenter.default.post(name: .newReCommentDidInsert, object: nil)
            
            commentTextView.resignFirstResponder()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writeCommentContainerView.layer.cornerRadius = 14
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self]  noti in
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
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            strongSelf.commentContainerViewBottomConstraint.constant = 8
            
            var inset = strongSelf.detailPostTableView.contentInset
            inset.bottom = 8
            strongSelf.detailPostTableView.contentInset = inset
            strongSelf.detailPostTableView.scrollIndicatorInsets = inset
        })
        
        newCommentToken = NotificationCenter.default.addObserver(forName: .newCommentDidInsert, object: nil, queue: .main) { [weak self] (noti) in
            self?.detailPostTableView.reloadData()
            self?.commentTextView.text = nil
        }
        
        newReCommentToken = NotificationCenter.default.addObserver(forName: .newReCommentDidInsert, object: nil, queue: .main) { [weak self] (noti) in
            self?.detailPostTableView.reloadData()
            self?.commentTextView.text = nil
        }
    }
    
    
    /// view계층에 모든 view들이 추가된 이후 호출되는 메소드
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 이미지를 클릭시에 ExpandImageViewController로 이동
        imageObserver = NotificationCenter.default.addObserver(forName: .showImageVC,
                                                               object: nil,
                                                               queue: .main) {[weak self] _ in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "imageSegue", sender: nil)
        }
    }
    
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = newCommentToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = newReCommentToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let toekn = imageObserver {
            NotificationCenter.default.removeObserver(toekn)
        }
    }
    
    
    // TODO: 댓글 신고 기능 구현
    func performNoti(_ indexPath: IndexPath) {
        #if DEBUG
        print(#function)
        print("댓글을 신고하시겠습니까?")
        #endif
        
        self.alertComment()
    }
    
    
    func performDelete(_ indexPath: IndexPath) {
        #if DEBUG
        print(#function)
        print("댓글이 삭제되었습니다.")
        #endif
        
        alertDelete(title: "알림", message: "댓글을 삭제할까요?") { _ in
            if indexPath.section == 3 {
                dummyCommentList.remove(at: indexPath.row)
            } else {
                dummyReCommentList.remove(at: indexPath.row)
            }
            
            self.detailPostTableView.reloadData()
        }
    }
}




extension DetailPostViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
            
        /// Post ReComment
        case 4:
            return dummyReCommentList.count
            
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
            
        /// 댓글 표시하는 셀
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            
            let target = dummyCommentList
            cell.configure(with: target[indexPath.row])
            
            return cell
            
        /// 대댓글 표시하는 셀
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReCommentTableViewCell", for: indexPath) as! ReCommentTableViewCell
            
            let target = dummyReCommentList
            cell.configure(with: target[indexPath.row], indexPath: indexPath)
            
            return cell
            
        default: break
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section >= 3  {
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
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section >= 3 {
            let removeComment = UIContextualAction(style: .destructive, title: "댓글 삭제") { [weak self] action, v, completion in
                
                self?.alertDelete(title: "알림", message: "댓글을 삭제할까요?") { _ in
                    
                    if indexPath.section == 3 {
                        dummyCommentList.remove(at: indexPath.row)
                    } else {
                        dummyReCommentList.remove(at: indexPath.row)
                    }
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
    
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        if indexPath.section >= 3 {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
                let notiAction =
                    UIAction(title: NSLocalizedString("댓글 신고", comment: ""),
                             image: UIImage(named: "siren")) { action in
                        self.performNoti(indexPath)
                    }
                let deleteAction =
                    UIAction(title: NSLocalizedString("댓글 삭제", comment: ""),
                             image: UIImage(systemName: "trash"),
                             attributes: .destructive) { action in
                        self.performDelete(indexPath)
                    }
                return UIMenu(title: "", children: [notiAction, deleteAction])
            })
        }
        
        return nil
    }
}




extension DetailPostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentPlaceholderLabel.isHidden = true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let comment = commentTextView.text, comment.count > 0 else {
            commentPlaceholderLabel.isHidden = false
            return
        }
        
        commentPlaceholderLabel.isHidden = true
    }
}



