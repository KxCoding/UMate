//
//  ComposeViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/07/28.
//

import UIKit


extension Notification.Name {
    static let newPostInsert = Notification.Name(rawValue: "newPostInsert")
}




class ComposeViewController: UIViewController {
    
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var commmunityRuleView: UIView!
    @IBOutlet weak var contentCountLabel: UILabel!
    @IBOutlet weak var contentPlacehoderLabel: UILabel!
    @IBOutlet var accessoryBar: UIToolbar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageList = [UIImage]()
    var imageToken: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commmunityRuleView.layer.cornerRadius = commmunityRuleView.frame.height / 2
        
        postTitleTextField.becomeFirstResponder()
        postTitleTextField.inputAccessoryView = accessoryBar
        postContentTextView.inputAccessoryView = postTitleTextField.inputAccessoryView
        
        imageToken = NotificationCenter.default.addObserver(forName: .imageDidSelect,
                                                            object: nil,
                                                            queue: .main) { [weak self] (noti) in
            
            if let img = noti.userInfo?["img"] as? [UIImage] {
                self?.imageList.append(contentsOf: img)
                self?.imageCollectionView.reloadData()
            }
        }
    }
    
    deinit {
        if let token = imageToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func savePost(_ sender: Any) {
        guard let title = postTitleTextField.text, title.count > 0,
              let content = postContentTextView.text, content.count > 0 else {
            
            alertVersion2(message: "게시글 작성을 취소하겠습니까?")
            return
        }
        
        let newPost = Post(images: [UIImage(named: "image4")],
                           postTitle: title,
                           postContent: content,
                           postWriter: "아이디 데이터 넣기!",
                           insertDate: Date(), likeCount: 3,
                           commentCount: 2)
        freeBoard.posts.insert(newPost, at: 0)
        
        NotificationCenter.default.post(name: .newPostInsert, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // TODO: 홍보,정보 게시판 카테고리 선택항목으로 변경할 것
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
}




// 게시글(본문) placeHolder 설정 및 글자수 제한(500자)
extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentPlacehoderLabel.isHidden = true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let content = postContentTextView.text, content.count > 0 else {
            contentPlacehoderLabel.isHidden = false
            return
        }
        
        contentPlacehoderLabel.isHidden = true
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


// 제목 글자수 제한(50자)
extension ComposeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == postTitleTextField && postTitleTextField.isFirstResponder {
            postContentTextView.becomeFirstResponder()
        }
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentTitle = NSString(string: postTitleTextField.text ?? "")
        let finalTitle = currentTitle.replacingCharacters(in: range, with: " ")
        
        if finalTitle.count > 50 {
            return false
        }
        
        return true
    }
}




extension ComposeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        imageCollectionView.isHidden = imageList.count == 0
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComposeImageCollectionViewCell",
                                                      for: indexPath) as! ComposeImageCollectionViewCell
        cell.composeImageView.image = imageList[indexPath.item]
        return cell
    }
    
    
}



extension ComposeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}




extension ComposeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        print(#function, indexPath.item, indexPath.section)
        imageList.remove(at: indexPath.item)
        imageCollectionView.reloadData()
        
    }
}
