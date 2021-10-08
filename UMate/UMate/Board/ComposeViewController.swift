//
//  ComposeViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/07/28.
//

import UIKit
import DropDown
import Loaf


/// 게시글 작성 화면
/// - Author: 김정민(kimjm010@icloud.com)
class ComposeViewController: CommonViewController {
    
    /// 게시글 제목
    @IBOutlet weak var postTitleTextField: UITextField!
    
    /// 게시글 내용 텍스트뷰
    @IBOutlet weak var postContentTextView: UITextView!
    
    /// 게시글 제목 placeholder
    @IBOutlet weak var postTitlePlaceholderLabel: UILabel!
    
    /// 게시글 내용의 글자수 확인 레이블
    @IBOutlet weak var contentCountLabel: UILabel!
    
    /// 게시글 내용 placeholder
    @IBOutlet weak var contentPlacehoderLabel: UILabel!
    
    /// 앨범 및 이용규칙 버튼을 포함한 툴바
    @IBOutlet var accessoryBar: UIToolbar!
    
    /// 첨부한 이미지 컬렉션 뷰
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /// 게시글 카테고리 컬렉션 뷰
    @IBOutlet weak var categoryListCollectionView: UICollectionView!
    
    /// 게시글에 첨부할 이미지 리스트
    var imageList = [UIImage]()
    
    /// 선택된 게시판
    var selectedBoard: Board?
    
    /// 게시판 카테고리 이름 리스트
    var categoryList = [String]()
    
    /// 게시판 카테고리 rawValue 리스트
    var categoryListValue = [Int]()
    
    /// 선택된 카테고리
    var selectedCategory: Int?
    
    /// 카테고리 선택상태 확인
    var isSelected = true
    
    
    /// 게시글 작성을 취소
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 이미지 첨부 방식을 선택합니다.
    /// 게시글에 첨부할 이미지를 가져오는 방법을 지정합니다.
    /// - Parameter sender: Camera UIBarButtonItem
    @IBAction func addorTakePhoto(_ sender: UIBarButtonItem) {
        alertToSelectAddOrTakePhoto(title: "", message: "앨범에서 찾을까요? 캡쳐할까요? ") { _ in
            self.performSegue(withIdentifier: "addPhotoSegue", sender: self)
        } handler2: { _ in
            self.performSegue(withIdentifier: "takePhotoSegue", sender: self)
        }
    }
    
    
    /// 게시글을 저장합니다.
    /// 일반 게시판과 카테고리를 선택하는 게시판이 있습니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func savePost(_ sender: Any) {
        
        guard let title = postTitleTextField.text, title.count > 0,
              let content = postContentTextView.text, content.count > 0 else {
                  Loaf("제목과 내용을 입력해주세요 :)",
                       state: .custom(.init(backgroundColor: .black)),
                       sender: self).show()
                  return
              }
        
        // 일반 게시판에 추가될 게시글
        if categoryList.isEmpty {
        
            let newPost = Post(images: imageList,
                               postTitle: title,
                               postContent: content,
                               postWriter: "아이디 데이터 넣기",
                               insertDate: Date(),
                               likeCount: 3,
                               commentCount: 2)
            
            NotificationCenter.default.post(name: .newPostInsert,
                                            object: nil,
                                            userInfo: ["newPost" : newPost])
        }
        
        // 카테고리 게시판에 추가될 게시물
        else {
            
            guard let selectedCategory = selectedCategory else {
                Loaf("카테고리 항목을 선택해 주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
                return
            }
            
            let newCategoryPost = Post(images: imageList,
                                       postTitle: title,
                                       postContent: content,
                                       postWriter: "아이디 데이터",
                                       insertDate: Date(),
                                       likeCount: 3,
                                       commentCount: 2,
                                       scrapCount: 1,
                                       categoryRawValue: selectedCategory)
            
            NotificationCenter.default.post(name: .newCategoryPostInsert,
                                            object: nil,
                                            userInfo: ["newPost" : newCategoryPost,
                                                       "category": selectedCategory])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryListCollectionView.isHidden = categoryList.isEmpty
        
        postTitleTextField.becomeFirstResponder()
        
        postTitleTextField.inputAccessoryView = accessoryBar
        postContentTextView.inputAccessoryView = postTitleTextField.inputAccessoryView
        
        // 게시글 화면애 앨범 이미지 표시
        var token = NotificationCenter.default.addObserver(forName: .imageDidSelect,
                                                           object: nil,
                                                           queue: .main) { [weak self] (noti) in
            if let img = noti.userInfo?["img"] as? [UIImage] {
                self?.imageList.append(contentsOf: img)
                self?.imageCollectionView.reloadData()
            }
        }
        tokens.append(token)
        
        // 게시글 화면에 캡쳐 이미지 표시
        token = NotificationCenter.default.addObserver(forName: .newImageCaptured,
                                                       object: nil,
                                                       queue: .main,
                                                       using: { [weak self] (noti) in
            if let img = noti.userInfo?["img"] as? UIImage {
                self?.imageList.append(img)
                self?.imageCollectionView.reloadData()
            }
        })
        
        tokens.append(token)
    }
}




/// 게시글 내용의 동작 방식 처리
/// 게시글(본문) placeHolder 상태 및 글자수를 관리합니다(500자).
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UITextViewDelegate {
    
    /// 본문 편집시 placeholder 상태를 관리합니다.
    /// 본문 편집시 placeholder를 hidden으로 바꿉니다.
    /// - Parameter textView: postContentTextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentPlacehoderLabel.isHidden = true
    }
    
    
    /// 본문 편집 후의 placeholder 상태를 관리합니다.
    /// 본문 편집 후 글자수가 0 보다 작거나 같은 경우에 Placeholder를 다시 표시합니다.
    /// - Parameter textView: postContentTextView
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let content = postContentTextView.text, content.count > 0 else {
            contentPlacehoderLabel.isHidden = false
            return
        }
        
        contentPlacehoderLabel.isHidden = true
    }
    
    
    /// 본문 편집시 글자 수를 확인합니다.
    /// 게시글 본문이 수정될때마다 본문의 글자수를 카운팅 합니다.
    /// - Parameter textView: postContentTextView
    func textViewDidChange(_ textView: UITextView) {
        contentCountLabel.text = "\(postContentTextView.text.count) / 500"
        
        if postContentTextView.text.count >= 500 {
            contentCountLabel.textColor = UIColor.systemRed
        } else {
            contentCountLabel.textColor = .lightGray
        }
    }
    
    
    /// 본문 편집 기능을 제한합니다.
    /// 게시글 본문의 글이 500자가 넘는 경우 작성이 불가능합니다.
    /// - Parameters:
    ///   - textView: textView description
    ///   - range: 현재 선택된 텍스트의 범위
    ///   - text: 대체할 텍스트
    /// - Returns: 수정이 가능한 경우 True, 불가능한 경우 False
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        let currentContentText = NSString(string: textView.text ?? "")
        let finalContentText = currentContentText.replacingCharacters(in: range, with: " ")
        
        if finalContentText.count > 500 {
            return false
        }
        
        return true
    }
}




/// 게시글 제목의 동작방식 처리
/// 제목 Placeholder 지정 및 글자수를 제한합니다(50자).
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UITextFieldDelegate {
    
    /// 제목 편집시 placeholder 상태를 관리합니다.
    /// 제목 편집시 placeholder를 hidden으로 바꿉니다.
    /// - Parameter textField: postTitleTextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        postTitlePlaceholderLabel.isHidden = true
    }
    
    
    /// 제목 편집 후 placeholder 상태를 관리합니다.
    /// 제목 편집 후 글자수가 0보다 작거나 같은 경우 다시 Placeholder를 설정합니다.
    /// - Parameter textField: postTitleTextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let title = postTitleTextField.text, title.count > 0 else {
            postTitlePlaceholderLabel.isHidden = false
            return
        }
        
        postTitlePlaceholderLabel.isHidden = true
    }
    
    
    /// 제목 편집시 Return버튼의 기능을 설정합니다.
    /// 제목의 Return버튼을 누르면 본문으로 넘어갑니다.
    /// - Parameter textField: postTitleTextField
    /// - Returns: True인 경우 본문 내용을 편집할 수 있습니다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == postTitleTextField && postTitleTextField.isFirstResponder {
            postContentTextView.becomeFirstResponder()
        }
        
        return true
    }
    
    
    /// 제목 편집 기능을 제한합니다.
    /// 제목의 글자수가 50자 초과인 경우 작성이 불가능합니다.
    /// - Parameters:
    ///   - textField: 제목 텍스트필드
    ///   - range: 바꿀 문자의 범위 정보
    ///   - string: 지정된 범위의 대체 문자열
    /// - Returns: 제목 텍스트필드에 새로운 문자를 추가할 수 있을 경우 true, 추가가 불가능한 경우 false
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




/// 첨부할 이미지 및 카테고리 데이터 설정
/// 게시글에 첨부할 이미지 컬렉션뷰
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UICollectionViewDataSource {
    
    /// 이미지 및 카테고리의 수를 리턴합니다.
    /// 게시글에 첨부할 이미지와 게시글의 카테고리 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView, categoryListCollectionView
    ///   - section: imageCollectionView, categoryListCollectionView의 섹션 인덱스
    /// - Returns: 표시할 컬렉션뷰 item의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard collectionView.tag == 101 else {
            return imageList.count
        }
        
        return categoryList.count - 1
    }
    
    
    /// 이미지 및 카테고리 목록 셀을 구성합니다.
    /// 첨부할 이미지가 있는 경우 해당 이지미를 표시합니다.
    /// 카테고리의 이름을 표시합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView, categoryListCollectionView
    ///   - indexPath: 첨부할 이미지의 indexPath, 카테고리의 indexPath
    /// - Returns: 게시글에 선택한 이미지를 표시하는 컬렉션 뷰 셀,  카테고리를 표시하는 컬렉션뷰 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard collectionView.tag == 101 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComposeImageCollectionViewCell",
                                                          for: indexPath) as! ComposeImageCollectionViewCell
            
            cell.composeImageView.image = imageList[indexPath.item]
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCategoryBoardCollectionViewCell",
                                                      for: indexPath) as! SelectCategoryBoardCollectionViewCell
        
        cell.configure(with: categoryList, indexPath: indexPath)
        
        return cell
    }
}




/// 이미지, 카테고리 컬렉션뷰셀의 사이즈 설정
/// 이미지 및 카테고리 아이템의 사이를 설정합니다.
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UICollectionViewDelegateFlowLayout {
    
    /// 이미지 및 카테고리셀의 사이즈를 설정합니다.
    /// 이미지 및 카테고리셀의 사이즈를 상태에 따라 다르게 설정합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView, categoryListCollectionView
    ///   - collectionViewLayout: imageCollectionView와 categoryListCollectionView의 Layout 정보
    ///   - indexPath: imageCollectionView, categoryListCollectionView Item의 indexPath
    /// - Returns: 이미지 및 카테고리 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 102 {
            return CGSize(width: 100, height: 100)
        }
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let bounds = collectionView.bounds
        var width = bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        
        switch categoryList.count {
        case 4:
            width = (width - (layout.minimumLineSpacing * 2)) / 3
            return CGSize(width: width, height: 50)
        case 3:
            width = (width - (layout.minimumLineSpacing)) / 2
            return CGSize(width: width, height: 50)
        default:
            break
        }
        
        return .zero
    }
}




/// 이미지 및 카테고리의 동작 처리
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UICollectionViewDelegate {
    
    /// 이미지 및 카테고리를 선택시 동작을 처리합니다.
    /// 첨부한 이미지를 탭하면 첨부이미지 목록에서 삭제합니다.
    /// 카테고리를 탭하면 해당 카테고리의 rawValue값을 새로운 변수에 저장합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView, categoryListCollectionView
    ///   - indexPath: 탭한 이미지컬렉션뷰 셀과 categoryListCollectionView셀의 indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 102 {
            imageList.remove(at: indexPath.item)
            imageCollectionView.deleteItems(at: [indexPath])
        }
        
        if collectionView.tag == 101 {
            switch selectedBoard?.boardTitle {
            case "홍보게시판":
                selectedCategory = categoryListValue[indexPath.item + 1]
            case "동아리, 학회":
                selectedCategory = categoryListValue[indexPath.item + 1]
            case "취업, 진로":
                selectedCategory = categoryListValue[indexPath.item + 1]
            default:
                break
            }
        }
    }
}
