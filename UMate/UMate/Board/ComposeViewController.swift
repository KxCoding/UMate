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
    @IBOutlet weak var commmunityRuleView: UIView!
    @IBOutlet weak var contentCountLabel: UILabel!
    
    @IBOutlet var accessoryBar: UIToolbar!
    
    @IBOutlet weak var contentTextViewBottomConstraint: NSLayoutConstraint!
    
    
    @IBAction func selectWriter(_ sender: Any) {
        guard let selectWriter = sender as? UIBarButtonItem else { return }
        
        if selectWriter.tag == 101 {
            selectWriter.tintColor = .black
            selectWriter.tag = 0
        } else {
            selectWriter.tintColor = .lightGray
            selectWriter.tag = 101
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commmunityRuleView.layer.cornerRadius = commmunityRuleView.frame.height / 2
        
        postTitleTextField.becomeFirstResponder()
        postTitleTextField.inputAccessoryView = accessoryBar
        postContentTextView.inputAccessoryView = postTitleTextField.inputAccessoryView
        
        postTitleTextField.placeholder = "제목을 입력하세요."
        postTitleTextField.returnKeyType = .next
        postTitleTextField.delegate = self
        
        postContentTextView.text = "내용을 입력하세요."
        postContentTextView.textColor = .lightGray
        postContentTextView.delegate = self
 
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePost(_ sender: Any) {
        guard let title = postTitleTextField.text, title.count > 0, let content = postContentTextView.text, content.count > 0 else {
            alertNoContent(message: "게시글 작성을 취소하겠습니까?")
            return
        }
        
        let newPost = Post(images: [UIImage(named: "image4")], postTitle: title, postContent: content, postWriter: "아이디 데이터 넣기!", insertDate: Date(), likeCount: 3, commentCount: 2)
        freeBoard.posts.insert(newPost, at: 0)
        
        NotificationCenter.default.post(name: .newPostInsert, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
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
    
    func textViewDidChange(_ textView: UITextView) {
        contentCountLabel.text = "\(postContentTextView.text.count) / 500"
        
        if postContentTextView.text.count >= 500 {
            contentCountLabel.textColor = UIColor.systemRed
        } else {
            contentCountLabel.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentContentText = NSString(string: textView.text ?? "")
        let finalContentText = currentContentText.replacingCharacters(in: range, with: " ")
        
        if finalContentText.count > 500 {
            return false
        }
        
        return true
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentTitle = NSString(string: postTitleTextField.text ?? "")
        let finalTitle = currentTitle.replacingCharacters(in: range, with: " ")
        
        if finalTitle.count > 50 {
            return false
        }
        
        return true
    }
}



extension Notification.Name {
    static let newPostInsert = Notification.Name(rawValue: "newPostInsert")
}

