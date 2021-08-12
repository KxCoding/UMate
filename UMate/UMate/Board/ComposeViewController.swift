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
    
    // 게시글 작성(제목, 내용, 정보)을 위한 아울렛
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var postTitlePlaceholderLabel: UILabel!
    @IBOutlet weak var commmunityRuleView: UIView!
    @IBOutlet weak var contentCountLabel: UILabel!
    @IBOutlet weak var contentPlacehoderLabel: UILabel!
    @IBOutlet var accessoryBar: UIToolbar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // 게시글에 첨부할 이미지 속성
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
    
    
    
    /// 게시글 작성을 취소하는 메소드
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /// 게시글 저장을 위한 메소드
    @IBAction func savePost(_ sender: Any) {
        
        guard let title = postTitleTextField.text, title.count > 0,
              let content = postContentTextView.text, content.count > 0 else {
            
            alertVersion2(message: "게시글 작성을 취소하겠습니까?")
            return
        }
        
        let newPost = Post(images: imageList,
                           postTitle: title,
                           postContent: content,
                           postWriter: "아이디 데이터 넣기",
                           insertDate: Date(), likeCount: 3,
                           commentCount: 2)
        freeBoard.posts.insert(newPost, at: 0)
        
        NotificationCenter.default.post(name: .newPostInsert,
                                        object: nil,
                                        userInfo: ["newPost" : newPost])
        
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
    
    
    /// 본문 편집 시 placeholder를 hidden으로 바꾸는 메소드
    /// - Parameter textView: 게시글 본문 textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentPlacehoderLabel.isHidden = true
    }
    
    
    
    /// <#Description#>
    /// - Parameter textView: <#textView description#>
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let content = postContentTextView.text, content.count > 0 else {
            contentPlacehoderLabel.isHidden = false
            return
        }
        
        contentPlacehoderLabel.isHidden = true
    }
    
    
    
    /// <#Description#>
    /// - Parameter textView: <#textView description#>
    func textViewDidChange(_ textView: UITextView) {
        contentCountLabel.text = "\(postContentTextView.text.count) / 500"
        
        if postContentTextView.text.count >= 500 {
            contentCountLabel.textColor = UIColor.systemRed
        } else {
            contentCountLabel.textColor = .lightGray
        }
    }
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - textView: <#textView description#>
    ///   - range: <#range description#>
    ///   - text: <#text description#>
    /// - Returns: <#description#>
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentContentText = NSString(string: textView.text ?? "")
        let finalContentText = currentContentText.replacingCharacters(in: range, with: " ")
        
        if finalContentText.count > 500 {
            return false
        }
        
        return true
    }
}


// 제목 Placeholder 지정 및 글자수 제한(50자)
extension ComposeViewController: UITextFieldDelegate {
    
    
    /// <#Description#>
    /// - Parameter textView: <#textView description#>
    func textFieldDidBeginEditing(_ textView: UITextField) {
        postTitlePlaceholderLabel.isHidden = true
    }
    
    
    
    /// <#Description#>
    /// - Parameter textView: <#textView description#>
    func textFieldDidEndEditing(_ textView: UITextField) {
        guard let title = postTitleTextField.text, title.count > 0 else {
            postTitlePlaceholderLabel.isHidden = false
            return
        }
        
        postTitlePlaceholderLabel.isHidden = true
    }
    
    
    
    /// <#Description#>
    /// - Parameter textField: <#textField description#>
    /// - Returns: <#description#>
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == postTitleTextField && postTitleTextField.isFirstResponder {
            postContentTextView.becomeFirstResponder()
        }
        
        return true
    }
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - textField: <#textField description#>
    ///   - range: <#range description#>
    ///   - string: <#string description#>
    /// - Returns: <#description#>
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



// 게시글 이미지 추가
extension ComposeViewController: UICollectionViewDataSource {
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - section: <#section description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        imageCollectionView.isHidden = imageList.count == 0
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComposeImageCollectionViewCell",
                                                      for: indexPath) as! ComposeImageCollectionViewCell
        cell.composeImageView.image = imageList[indexPath.item]
        return cell
    }
    
    
}




// 게시글 이미지 첨부시 사이즈 지정
extension ComposeViewController: UICollectionViewDelegateFlowLayout {
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}




extension ComposeViewController: UICollectionViewDelegate {
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        #if DEBUG
        print(#function, indexPath.item, indexPath.section)
        #endif
        
        imageList.remove(at: indexPath.item)
        imageCollectionView.reloadData()
        
    }
}
