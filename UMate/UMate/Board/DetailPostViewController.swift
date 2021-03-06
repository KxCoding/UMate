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
    static let commentCountDidDecreased = Notification.Name("commentCountDidDecreased")
    static let commentCountDidIncreased = Notification.Name("commentCountDidIncreased")
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
    
    /// 좋아요, 스크랩, 메뉴 버튼 옵저버 저장
    var alertTokens = [NSObjectProtocol]()
    
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
        
        let newComment = CommentPostData(postId: selectedPostId, content: content, originalCommentId: originalCommentId ?? 0, isReComment: isReComment, createdAt: BoardDataManager.shared.postDateFormatter.string(from: Date()))
        
        send(commentPostData: newComment)
        let userInfo = ["postId": post?.postId ?? 0]
        NotificationCenter.default.post(name: .commentCountDidIncreased, object: nil, userInfo: userInfo)
        
        isReComment = false
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    /// 댓글을 서버에 저장합니다.
    /// - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
    func send(commentPostData: CommentPostData) {
        BoardDataManager.shared.provider.rx.request(.saveComment(commentPostData))
            .filterSuccessfulStatusCodes()
            .map(SaveCommentResponseData.self)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        let newResponse = CommentListResponseData.Comment.self
                        let userInfo = ["comment": newResponse]
                        NotificationCenter.default.post(name: .newCommentDidInsert, object: nil, userInfo: userInfo)
                    default:
                        break
                    }
                default:
                    break
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 댓글을 삭제합니다.
    /// - Parameter commentId: 댓글 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func deleteComment(commentId: Int, completion: @escaping (Bool) -> ()) {
        BoardDataManager.shared.provider.rx.request(.deleteComment(commentId))
            .filterSuccessfulStatusCodes()
            .map(CommonResponse.self)
            .subscribe(onSuccess: {
                if $0.code == ResultCode.ok.rawValue {
                    completion(true)
                } else {
                    completion(false)
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
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: {
                if $0.code == ResultCode.ok.rawValue {
                    NotificationCenter.default.post(name: .postDidDelete, object: nil, userInfo: ["postId": postId])
                } else {
                    Loaf("게시글 삭제 실패. 다시 시도해 주세요.",
                         state: .custom(.init(backgroundColor: .black)),
                         location: .bottom,
                         presentingDirection: .vertical,
                         dismissingDirection: .vertical,
                         sender: self).show(.short)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 게시글 상세정보를 불러옵니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func fetchPostDetail() {
        let shared = BoardDataManager.shared
        
        let postSummary = shared.fetchPostSummary(id: selectedPostId)
        let images = shared.fetchImages(postId: selectedPostId)
        let comments = shared.fetchComments(postId: selectedPostId)
        let likeComments = shared.fetchLikeComment()
        
        Observable.zip(postSummary, images, comments, likeComments)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.post = result.0.post
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
        
        // tabBar의 높이
        guard let tabBarHeight = self.tabBarController?.tabBar.frame.height else { return }
        
        // keyboard의 높이를 방출하는 옵저버블
        let willShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification,
                                                                  object: nil)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map { $0.cgRectValue.height - tabBarHeight }
        
        // keybaordr의 높이를 0으로 방출하는 옵저버블
        let willHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification,
                                                                  object: nil)
            .map { _ in CGFloat(0)}
        
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
            
            if let responseData = noti.userInfo?["comment"] as? CommentListResponseData.Comment {
                guard let self = self else { return }
                let newComment = CommentListResponseData.Comment(commentId: responseData.commentId,
                                                                 userId: responseData.userId,
                                                                 userName: responseData.userName,
                                                                 profileUrl: responseData.profileUrl,
                                                                 postId: responseData.postId,
                                                                 content: responseData.content,
                                                                 likeCnt: responseData.likeCnt,
                                                                 originalCommentId: responseData.originalCommentId,
                                                                 isReComment: responseData.isReComment,
                                                                 createdAt: responseData.createdAt,
                                                                 updatedAt: responseData.updatedAt)
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
        
        
        token = NotificationCenter.default.addObserver(forName: .postAlreadyLiked, object: nil, queue: .main, using: { [weak self] _ in
            self?.alertVersion3(title: "알림", message: "이미 좋아요를 눌렀습니다 :)", handler: nil)
        })
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .postAlreadyScrapped, object: nil, queue: .main, using: { [weak self] _ in
            self?.alertVersion3(title: "알림", message: "이미 존재합니다.", handler: nil)
        })
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .tryAgainLater, object: nil, queue: .main, using: { [weak self] _ in
            self?.alertVersion3(title: "알림", message: "작업에 실패하였습니다. 잠시 후 다시 시도해 주시기 바랍니다 :)", handler: nil)
        })
        tokens.append(token)
    }
    
    
    /// 뷰 계층에 모든 뷰들이 추가된 이후 호출됩니다.
    /// - Parameter animated: 윈도우에 뷰가 추가될 때 애니메이션 여부. 기본값은 true입니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 알림 메시지
        var token = NotificationCenter.default.addObserver(forName: .postAlreadyLiked, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else { return }
            Loaf("이미 공감한 게시글입니다.", state: .custom(.init(backgroundColor: .black)), sender: self).show(.short)
        })
        alertTokens.append(token)
        
        // 이미지를 클릭시에 ExpandImageViewController로 이동
        token =  NotificationCenter.default.addObserver(forName: .showImageVC,
                                                        object: nil,
                                                        queue: .main) {[weak self] _ in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "imageSegue", sender: nil)
        }
        alertTokens.append(token)
        
        // 게시글 삭제
        token = NotificationCenter.default.addObserver(forName: .menuSheetDidAlert, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else { return }
            
            let alertMenu = self.alertVersion4(title: "", message: "메뉴를 선택하세요")
            if self.post?.userId == LoginDataManager.shared.userId {
                let deleteAction = UIAlertAction(title: "게시글 삭제", style: .default) { _ in
                    self.alertVersion2(title: "알림", message: "정말 삭제하시겠습니까?", handler: { _ in
                        
                        self.deletePost(postId: self.selectedPostId)
                        
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                    }, handler2: nil)
                }
                alertMenu.addAction(deleteAction)
            } else {
                let reportAction = UIAlertAction(title: "게시글 신고", style: .default) { _ in
                    self.alertVersion3(title: "※ 신고하시겠습니까?", message: "\n해당 게시글이 부적절한 내용을 포함하여 신고합니다.") { _ in
                        Loaf("신고가 접수되었습니다.", state: .custom(.init(backgroundColor: .black)), location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show(.short)
                    }
                }
                alertMenu.addAction(reportAction)
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            alertMenu.addAction(cancelAction)
            
            self.present(alertMenu, animated: true, completion: nil)
        })
        alertTokens.append(token)
        
        // 댓글의 placeholder상태를 관리합니다.
        //
        // 게시글 내용이 입력된 경우 placeholder 레이블을 숨깁니다.
        // - Author: 김정민(kimjm010@icloud.com)
        commentTextView.rx.text.orEmpty
            .map { $0.count > 0 }
            .bind(to: commentPlaceholderLabel.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 뷰가 계층에서 사라지기 전에 호출됩니다.
    /// - Parameter animated: 애니메이션 여부. 기본값은 true입니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for token in alertTokens {
            NotificationCenter.default.removeObserver(token)
        }
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
            
            let comment = sortedCommentList[indexPath.row]
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
    
    /// 댓글을 왼쪽으로 Swipe하여 삭제합니다.
    /// - Parameters:
    ///   - tableView: 댓글을 포함하고 있는 TableView
    ///   - indexPath: 댓글의 indexPath
    /// - Returns: Trailing끝에 표시될 SwipeAction
    /// - Author: 김정민(kimjm010@icloud.com)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 2 && sortedCommentList[indexPath.row].userId == LoginDataManager.shared.userId {
            let removeComment = UIContextualAction(style: .destructive, title: "댓글 삭제") { [weak self] action, v, completion in
                
                guard let self = self else { return }
                
                self.alertVersion2(title: "알림", message: "댓글을 삭제할까요?", handler: { _ in
                    
                    let id = self.sortedCommentList[indexPath.row].commentId
                    self.deleteComment(commentId: id) { success in
                        if success {
                            NotificationCenter.default.post(name: .commentCountDidDecreased, object: nil, userInfo: ["postId": self.post?.postId ?? 0])
                            
                            self.sortedCommentList.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        } else {
                            Loaf("댓글 삭제 실패. 다시 시도해 주세요.", state: .custom(.init(backgroundColor: .black)), location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show(.short)
                        }
                    }
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
                let deleteAction = UIAction(title: NSLocalizedString("댓글 삭제", comment: ""), attributes: .destructive) { action in
                    let id = self.sortedCommentList[indexPath.row].commentId
                    self.deleteComment(commentId: id) { success in
                        if success {
                            NotificationCenter.default.post(name: .commentCountDidDecreased, object: nil, userInfo: ["postId": self.post?.postId ?? 0])
                            
                            self.sortedCommentList.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        } else {
                            Loaf("댓글 삭제 실패. 다시 시도해 주세요.", state: .custom(.init(backgroundColor: .black)), location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show(.short)
                        }
                    }
                }
                return UIMenu(title: "", children: [deleteAction])
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
