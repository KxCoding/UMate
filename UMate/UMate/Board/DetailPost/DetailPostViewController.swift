//
//  DetailPostViewController.swift
//  DetailPostViewController
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit

class DetailPostViewController: UIViewController {
    
    var selectedPost: Post?
    
    @IBOutlet weak var writeCommentContainerView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var detailPostTableView: UITableView!
    
    @IBAction func saveCommentBtn(_ sender: Any) {
        guard let comment = commentTextView.text, comment.count > 0 else {
            alertNoContent(message: "댓글을 입력하세요")
            return
        }
        
        let newComment = Comment(image: UIImage(systemName: "person"), writer: "익명2", content: comment, insertDate: Date(), heartCount: 3)
        Comment.dummyCommentList.append(newComment)
        
        NotificationCenter.default.post(name: DetailPostViewController.newCommentDidInsert, object: nil)
    }
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    var newCommentToken: NSObjectProtocol?
    @IBOutlet weak var commentContainerViewBottomConstraint: NSLayoutConstraint!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailPostTableView.rowHeight = UITableView.automaticDimension
        detailPostTableView.estimatedRowHeight = 180
        writeCommentContainerView.layer.cornerRadius = 14
        
        commentTextView.text = "댓글을 입력하세요."
        commentTextView.textColor = .lightGray
        commentTextView.delegate = self
        
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
            inset.bottom = 0
            strongSelf.detailPostTableView.contentInset = inset
            strongSelf.detailPostTableView.scrollIndicatorInsets = inset
        })
        
        newCommentToken = NotificationCenter.default.addObserver(forName: DetailPostViewController.newCommentDidInsert, object: nil, queue: .main) { [weak self] (noti) in
            
            self?.detailPostTableView.reloadData()
            self?.commentTextView.text = nil
        }
    }
    
    func performNoti(_ indexPath: IndexPath) {
        print(#function)
    }
    
    func performDelete(_ indexPath: IndexPath) {
        print(#function)
    }
}



extension DetailPostViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return Comment.dummyCommentList.count
        default: return 0
        } //댓글과 대댓글은 section 2,3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostContentTableViewCell", for: indexPath) as! PostContentTableViewCell
            guard let post = selectedPost else { return cell }
            //print("1")
            cell.configure(post: post)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageTableViewCell", for: indexPath) as! PostImageTableViewCell
            guard let post = selectedPost else { return cell }
            //print(post.images.count)
            cell.configure(post: post)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            
            let target = Comment.dummyCommentList
            cell.configure(with: target[indexPath.row])
            
            return cell
            
            
        default: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let noti = UIContextualAction(style: .normal, title: "댓글 신고") { action, v, completion in
            print("댓글을 신고합니다.")
            //댓글신고 ActionSheet로 알림 띄우기
            self.alertComment(title: "", message: "댓글을 신고하시겠습니까?")
            completion(true)
        }
        noti.backgroundColor = UIColor.darkGray
        noti.image = UIImage(named: "siren")
        
        let conf = UISwipeActionsConfiguration(actions: [noti])
        conf.performsFirstActionWithFullSwipe = false
        return conf
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeComment = UIContextualAction(style: .destructive, title: "댓글 삭제") { action, v, completion in
            print("댓글이 삭제되었습니다.")
            // Alert로 정말 삭제할 것인지 알림 띄우기
            Comment.dummyCommentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        removeComment.backgroundColor = .lightGray
        removeComment.image = UIImage(systemName: "trash")
        
        
        let conf = UISwipeActionsConfiguration(actions: [removeComment])
        conf.performsFirstActionWithFullSwipe = true
        return conf
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
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
}



extension DetailPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "댓글을 입력하세요." || commentTextView.isFirstResponder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "댓글을 입력하세요"
            textView.textColor = .lightGray
        }
    }
}



extension DetailPostViewController {
    static let newCommentDidInsert = Notification.Name(rawValue: "newCommentDidInsert")
}
