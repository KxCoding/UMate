//
//  BoardDataManager.swift
//  UMate
//
//  Created by 남정은 on 2021/11/02.
//

import Foundation
import UIKit
import Moya
import RxSwift


/// 게시판에 사용되는 데이터 관리
/// - Author: 남정은(dlsl7080@gmail.com)
class BoardDataManager {
    
    static let shared = BoardDataManager()
    private init() { }
    
    /// 데이터 엔코더
    let encoder = JSONEncoder()
    
    /// 날짜 파싱 포매터
    let postDateFormatter: ISO8601DateFormatter = {
       let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return f
    }()
    
    /// 서버 날짜를 Date로 변환할 때 사용
    let decodingFormatter: DateFormatter = {
       let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        f.calendar = Calendar(identifier: .iso8601)
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.locale = Locale(identifier: "en_US_POSIX")
        
        return f
    }()
    
    /// 리뷰 평균 소수점 설정
    let numberFormatter: NumberFormatter = {
       let f = NumberFormatter()
        f.maximumFractionDigits = 1
        return f
    }()
    
    /// 서버 요청 API
    let session = URLSession.shared
 
    /// 캐시 생성
    let cache = NSCache<NSURL,UIImage>()
    
    /// 네트워크 요청 객체
    let provider = MoyaProvider<BoardService>()
    
    /// 옵저버블 리소스 정리
    let disposeBag = DisposeBag()
    
    /// ViewController의 Extension을 사용하기 위한 속성
    let vc = UIViewController()
    
    
    /// 캐시에서 이미지를 불러오거나 이미지를 새로 다운로드 합니다.
    /// - Parameters:
    ///   - urlString: 이미지를 다운할 urlString
    ///   - completion: 완료블록
    ///   - Author: 남정은(dlsl7080@gmail.com)
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = NSURL(string: urlString) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        if let image = cache.object(forKey: url) { //url이 만들어졌다면 캐시에서 그에 해당하는 이미지를 가져옴.
            DispatchQueue.main.async {
                completion(image) //성공하면 메인쓰레드에 image를 전달함.
            }
        // 캐시에 이미지가 없다면 새로 다운로드
        } else {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url as URL) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                self.cache.setObject(image, forKey: url)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    
    /// UIImage 사이즈를 조절합니다.
    /// - Parameters:
    ///   - image: 이미지
    ///   - targetSize: 원하는 사이즈
    /// - Returns: 사이즈가 바뀐 이미지
    /// - Author: 남정은(dlsl7080@gmail.com)
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width// 원하는 사이즈와 원래사이즈의 배율 계산
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // 비트맵을 기반으로 이미지 생성
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        
        // 지정한 사이즈에 이미지 그리기
        image.draw(in: rect)
        
        // 이미지 생성 완료
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        
        // 컨텍스트를 삭제
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    /// 댓글 좋아요를 추가합니다.
    /// - Parameter likeCommentPostData: 댓글 좋아요 정보 객체
    /// - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    func sendCommentLikeData(likeCommentPostData: LikeCommentPostData,
                             completion: @escaping (Bool, SaveLikeCommentResponseData) -> ()) {
        provider.rx.request(.saveCommentLikeData(likeCommentPostData))
            .filterSuccessfulStatusCodes()
            .map(SaveLikeCommentResponseData.self)
            .observe(on: MainScheduler.instance)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        completion(true, response)
                        
                    case ResultCode.fail.rawValue:
                        self.vc.alertVersion3(title: "알림", message: "이미 댓글 좋아요를 추가하셨습니다.", handler: nil)
                    default:
                        break
                    }
                case .failure(let error):
                    self.vc.alertVersion3(title: "알림", message: error.localizedDescription, handler: nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    /// 댓글 좋아요를 삭제합니다.
    /// - Parameter likeCommentId: 댓글 좋아요 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    func deleteLikeComment(likeCommentId: Int, completion: @escaping (Bool) -> ()) {
        provider.rx.request(.deleteLikeComment(likeCommentId))
            .filterSuccessfulStatusCodes()
            .map(CommonResponse.self)
            .subscribe(onSuccess: {
                if $0.code == ResultCode.ok.rawValue {
                    #if DEBUG
                    print("삭제 성공")
                    #endif
                    completion(true)
                } else {
                    #if DEBUG
                    print("삭제 실패")
                    #endif
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    /// 게시글의 일부 정보를 불러옵니다.
    /// - Parameters:
    ///   - id: 게시글 Id
    ///   - Author: 남정은(dlsl7080@gmail.com)
    func fetchPostSummary(id: Int) -> Observable<PostDtoResponseData> {
        return BoardDataManager.shared.provider.rx.request(.detailPost(id))
            .filterSuccessfulStatusCodes()
            .map(PostDtoResponseData.self)
            .asObservable()
    }
    
    
    /// 게시글 이미지를 불러옵니다.
    /// - Parameter postId: 게시글 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    func fetchImages(postId: Int) -> Observable<[ImageListResponseData.PostImage]> {
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
    func fetchComments(postId: Int) -> Observable<CommentListResponseData> {
        return BoardDataManager.shared.provider.rx.request(.commentList(postId))
            .filterSuccessfulStatusCodes()
            .map(CommentListResponseData.self)
            .catchAndReturn(CommentListResponseData(lastId: 0, list: [], code: 0, message: nil))
            .asObservable()
    }
    
    
    /// 댓글의 좋아요 정보를 불러옵니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    func fetchLikeComment() -> Observable<[LikeCommentListResponse.LikeComment]> {
        return BoardDataManager.shared.provider.rx.request(.likeCommentList)
            .filterSuccessfulStatusCodes()
            .map(LikeCommentListResponse.self)
            .map { $0.list }
            .catchAndReturn([])
            .asObservable()
    }
   
    
    /// 강의목록 불러오는 양
    let lecturePageSize = 12
    
    /// 강의정보 불러오는 중
    var lectureIsFetching = false
    
    /// 전체 강의 목록 개수
    var totalCount = 0
    
    
    /// 최신 강의평 목록을 불러옵니다.
    ///  - Author: 남정은(dlsl7080@gmail.com)
    func fetchRecentReview(lecturePage: Int) -> Observable<[LectureInfoListResponseData.LectureInfo]> {
        lectureIsFetching = true
        
        
        return BoardDataManager.shared.provider.rx.request(.recentLectureReviewList(lecturePage, lecturePageSize))
            .filterSuccessfulStatusCodes()
            .map(LectureInfoListResponseData.self)
            .map { [weak self] data in
                self?.totalCount = data.totalCount
                
                self?.lectureIsFetching = false
                return data.list
            }
            .asObservable()
            .catchAndReturn([])
    }
    
    
    /// 일부 강의 정보를 불러옵니다.
    /// - Parameter lectureInfoId: 강의 정보 Id
    ///  - Author: 남정은(dlsl7080@gmail.com)
    func fetchLectureInfo(lectureInfoId: Int) -> Observable<LectureInfoDetailResponse.LectrueInfo> {
        return BoardDataManager.shared.provider.rx.request(.detailLectureInfo(lectureInfoId))
            .filterSuccessfulStatusCodes()
            .map(LectureInfoDetailResponse.self)
            .map { $0.lectureInfo }
            .asObservable()
            .catchAndReturn(LectureInfoDetailResponse.LectrueInfo(lectureInfoId: 0, professorId: 0, title: "", bookName: "", bookLink: "", semesters: ""))
    }
    
    
    /// 강의평을 불러옵니다.
    /// - Parameter lectureInfoId: 강의 정보 Id
    ///  - Author: 남정은(dlsl7080@gmail.com)
    func fetchLectureReviews(lectureInfoId: Int) -> Observable<[LectureReviewListResponse.LectureReview]> {
        return BoardDataManager.shared.provider.rx.request(.lectureReviewList(lectureInfoId))
            .filterSuccessfulStatusCodes()
            .map(LectureReviewListResponse.self)
            .map { $0.lectureReviews }
            .asObservable()
            .catchAndReturn([])
    }
    
    
    /// 시험 정보를 불러옵니다.
    /// - Parameter lectureInfoId: 강의 정보 Id
    ///  - Author: 남정은(dlsl7080@gmail.com)
    func fetchTestInfos(lectureInfoId: Int) -> Observable<[TestInfoListResponse.TestInfo]> {
        return BoardDataManager.shared.provider.rx.request(.testInfoList(lectureInfoId))
            .map(TestInfoListResponse.self)
            .map {$0.testInfos }
            .asObservable()
            .catchAndReturn([])
    }
}




/// 이미지 첨부 방식
/// - Author: 김정민(kimjm010@icloud.com)
enum SelectImageAttachActionType {
    case find
    case take
    case close
}

