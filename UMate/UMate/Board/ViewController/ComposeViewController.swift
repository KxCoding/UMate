//
//  ComposeViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/07/28.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var postContentContainerView: UIView!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var commmunityRuleView: UIView!
    
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commmunityRuleView.layer.cornerRadius = commmunityRuleView.frame.height / 2

        postTitleTextField.placeholder = "제목"
        postTitleTextField.returnKeyType = .next
        postTitleTextField.delegate = self
        
        postContentTextView.text = "내용을 입력하세요."
        postContentTextView.textColor = .lightGray
        postContentTextView.delegate = self
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self]  noti in
            guard let strongSelf = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                
                var inset = strongSelf.infoTextView.contentInset
                inset.bottom = height
                strongSelf.infoTextView.contentInset = inset
                
                inset = strongSelf.infoTextView.verticalScrollIndicatorInsets
                inset.bottom = height
                strongSelf.infoTextView.scrollIndicatorInsets = inset
            }
        })
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePost(_ sender: Any) {
        guard let title = postTitleTextField.text, title.count > 0, let content = postContentTextView.text, content.count > 0 else {
            return
        }
        
        let newPost = Post(images: [UIImage(named: "image4")], postTitle: title, postContent: content, postWriter: "익명1", insertDate: Date(), likeCount: 3, commentCount: 2)
        freeBoard.posts.insert(newPost, at: 0)
        
        NotificationCenter.default.post(name: ComposeViewController.newPostInsert, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
}


extension ComposeViewController {
    static let newPostInsert = Notification.Name(rawValue: "newPostInsert")
}


extension ComposeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력하세요." || postContentTextView.isFirstResponder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "글을 입력하세요."
            textView.textColor = UIColor.lightGray
        }
    }
}

extension ComposeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case postTitleTextField:
            if postTitleTextField.isFirstResponder {
                postContentTextView.becomeFirstResponder()
            }
        default:
            break
        }
        
        return true
    }
}

