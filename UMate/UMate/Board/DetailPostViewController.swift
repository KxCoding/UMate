//
//  DetailPostViewController.swift
//  DetailPostViewController
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit
import Loaf
import RxSwift
import RxCocoa
import NSObject_Rx
import Moya


/// 게시글 삭제, 댓글 카운트 레이블 업데이트
/// - Author: 남정은(dlsl7080@gmail.com)
extension Notification.Name {
    static let postDidDelete = Notification.Name("postDidDelete")
    static let commentDidDelete = Notification.Name("commentDidDelete")
    static let commentDidInsert = Notification.Name("commentDidInsert")
}



enum SelectActionType {
    case delete
}



/// 게시글 상세화면 뷰 컨트롤러
/// - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
class DetailPostViewController: CommonViewController {
    
    /// 댓글 컨테이너 뷰
    @IBOutlet weak var writeCommentContainerView: UIView!
    
    /// 댓글내용
    @IBOutlet weak var commentTextView: UITextView!
    
    /// 상세 게시글 테이블 뷰
    @IBOutlet weak var detailPostTableView: UITableView!
    
    /// 댓글 placeholder
    /// 댓글 작성 여부에 따라 placeholder를 표시합니다.
    @IBOutlet weak var commentPlaceholderLabel: UILabel!
    
    /// 댓글 컨테이뷰의 bottom 제약
    /// keyboard가 댓글 텍스트필드를 가리지않고 댓글을 작성할 수 있습니다.
    @IBOutlet weak var commentContainerViewBottomConstraint: NSLayoutConstraint!
    
    /// 메뉴 버튼
    @IBOutlet weak var showMenuButton: UIButton!
    
    /// 네트워크 요청 관리 객체
    let provider = MoyaProvider<CommentSaveService>()
    
    /// 댓글 리스트
    var commentList = [CommentListResponseData.Comment]()
    
    /// 정렬된 댓글 리스트
    var sortedCommentList = [CommentListResponseData.Comment]()
    
    /// 게시글 이미지 리스트
    var postImageList = [ImageListResponseData.PostImage]()
    
    /// 댓글 좋아요 리스트
    var likeCommentList = [LikeCommentListResponse.LikeComment]()

    /// 게시글 정보
    var post: PostDtoResponseData.Post?
    
    /// 이미지 버튼 옵저버 저장
    var imageObserver: NSObjectProtocol?
    
    /// 좋아요 버튼 옵저버 저장
    var alertToken: NSObjectProtocol?
    
    /// 선택된 게시글Id
    var selectedPostId: Int = -1
    
    /// 댓글 Id
    /// 대댓글이 아닌 댓글의 Id입니다.
    var originalCommentId: Int?
    
    /// 댓글 Id(댓글, 대댓글 포함)
    var commentId: Int?
    
    /// 서버에 저장된 댓글의 마지막 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    var lastCommentId = 0
    
    /// 게시글 좋아요 여부
    var isLiked = false
    
    /// 게시글 스크랩 여부
    var isScrapped = false
    
    /// 대댓글 여부 확인
    var isReComment: Bool = false
    
    /// 사용자 스크랩Id
    var scrapPostId = 0
    
    var selectedCommentIndex: IndexPath?
    
    /// keyboard의 높이를 방출하는 옵저버블
    let willShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification,
                                                              object: nil)
        .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
        .map { $0.cgRectValue.height }
    
    /// keybaordr의 높이를 0으로 방출하는 옵저버블
    let willHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification,
                                                              object: nil)
            .map { _ in CGFloat(0)}
    
    
    /// 댓글 및 대댓글을 저장합니다.
    /// - Parameter sender: 댓글 저장 버튼
    /// - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
    @IBAction func saveComment(_ sender: Any) {
        
        guard let content = commentTextView.text, content.count > 0 else {
            alert(message: "댓글 내용을 입력해주세요 :)")
            return
        }
        
        if !isReComment {
            commentId = sortedCommentList.count == 0 ? lastCommentId + 1 : (sortedCommentList.max { $0.commentId < $1.commentId }?.commentId ?? 1) + 1
            originalCommentId = commentId
        } else {
            originalCommentId = commentId
        }
        
        let dateStr = BoardDataManager.shared.postDateFormatter.string(from: Date())
        let newComment = CommentPostData(userId: LoginDataManager.shared.loginKeychain.get(AccountKeys.userId.rawValue) ?? "", postId: selectedPostId, content: content, originalCommentId: originalCommentId ?? 0, isReComment: isReComment, createdAt: dateStr)
        
        sendCommentDataToServer(commentPostData: newComment)
        NotificationCenter.default.post(name: .commentDidInsert, object: nil, userInfo: ["postId": post?.postId ?? 0])
        
        isReComment = false
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 댓글을 서버에 저장합니다.
    /// - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
    func sendCommentDataToServer(commentPostData: CommentPostData) {
        provider.rx.request(.saveComment(commentPostData))
            .filterSuccessfulStatusCodes()
            .map(SaveCommentResponseData.self)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    if response.code == ResultCode.ok.rawValue {
                        
                        let newComment = CommentListResponseData.Comment(commentId: response.comment.commentId, userId: response.comment.userId, userName: response.comment.userName, profileUrl: response.comment.profileUrl, postId: response.comment.postId, content: response.comment.content, likeCnt: response.comment.likeCnt, originalCommentId: response.comment.originalCommentId, isReComment: response.comment.isReComment, createdAt: response.comment.createdAt, updatedAt: response.comment.updatedAt)
                        
                        
                        NotificationCenter.default.post(name: .newCommentDidInsert, object: nil, userInfo: ["comment": newComment])
                    }
                default:
                    break
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 게시글의 일부 정보를 불러옵니다.
    /// - Parameters:
    ///   - id: 게시글 Id
    ///   - userId: 사용자 Id
    ///   - Author: 남정은(dlsl7080@gmail.com)
    private func fetchPostSummary(id: Int, userId: String) -> Observable<PostDtoResponseData> {
        return BoardDataManager.shared.provider.rx.request(.detailPost(id, userId))
            .filterSuccessfulStatusCodes()
            .map(PostDtoResponseData.self)
            .asObservable()
    }
    
    
    /// 게시글 이미지를 불러옵니다.
    /// - Parameter postId: 게시글 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func fetchImages(postId: Int) -> Observable<[ImageListResponseData.PostImage]> {
        return BoardDataManager.shared.provider.rx.request(.postImageList(postId))
            .filterSuccessfulStatusCodes()
            .map(ImageListResponseData.self)
            .map { $0.list }
            .catchAndReturn([])
            .asObservable()
    }
    
    
    /// 게시글의 댓글목록을 불러옵니다.
    /// - Parameter postId: 게시글 Id
    /// - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    private func fetchComments(postId: Int) -> Observable<CommentListResponseData> {
        return BoardDataManager.shared.provider.rx.request(.commentList(postId))
            .filterSuccessfulStatusCodes()
            .map(CommentListResponseData.self)
            .catchAndReturn(CommentListResponseData(lastId: 0, list: [], code: 0, message: nil))
            .asObservable()
    }
    
    
    /// 댓글의 좋아요 정보를 불러옵니다.
    /// - Parameter userId: 사용자 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func fetchLikeComment(userId: String) -> Observable<[LikeCommentListResponse.LikeComment]> {
        return BoardDataManager.shared.provider.rx.request(.likeCommentList(userId))
            .filterSuccessfulStatusCodes()
            .map(LikeCommentListResponse.self)
            .map { $0.list }
            .catchAndReturn([])
            .asObservable()
    }
    
    
    /// 댓글을 삭제합니다.
    /// - Parameter commentId: 댓글 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func deleteComment(commentId: Int) {
        BoardDataManager.shared.provider.rx.request(.deleteComment(commentId))
            .filterSuccessfulStatusCodes()
            .map(CommonResponse.self)
            .subscribe(onSuccess: {
                if $0.code == ResultCode.ok.rawValue {
                    #if DEBUG
                    print("삭제 성공")
                    #endif
                } else {
                    #if DEBUG
                    print("삭제 실패")
                    #endif
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 게시글을 삭제합니다.
    /// - Parameter postId: 게시글 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func deletePost(postId: Int) {
        BoardDataManager.shared.provider.rx.request(.deletePost(postId))
            .filterSuccessfulStatusCodes()
            .map(CommonResponse.self)
            .subscribe(onSuccess: {
                if $0.code == ResultCode.ok.rawValue {
                    #if DEBUG
                    print("삭제 성공")
                    #endif
                    NotificationCenter.default.post(name: .postDidDelete, object: nil, userInfo: ["postId": postId])
                } else {
                    #if DEBUG
                    print("삭제 실패")
                    #endif
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 게시글 상세정보를 불러옵니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func fetchPostDetail() {
        let postSummary = fetchPostSummary(id: selectedPostId, userId: LoginDataManager.shared.loginKeychain.get(AccountKeys.userId.rawValue) ?? "")
        let images = fetchImages(postId: selectedPostId)
        let comments = fetchComments(postId: selectedPostId)
        let likeComments = fetchLikeComment(userId: LoginDataManager.shared.loginKeychain.get(AccountKeys.userId.rawValue) ?? "")
        
        Observable.zip(postSummary, images, comments, likeComments)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                guard let date = BoardDataManager.shared.decodingFormatter.date(from: result.0.post.createdAt) else { return }
                let dateStr = date.detailPostDate
                self.post = result.0.post
                self.post?.createdAt = dateStr
                self.isLiked = result.0.isLiked
                self.isScrapped = result.0.isScrapped
                self.scrapPostId = result.0.scrapPostId
                self.postImageList = result.1
                self.commentList = result.2.list
                self.sortedCommentList = result.2.list.sorted {
                   if $0.originalCommentId == $1.originalCommentId {
                       return $0.commentId < $1.commentId
                   }

                   return $0.originalCommentId < $1.originalCommentId
               }

                self.lastCommentId = result.2.lastId
                self.likeCommentList = result.3
                self.detailPostTableView.reloadData()
                self.detailPostTableView.isHidden = false
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 이미지 정보를 전달합니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ExpandImageViewController {
            vc.imageCount = postImageList.count
            vc.postImageList = postImageList
        }
    }
   
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    /// - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPostDetail()
        
        detailPostTableView.isHidden = true
        
        writeCommentContainerView.layer.cornerRadius = 14
        
        // 키보드 노티피케이션을 처리하는 옵저버블입니다.
        // - Author: 김정민(kimjm010@icloud.com)
        Observable.merge(willShow, willHide)
            .bind(to: commentContainerViewBottomConstraint.rx.constant)
            .disposed(by: rx.disposeBag)
        
        // 댓글 및 대댓글을 추가합니다.
        // - Author: 김정민(kimjm010@icloud.com)
        var token = NotificationCenter.default.addObserver(forName: .newCommentDidInsert,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            if let newComment = noti.userInfo?["comment"] as? CommentListResponseData.Comment {
                guard let self = self else { return }
                self.commentList.append(newComment)
                self.sortedCommentList.append(newComment)
                
                self.sortedCommentList.sort {
                    if $0.originalCommentId == $1.originalCommentId {
                        return $0.commentId < $1.commentId
                    }
                    
                    return $0.originalCommentId < $1.originalCommentId
                }
                guard let index = self.sortedCommentList.firstIndex(where: { $0.commentId == newComment.commentId }) else { return }
                
                self.commentTextView.text = nil
                self.detailPostTableView.insertRows(at: [IndexPath(row: index, section: 2)], with: .left)
                self.detailPostTableView.scrollToRow(at: IndexPath(row: index, section: 2), at: .middle, animated: true)
            }
        }
        tokens.append(token)
        
        
        // 댓글의 placeholder상태를 관리합니다.
        //
        // 게시글 내용이 입력된 경우 placeholder 레이블을 숨깁니다.
        // - Author: 김정민(kimjm010@icloud.com)
        commentTextView.rx.text.orEmpty
            .map { $0.count > 0 }
            .bind(to: commentPlaceholderLabel.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
    }
    
    
    /// 뷰 계층에 모든 뷰들이 추가된 이후 호출됩니다.
    /// - Parameter animated: 윈도우에 뷰가 추가될 때 애니메이션 여부. 기본값은 true입니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 게시글 삭제
        let token = NotificationCenter.default.addObserver(forName: .alertDidSend, object: nil, queue: .main, using: { _ in
            let alertMenu = UIAlertController(title: "", message: "메뉴를 선택하세요.", preferredStyle: .actionSheet)
             
            let deleteAction = UIAlertAction(title: "게시글 삭제", style: .default) { _ in
                self.alertVersion2(title: "알림", message: "정말 삭제하시겠습니까?", handler: { _ in
                    
                    self.deletePost(postId: self.selectedPostId)
                    
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }, handler2: nil)
            }
            alertMenu.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alertMenu.addAction(cancelAction)
            
            self.present(alertMenu, animated: true, completion: nil)
        })
        tokens.append(token)
        
        // 이미지를 클릭시에 ExpandImageViewController로 이동
        // 이미지를 한 번 이상 클릭했을 때 중복되어서 옵저버가 등록되는 것을 방지
        if imageObserver == nil {
            imageObserver = NotificationCenter.default.addObserver(forName: .showImageVC,
                                                                   object: nil,
                                                                   queue: .main) {[weak self] _ in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "imageSegue", sender: nil)
            }
        }
        
        // 알림 메시지
        if alertToken == nil {
            alertToken = NotificationCenter.default.addObserver(forName: .postAlreadyLiked, object: nil, queue: .main, using: { [weak self] _ in
                guard let self = self else { return }
                Loaf("이미 공감한 게시글입니다.", state: .custom(.init(backgroundColor: .black)), sender: self).show(.short)
            })
        }
        
        // 댓글의 placeholder상태를 관리합니다.
        //
        // 게시글 내용이 입력된 경우 placeholder 레이블을 숨깁니다.
        // - Author: 김정민(kimjm010@icloud.com)
        commentTextView.rx.text.orEmpty
            .map { $0.count > 0 }
            .bind(to: commentPlaceholderLabel.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
   
    
    deinit {
        if let token = imageObserver {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = alertToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    /// 댓글을 오른쪽으로 Swipe해서 신고합니다.
    /// - Parameter indexPath: 댓글의 IndexPath
    /// - Author: 김정민(kimjm010@icloud.com)
    func reportCommentDelete(_ indexPath: IndexPath) {
        // TODO: 서버 구현 후 작업 예정입니다.
        #if DEBUG
        print(#function)
        print("댓글을 신고하시겠습니까?")
        #endif
        
        self.alertComment()
    }
    
    
    /// 댓글을 왼쪽으로 Swipe해서 삭제합니다
    /// - Parameter indexPath: 댓글의 IndexPath
    /// - Author: 김정민(kimjm010@icloud.com)
    func deleteComment(_ indexPath: IndexPath) {
        
        alertVersion2(title: "알림", message: "댓글을 삭제할까요?", handler: { _ in
            if indexPath.section == 3 {
                self.sortedCommentList.remove(at: indexPath.row)
            }
            
            self.detailPostTableView.reloadData()
        }, handler2: nil)
    }
    
    func adjustCommentContainerView() {
        
    }
}



/// 게시글 상세화면
/// - Author: 남정은(dlsl7080@gmail.com)
extension DetailPostViewController: UITableViewDataSource {
    
    /// 게시글 상세화면에 필요한 section 수를 리턴합니다.
    /// - Parameter tableView: 게시글 상세화면 테이블 뷰
    /// - Returns: section의 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    /// 각각의 section 별로 들어갈 셀의 개수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 게시글 상세화면 테이블 뷰
    ///   - section: 게시글 상세화면을 나누는 section index
    /// - Returns: section안에 들어갈 row의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // 작성자, 제목, 내용
        case 0:
            return 1
            
        // 게시글에 첨부된 이미지
        case 1:
            if postImageList.count == 0 {
                return 0
            }
            return 1
            
        // 게시글에 포함된 댓글
        case 2:
            return sortedCommentList.count
            
        default: return 0
        }
    }
    
    
    /// 게시글 상세화면을 나타내기 위한 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 게시글 상세화면 테이블 뷰
    ///   - indexPath: 게시글 상세화면 셀의 indexPath
    /// - Returns: 게시글 상세화면 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // 게시글 내용 표시하는 셀
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostContentTableViewCell", for: indexPath) as! PostContentTableViewCell
            
            guard let post = post else { return cell }
            cell.configure(post: post, isLiked: isLiked, isScrapped: isScrapped, scrapPostId: scrapPostId)
            return cell
            
        // 이미지 표시하는 셀
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageTableViewCell", for: indexPath) as! PostImageTableViewCell
           
            cell.configure(postImageList: postImageList)
            return cell
            
        // 댓글 및 대댓글 표시하는 셀
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            
            var comment = sortedCommentList[indexPath.row]
            if let date = BoardDataManager.shared.decodingFormatter.date(from: comment.createdAt) {
                let dateStr = date.commentDate
                comment.createdAt = dateStr
            }
            let isLiked = likeCommentList.contains { $0.commentId == comment.commentId }
            let likedComment = likeCommentList.first { $0.commentId == comment.commentId }
            cell.configure(comment: comment, isLiked: isLiked, likedComment: likedComment)
            
            return cell
            
        default: break
        }
        
        return UITableViewCell()
    }
}



/// 상세 게시글 테이블 뷰의 동작 처리
/// - Author: 김정민(kimjm010@icloud.com)
extension DetailPostViewController: UITableViewDelegate {
    
    /// 댓글을 오른쪽으로 Swipe하여 신고합니다.
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    /// - Returns: Leading끝에 표시될 SwipeAction
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 2  {
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
    
    
    /// 댓글을 왼쪽으로 Swipe하여 삭제합니다.
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    /// - Returns: Trailing끝에 표시될 SwipeAction
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 2 {
            let removeComment = UIContextualAction(style: .destructive, title: "댓글 삭제") { [weak self] action, v, completion in
                guard let self = self else { return }
                self.alertVersion2(title: "알림", message: "댓글을 삭제할까요?", handler: { _ in
                    
                    let id = self.sortedCommentList[indexPath.row].commentId
                    self.deleteComment(commentId: id)
                    NotificationCenter.default.post(name: .commentDidDelete, object: nil, userInfo: ["postId": self.post?.postId ?? 0])
                    
                    self.sortedCommentList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                }, handler2: nil)
                
                completion(true)
            }
            
            removeComment.backgroundColor = .darkGray
            
            let conf = UISwipeActionsConfiguration(actions: [removeComment])
            conf.performsFirstActionWithFullSwipe = true
            return conf
        }
        
        return nil
    }
    
    
    /// 댓글에 ContextMenu를 표시합니다.
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    ///   - point: 컨텍스트 메뉴를 표시하기 위한
    /// - Returns: 선택한 indexPath의 포인트
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        if indexPath.section == 2 {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
                let notiAction =
                UIAction(title: NSLocalizedString("댓글 신고", comment: "")) { action in
                    self.reportCommentDelete(indexPath)
                }
                
                let deleteAction =
                UIAction(title: NSLocalizedString("댓글 삭제", comment: ""),
                         attributes: .destructive) { action in
                    let id = self.sortedCommentList[indexPath.row].commentId
                    self.deleteComment(commentId: id)
                    NotificationCenter.default.post(name: .commentDidDelete, object: nil, userInfo: ["postId": self.post?.postId ?? 0])
                    
                    self.sortedCommentList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
                return UIMenu(title: "", children: [notiAction, deleteAction])
            })
        }
        return nil
    }
    
    
    /// 댓글을 선택했을 때, 대댓글 작성 여부를 확인합니다.
    /// - Parameters:
    ///   - tableView: 디테일포스트 테이블 뷰
    ///   - indexPath: 선택될 셀의 indexPath
    /// - Returns: 선택된 셀의 indexPath
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if sortedCommentList.count > 0 {
            let target = sortedCommentList[indexPath.row]

            if target.commentId != target.originalCommentId {
                return nil
            } else {
                return indexPath
            }
        }
        return nil
    }
    
    
    /// 댓글을 선택할 때, 대댓글을 작성합니다.
    /// - Parameters:
    ///   - tableView: 디테일포스트 테이블 뷰
    ///   - indexPath: 선택된 셀의 indexPath
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            alertVersion2(title: "알림", message: "대댓글을 작성하시겠습니까? :)") { _ in
                self.isReComment = true
                self.commentTextView.becomeFirstResponder()
            } handler2: { _ in
                self.commentTextView.resignFirstResponder()
            }
            
            let target = sortedCommentList[indexPath.row]
            commentId = target.commentId
            originalCommentId = target.originalCommentId
        }
    }
}
