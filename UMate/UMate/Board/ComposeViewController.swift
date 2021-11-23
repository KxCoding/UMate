//
//  ComposeViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/07/28.
//

import UIKit
import DropDown
import Loaf
import RxSwift
import RxCocoa
import NSObject_Rx
import Moya


/// 이미지 첨부 방식
/// - Author: 김정민(kimjm010@icloud.com)
enum SelectImageAttachActionType {
    case find
    case take
    case close
}



/// 게시글 작성 화면
/// - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
class ComposeViewController: CommonViewController {
    
    /// 게시글 제목
    @IBOutlet weak var postTitleTextField: UITextField!
    
    /// 게시글 내용 텍스트뷰
    @IBOutlet weak var postContentTextView: UITextView!
    
    /// 게시글 제목 placeholder
    @IBOutlet weak var postTitlePlaceholderLabel: UILabel!
    
    /// 게시글 내용의 글자 수 확인 레이블
    @IBOutlet weak var contentCountLabel: UILabel!
    
    /// 게시글 내용 placeholder
    @IBOutlet weak var contentPlacehoderLabel: UILabel!
    
    /// 앨범 및 이용규칙 버튼을 포함한 툴바
    @IBOutlet var accessoryBar: UIToolbar!
    
    /// 첨부한 이미지 컬렉션 뷰
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /// 게시글 카테고리 컬렉션 뷰
    @IBOutlet weak var categoryListCollectionView: UICollectionView!
    
    /// 게시판 이용정보
    @IBOutlet weak var communityInfoLabel: UILabel!
    
    /// 이미지 첨부 버튼
    @IBOutlet weak var selectImageAttachmentTypeBtn: UIBarButtonItem!
    
    /// 게시글 작성 bottom 제약
    @IBOutlet weak var composeContentTextViewBottomConstraint: NSLayoutConstraint!
        
    /// 화면 닫기 버튼
    @IBOutlet weak var closeVc: UIBarButtonItem!
    
    // 게시글을 저장합니다.
    @IBOutlet weak var savePostButton: UIBarButtonItem!
    
    /// 선택된 게시판
    var selectedBoard: BoardDtoResponseData.BoardDto?
    
    /// 게시판 카테고리 이름 리스트
    var categoryList = [BoardDtoResponseData.BoardDto.Category]()
    
    /// 네트워크 통신 관리 객체
    let provider = MoyaProvider<PostSaveService>()
    
    /// 컬렉션 뷰에 표시될 이미지
    var sampleImages = [UIImage]()
    
    /// 서버에 올라갈 이미지
    var boardImages = [UIImage]()
    
    /// 선택된 카테고리
    var selectedCategory: Int?
    
    /// 카테고리 선택상태 확인
    var isSelected = true
    
    /// keyboard의 높이를 방출하는 옵저버블
    let willShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification,
                                                              object: nil)
        .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
        .map { $0.cgRectValue.height }
    
    /// keybaordr의 높이를 0으로 방출하는 옵저버블
    let willHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification,
                                                              object: nil)
        .map { _ in CGFloat(0)}
    
    /// 캡쳐한 이미지를 방출하는 옵저버블
    let sendCapturedImage = NotificationCenter.default.rx.notification(.newImageCaptured, object: nil)
        .compactMap { $0.userInfo?["img"] as? UIImage }
    
    /// 선택한 이미지 배열을 방출하는 옵저버블
    let sendSelectedImage = NotificationCenter.default.rx.notification(.imageDidSelect, object: nil)
        .compactMap { $0.userInfo?["img"] as? [UIImage] }
    
    
    /// 게시글을 저장합니다.
    /// - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
    func savePost() {
        guard let title = postTitleTextField.text, title.count > 0,
              let content = postContentTextView.text, content.count > 0 else {
                  Loaf("제목과 내용을 입력해주세요 :)",
                       state: .custom(.init(backgroundColor: .black)),
                       sender: self).show()
                  return
              }
        
        let dateStr = BoardDataManager.shared.postDateFormatter.string(from: Date())
        
        var newPost: PostPostData?
        var urlStringList = [String]()
        let group = DispatchGroup()
        
        if self.boardImages.count > 0 {
            self.boardImages.forEach { image in
                group.enter()
                BlobManager.shared.upload(image: image) { success, id in
                    if success {
                        #warning("블롭주소 수정")
                        let imageUrlStr = "https://boardimage1018.blob.core.windows.net/images/\(id.lowercased())"
                        urlStringList.append(imageUrlStr)
                        group.leave()
                    }
                }
            }
        }
        
        // 일반 게시판에 추가될 게시글
        group.notify(queue: .main) {
            if self.categoryList.isEmpty {
                #warning("사용자 수정")
                newPost = PostPostData(postId: 0, userId: "6c1c72d6-fa9b-4af6-8730-bb98fded0ad8", boardId: self.selectedBoard?.boardId ?? 0, title: title, content: content, categoryNumber: 0, urlStrings: urlStringList, createdAt:dateStr)
            } else {
                guard let selectedCategory = self.selectedCategory else {
                    Loaf("카테고리 항목을 선택해 주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
                    return
                }
                #warning("사용자 수정")
                newPost = PostPostData(postId: 0, userId: "6c1c72d6-fa9b-4af6-8730-bb98fded0ad8", boardId: self.selectedBoard?.boardId ?? 0, title: title, content: content, categoryNumber: selectedCategory, urlStrings: urlStringList, createdAt:dateStr)
            }
            
            self.sendDataToServer(postData: newPost)
        }
    }
    
    
    /// 게시글을 서버에 저장합니다.
    /// - Parameter postData: 게시글 정보 객체
    ///   - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    func sendDataToServer(postData: PostPostData?) {
        guard let postData = postData else { return }
        
        provider.rx.request(.uploadPost(postData))
            .filterSuccessfulStatusCodes()
            .map(SavePostResponseData.self)
            .observe(on: MainScheduler.instance)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.resultCode {
                    case ResultCode.ok.rawValue:
                        let newPost = PostListDtoResponseData.PostDto(postId: response.post.postId, title: response.post.title, content: response.post.content, createdAt: response.post.createdAt, userName: response.post.userId, likeCnt: 0, commentCnt: 0, scrapCnt: 0, categoryNumber: response.post.categoryNumber)
                        
                        NotificationCenter.default.post(name: .newPostInsert, object: nil, userInfo: ["newPost": newPost])
                        
                        #if DEBUG
                        print("추가 성공!")
                        #endif
                        
                        self.dismiss(animated: true, completion: nil)
                    case ResultCode.fail.rawValue:
                        #if DEBUG
                        print("이미 존재함")
                        #endif
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    /// - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryListCollectionView.isHidden = categoryList.isEmpty
        
        postTitleTextField.becomeFirstResponder()
        
        postTitleTextField.inputAccessoryView = accessoryBar
        postContentTextView.inputAccessoryView = postTitleTextField.inputAccessoryView
        
        // 게시글 화면에 앨범 이미지 표시
        // - Author: 김정민(kimjm010@icloud.com)
        sendSelectedImage
            .subscribe(onNext: { [unowned self] in
                self.sampleImages.append(contentsOf: $0)
                self.imageCollectionView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        // 게시글 화면에 캡쳐 이미지 표시
        // - Author: 김정민(kimjm010@icloud.com)
        sendCapturedImage
            .subscribe(onNext: { [unowned self] in
                self.sampleImages.append($0)
                self.imageCollectionView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        // 서버에 올릴 이미지 저장
        // - Author: 남정은(dlsl7080@gmail.com)
        let token = NotificationCenter.default.addObserver(forName: .requestPostImage, object: nil, queue: .main, using: { noti in
            if let image = noti.userInfo?["image"] as? UIImage {
                self.boardImages.append(image)
            }
            
            if let image = noti.userInfo?["img"] as? UIImage {
                self.boardImages.append(image)
            }
        })
        tokens.append(token)
        
        // 이미지 첨부 방식을 선택합니다.
        // - Author: 김정민(kimjm010@icloud.com)
        selectImageAttachmentTypeBtn.rx.tap
            .flatMap { _ in self.alertToSelectImageAttachWay(title: "알림", message: "이미지 첨부 방식을 선택하세요 :)") }
            .subscribe(onNext: { [unowned self] (actionType) in
                switch actionType {
                case .find:
                    self.performSegue(withIdentifier: "addPhotoSegue", sender: self)
                case .take:
                    self.performSegue(withIdentifier: "takePhotoSegue", sender: self)
                default:
                    break
                }
            })
            .disposed(by: rx.disposeBag)
        
        // 일반 게시판과 카테고리 게시판에 게시글을 저장합니다.
        // - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
        savePostButton.rx.tap
            .subscribe(onNext: {
                self.savePost()
            })
            .disposed(by: rx.disposeBag)
        
        
        // 글쓰기 화면을 닫습니다.
        // - Author: 김정민(kimjm010@icloud.com)
        closeVc.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        
        // 키보드 노티피케이션을 처리하는 옵저버블입니다.
        // - Author: 김정민(kimjm010@icloud.com)
        Observable.merge(willShow, willHide)
            .bind(to: composeContentTextViewBottomConstraint.rx.constant)
            .disposed(by: rx.disposeBag)
        
        // 게시글 제목의 placeholder상태를 관리합니다.
        //
        // 게시글 제목이 입력된 경우 placeholder 레이블을 숨깁니다.
        // - Author: 김정민(kimjm010@icloud.com)
        postTitleTextField.rx.text.orEmpty.asDriver()
            .map { $0.count > 0 }
            .drive(postTitlePlaceholderLabel.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        // 게시글 내용의 placeholder상태를 관리합니다.
        //
        // 게시글 내용이 입력된 경우 placeholder 레이블을 숨깁니다.
        // - Author: 김정민(kimjm010@icloud.com)
        postContentTextView.rx.text.orEmpty.asDriver()
            .map { $0.count > 0 }
            .drive(contentPlacehoderLabel.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        // 제목의 글자 수를 방출하는 옵저버블
        let postTitleObservable = postTitleTextField.rx.text.orEmpty.asDriver().map { $0.count }
        
        // 제목 편집 중 글자 수를 확인합니다.
        //
        // 제목이 수정될때마다 본문의 글자수를 카운팅 합니다.
        // - Author: 김정민(kimjm010@icloud.com)
        postTitleObservable
            .map { "\($0) / 50"}
            .drive(contentCountLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        // countLabel의 글자 색을 변경합니다.
        //
        // 글자수에 따라 countLable에 서로 다른 textColor를 바인딩합니다.
        // - Author: 김정민(kimjm010@icloud.com)
        postTitleObservable
            .map { $0 >= 50 }
            .map {  $0 ? UIColor.systemRed : UIColor.lightGray}
            .drive(contentCountLabel.rx.textColor)
            .disposed(by: rx.disposeBag)
        
        imageCollectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
    }
}




/// 게시글 제목의 동작방식 처리
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UITextFieldDelegate {
    
    /// 제목 편집 중 Return버튼의 기능을 설정합니다.
    ///
    /// 제목의 Return버튼을 누르면 본문으로 넘어갑니다.
    /// - Parameter textField: postTitleTextField
    /// - Returns: true인 경우 본문 내용을 편집할 수 있습니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == postTitleTextField && postTitleTextField.isFirstResponder {
            postContentTextView.becomeFirstResponder()
        }
        
        return true
    }
    
    
    /// 제목 편집 기능을 제한합니다.
    ///
    /// 제목의 글자수가 50자 초과인 경우 작성이 불가능합니다.
    /// - Parameters:
    ///   - textField: postTitleTextField
    ///   - range: 바꿀 문자의 범위
    ///   - string: 지정된 범위의 대체 문자열
    /// - Returns: 제목을 편집할 수 있는 경우 true, 편집이 불가능한 경우 false
    /// - Author: 김정민(kimjm010@icloud.com)
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
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UICollectionViewDataSource {
    
    /// 게시글에 첨부할 이미지와 게시글의 카테고리 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView, categoryListCollectionView
    ///   - section: imageCollectionView, categoryListCollectionView의 섹션 인덱스
    /// - Returns: 표시할 컬렉션뷰 item의 수
    /// - Author: 김정민(kimjm010@icloud.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard collectionView.tag == 101 else {
            return sampleImages.count
        }
        
        return categoryList.count
    }
    
    
    /// tag 값에 따라 첨부할 이미지 또는 카테고리 이름을 표시합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView, categoryListCollectionView
    ///   - indexPath: 첨부할 이미지의 indexPath, 카테고리의 indexPath
    /// - Returns: 게시글에 선택한 이미지를 표시하는 컬렉션 뷰 셀,  카테고리를 표시하는 컬렉션 뷰 셀
    /// - Author: 김정민(kimjm010@icloud.com)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard collectionView.tag == 101 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComposeImageCollectionViewCell",
                                                          for: indexPath) as! ComposeImageCollectionViewCell
            
            cell.composeImageView.image = sampleImages[indexPath.item]
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCategoryBoardCollectionViewCell",
                                                      for: indexPath) as! SelectCategoryBoardCollectionViewCell
        
        let categoryName = categoryList[indexPath.item].name
        cell.configure(with: categoryName)
        return cell
    }
}



/// 이미지, 카테고리 컬렉션뷰 셀의 레이아웃 조정
/// - Author: 김정민(kimjm010@icloud.com)
extension ComposeViewController: UICollectionViewDelegateFlowLayout {
    
    /// 이미지 및 카테고리셀의 사이즈를 설정합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView, categoryListCollectionView
    ///   - collectionViewLayout: imageCollectionView와 categoryListCollectionView의 Layout 정보
    ///   - indexPath: imageCollectionView, categoryListCollectionView Item의 indexPath
    /// - Returns: 이미지 및 카테고리 셀의 사이즈
    /// - Author: 김정민(kimjm010@icloud.com)
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
        case 2:
            width = (width - (layout.minimumLineSpacing)) / 2
            return CGSize(width: width, height: 50)
        case 3:
            width = (width - (layout.minimumLineSpacing * 2)) / 3
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
    ///
    /// 첨부한 이미지를 탭하면 첨부이미지 목록에서 삭제합니다.
    /// 카테고리를 탭하면 해당 카테고리의 rawValue 값을 새로운 변수에 저장합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView, categoryListCollectionView
    ///   - indexPath: 탭한 imageCollectionView 셀과 categoryListCollectionView 셀의 indexPath
    /// - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 102 {
            sampleImages.remove(at: indexPath.item)
            imageCollectionView.deleteItems(at: [indexPath])
        }
        
        if collectionView.tag == 101 {
            switch selectedBoard?.boardId {
            case 9:
                selectedCategory = categoryList[indexPath.item].categoryId
            case 10:
                selectedCategory = categoryList[indexPath.item].categoryId
            case 12:
                selectedCategory = categoryList[indexPath.item].categoryId
            default:
                break
            }
        }
    }
}
