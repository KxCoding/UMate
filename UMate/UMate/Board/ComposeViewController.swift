//
//  ComposeViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/07/28.
//

import UIKit
import DropDown
import Loaf


/// 게시글 작성 클래스
/// - Author: 김정민(kimjm010@icloud.com)

class ComposeViewController: CommonViewController {
    
    /// 게시글 작성(제목, 내용, 정보), 사용자의 앨범에 접근을 위한 아울렛
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var postTitlePlaceholderLabel: UILabel!
    @IBOutlet weak var commmunityRuleBtn: UIButton!
    @IBOutlet weak var contentCountLabel: UILabel!
    @IBOutlet weak var contentPlacehoderLabel: UILabel!
    
    /// 앨범, 카테고리 선택 항목을 위한 악세사리 바
    @IBOutlet var accessoryBar: UIToolbar!
    
    /// 게시글 작성 시 추가한 사진을 표시할 뷰
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /// 게시글 작성 시 유의사항을 나타내는 뷰
    @IBOutlet weak var infoContainerView: UIStackView!
    
    /// 게시글 작성시 카테고리를 표시하는 컬렉션뷰
    @IBOutlet weak var categoryListCollectionView: UICollectionView!
    
    /// 게시글에 첨부할 이미지를 선택
    @IBOutlet weak var addPhotoBtn: UIBarButtonItem!
    
    // 게시글에 첨부할 이미지 속성
    var imageList = [UIImage]()
    
    /// 선택된 게시판
    var selectedBoard: Board?
    
    /// 선택된 카테고리
    var selectedCategoryList = [String]()
    
    /// CollectionView Item의 선택상태를 확인하는 속성
    var isSelected = true
    
#if DEBUG
    /// 게시판 카테고리를 담음 임시 배열
    var tempList = ["전체", "강연 및 행사", "알바 및 과외", "기타"]
#endif
    
    /// 게시글 작성을 취소
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 게시글에 첨부할 이미지를 가져오는 방법을 지정합니다.
    /// - Parameter sender: Camera UIBarButtonItem
    @IBAction func addorTakePhoto(_ sender: UIBarButtonItem) {
            alertToSelectAddOrTakePhoto(title: "", message: "앨범에서 찾을까요? 캡쳐할까요? ") { _ in
                self.performSegue(withIdentifier: "addPhotoSegue", sender: self)
            } handler2: { _ in
                self.performSegue(withIdentifier: "takePhotoSegue", sender: self)
            }
    }
    
         
    /// 게시글을 저장
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
        
        // 카테고리 게시판에 추가될 게시물
        let newCategoryPost = Post(images: imageList,
                                   postTitle: title,
                                   postContent: content,
                                   postWriter: "아이디 데이터",
                                   insertDate: Date(),
                                   likeCount: 3,
                                   commentCount: 2,
                                   scrapCount: 1,
                                   categoryRawValue: 2003)
        
        NotificationCenter.default.post(name: .newCategoryPostInsert,
                                        object: nil,
                                        userInfo: ["newPost" : newCategoryPost,
                                                   "category": newCategoryPost.categoryRawValue ?? 0])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 커뮤니티 이용규칙 버튼의 테마 설정
        commmunityRuleBtn.setToEnabledButtonTheme()
        
        // 글쓰기 화면 진입 시 자동으로 키보드를 표시
        postTitleTextField.becomeFirstResponder()
        
        // 게시글 작성 시 악세사리 뷰 표시
        postTitleTextField.inputAccessoryView = accessoryBar
        postContentTextView.inputAccessoryView = postTitleTextField.inputAccessoryView
        
        // SelectImageViewController로부터 사용자가 선택한 이미지를 게시글 작성 화면에 표시
        var token = NotificationCenter.default.addObserver(forName: .imageDidSelect,
                                                           object: nil,
                                                           queue: .main) { [weak self] (noti) in
            if let img = noti.userInfo?["img"] as? [UIImage] {
                self?.imageList.append(contentsOf: img)
                self?.imageCollectionView.reloadData()
            }
        }
        tokens.append(token)
        
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




/// 게시글(본문) placeHolder 설정 및 글자수 제한(500자)
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UITextViewDelegate {
    
    /// 본문 편집 시 placeholder를 hidden으로 바꿉니다.
    /// - Parameter textView: postContentTextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentPlacehoderLabel.isHidden = true
    }
    
    
    /// 본문 편집 후 글자수가 0 보다 작거나 같은 경우에 Placeholder를 다시 표시합니다.
    /// - Parameter textView: postContentTextView
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let content = postContentTextView.text, content.count > 0 else {
            contentPlacehoderLabel.isHidden = false
            return
        }
        
        contentPlacehoderLabel.isHidden = true
    }
    
    
    /// 게시글 본문이 수정될때마다 본문의 글자수를 셉니다.
    /// - Parameter textView: postContentTextView
    func textViewDidChange(_ textView: UITextView) {
        contentCountLabel.text = "\(postContentTextView.text.count) / 500"
        
        if postContentTextView.text.count >= 500 {
            contentCountLabel.textColor = UIColor.systemRed
        } else {
            contentCountLabel.textColor = .lightGray
        }
    }
    
    
    /// 게시글 본문의 글이 500자가 넘는 경우 작성 불가
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


/// 제목 Placeholder 지정 및 글자수 제한(50자)
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UITextFieldDelegate {
    
    /// 제목을 편집하는 경우 Placeholder를 숨깁니다.
    /// - Parameter textField: postTitleTextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        postTitlePlaceholderLabel.isHidden = true
    }
    
    
    /// 제목 편집 후 글자수가 0보다 작거나 같은 경우 다시 Placeholder를 설정합니다.
    /// - Parameter textField: postTitleTextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let title = postTitleTextField.text, title.count > 0 else {
            postTitlePlaceholderLabel.isHidden = false
            return
        }
        
        postTitlePlaceholderLabel.isHidden = true
    }
    
    
    /// 제목의 Return버튼을 누르면 본문으로 넘어갑니다.
    /// - Parameter textField: postTitleTextField
    /// - Returns: True인 경우 메소드에 구현한 코드가 실행됨
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == postTitleTextField && postTitleTextField.isFirstResponder {
            postContentTextView.becomeFirstResponder()
        }
        
        return true
    }
    
    
    /// 제목의 글자수가 50자 초과인 경우 작성 불가
    /// - Parameters:
    ///   - textField: 제목 텍스트필드
    ///   - range: 현재 선택된 텍스트의 범위
    ///   - string: 대체할 텍스트
    /// - Returns: 수정이 가능한 경우 True, 불가능한 경우 False
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




/// 게시글에 첨부할 이미지 컬렉션뷰
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UICollectionViewDataSource {
    
    /// 게시글에 첨부할 이미지를 표시
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - section: imageCollectionView의 섹션
    /// - Returns: 표시할 컬렉션뷰 셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        
        guard collectionView.tag == 101 else {
            return imageList.count
        }
        
        return tempList.count
    }
    
    
    /// 첨부할 이미지가 없는 경우 컬렉션뷰가 표시되지 않고, 이미지가 있는 경우 해당 이지미를 표시합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - indexPath: 첨부할 이미지의 indexPath
    /// - Returns: 이미지 컬렉션뷰 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        
        guard collectionView.tag == 101 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComposeImageCollectionViewCell",
                                                          for: indexPath) as! ComposeImageCollectionViewCell
            
            cell.composeImageView.image = imageList[indexPath.item]
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCategoryBoardCollectionViewCell",
                                                      for: indexPath) as! SelectCategoryBoardCollectionViewCell
        cell.selectCategoryButton.setTitle(tempList[indexPath.item], for: .normal)
        
        return cell
    }
}




/// 게시글 작성시 카테고리를 표시하는 컬렉션뷰 아이템의 사이즈를 지정
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UICollectionViewDelegateFlowLayout {
    
    /// 이미지 컬렉션뷰 아이템의 사이즈를 변경합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - collectionViewLayout: imageCollectionViewLayout
    ///   - indexPath: imageCollectionView셀의 indexPath
    /// - Returns: 첨부할 이미지의 사이즈
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 102 {
            return CGSize(width: 100, height: 100)
        }
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        // 셀의 너비
        let width: CGFloat
        
        // 카테고리 개수
        //guard let categoryCount = selectedBoard?.categoryNumbers.count else { return .zero }
        
        // 셀의 inset을 제외한 너비
        let withoutInsetWidth = view.frame.width -
        (flowLayout.minimumInteritemSpacing * CGFloat((tempList.count - 1))
         + flowLayout.sectionInset.left
         + flowLayout.sectionInset.right)
        
        // 카테고리를 표시하는 셀의 개수가 3일 경우
        if tempList.count == 3 {
            width = withoutInsetWidth / 3
            return CGSize(width: width, height:40)
        }
        // 카테고리를 표시하는 셀의 개수가 4일 경우
        else if tempList.count == 4 {
            if indexPath.row == 0 || indexPath.row == 3 {
                width = withoutInsetWidth / 2 * 0.4
                return CGSize(width: width, height: 40)
                
            } else {
                width = withoutInsetWidth / 2 * 0.6
                return CGSize(width: width, height: 40)
            }
        }
        return .zero
    }
}




/// 첨부한 이미지를 삭제
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.tag == 101 {
            if isSelected {
                isSelected = false
                collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
        return true
    }
    
    
    /// 첨부한 이미지를 탭하면 첨부이미지 목록에서 삭제합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - indexPath: 탭한 이미지컬렉션뷰 셀의 indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 102 {
            imageList.remove(at: indexPath.item)
            imageCollectionView.deleteItems(at: [indexPath])
        }
    }
}
