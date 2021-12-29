//
//  TestInfoWriteTableViewController.swift
//  UMate
//
//  Created by 남정은 on 2021/09/07.
//

import DropDown
import Loaf
import UIKit
import RxSwift
import Moya
import NSObject_Rx


/// 시험정보 작성 화면에서 '공유하기' 버튼을 눌렀을 때 처리되는 동작에 대한 노티피케이션
/// - Author: 남정은(dlsl7080@gmail.com)
extension Notification.Name {
    static let testInfoDidShare = Notification.Name("testInfoDidShare")
}


/// 시험정보 작성 화면에 대한 클래스
/// - Author: 남정은(dlsl7080@gmail.com)
class TestInfoWriteViewController: CommonViewController {
    /// 시험작성 공유 화면 테이블 뷰
    @IBOutlet weak var testInfoTableView: UITableView!
    
    /// 테이블 뷰의 바텀 제약
    @IBOutlet weak var tableViewbottomConstraint: NSLayoutConstraint!
    
    /// 선택된 강의
    var lectureInfo: LectureInfoDetailResponse.LectrueInfo?
    
    
    /// 강의정보 화면으로 돌아갑니다.
    /// - Parameter sender: 엑스 버튼
    @IBAction func showDetailLectureVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 노티피케이션
        let token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: {noti in
                if let value = noti.userInfo?[
                    UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                    
                    let height = value.cgRectValue.height
                    if (UIDevice.current.userInterfaceIdiom == .phone) {
                        self.tableViewbottomConstraint.constant = height
                    } else if (UIDevice.current.userInterfaceIdiom == .pad) {
                        if (UIScreen.main.bounds.size.height - self.view.frame.size.height) / 2 < height {
                            self.tableViewbottomConstraint.constant = height - (UIScreen.main.bounds.size.height - self.view.frame.size.height) / 2
                        }
                    }
                    
                    // firstResponder가 UITextField라면 하단스크롤
                    if let _ = self.view.window?.firstResponder as? UITextField {
                        DispatchQueue.main.async {
                            self.testInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
                        }
                    }
                    
                }
            })
            tokens.append(token)
        
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                $0.0.tableViewbottomConstraint.constant = 0
            })
            .disposed(by: rx.disposeBag)
        
        // 입력란 추가시 테이블 뷰 리로드
        NotificationCenter.default.rx.notification(.testInfoInputFieldDidInsert, object: nil)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                $0.0.testInfoTableView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        // 시험정보 공유 버튼 클릭시 화면 dismiss
        NotificationCenter.default.rx.notification(.testInfoDidShare, object: nil)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                $0.0.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 뷰 계층에 모든 뷰들이 추가된 이후 호출됩니다.
    /// - Parameter animated: 윈도우에 뷰가 추가될 때 애니메이션 여부. 기본값은 true입니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        // 작성 경고문
        var token = NotificationCenter.default.addObserver(forName: .wirteTestInfoCheckingAlertDidSend, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            self.alertVersion3(title: "시험 정보를 공유하시겠습니까?", message: "\n※ 등록 후에는 수정하거나 삭제할 수 없습니다.\n\n※ 허위/중복/성의없는 정보를 작성할 경우, 서비스 이용이 제한될 수 있습니다.") { _ in
                if let newTestInfo = noti.userInfo?["testInfo"] as? TestInfoPostData {
           
                    self.sendTestInfoData(testInfoData: newTestInfo)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        tokens.append(token)
        
        // 알림창 노티피케이션
        token = NotificationCenter.default.addObserver(forName: .testInfoAlertDidSend, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            if let alertKey = noti.userInfo?["alertKey"] as? Int {
                switch alertKey {
                case 0:
                    Loaf("이 과목을 수강하신 학기를 선택해주세요.", state: .custom(.init(backgroundColor: .black)), sender: self).show(.short)
                case 1:
                    Loaf("시험 종류를 선택해주세요.", state: .custom(.init(backgroundColor: .black)), sender: self).show(.short)
                case 2:
                    Loaf("시험 전략에 대해 좀 더 성의있는 작성을 부탁드립니다 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show(.short)
                case 3:
                    Loaf("문제 유형을 선택해주세요.", state: .custom(.init(backgroundColor: .black)), sender: self).show(.short)
                case 4:
                    Loaf("문제 예시를 더 세부적으로 적어주세요.", state: .custom(.init(backgroundColor: .black)), sender: self).show(.short)
                default:
                    break
                }
            }
        }
        tokens.append(token)
    }
    
    
    /// 뷰가 계층에서 사라지기 전에 호출됩니다.
    /// - Parameter animated: 애니메이션 여부. 기본값은 true입니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    /// 작성한 시험 정보를 서버에 저장합니다.
    /// - Parameter testInfoData: 시험 정보 객체
    ///   - Auhtor: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    func sendTestInfoData(testInfoData: TestInfoPostData) {
        BoardDataManager.shared.provider.rx.request(.saveTestInfoData(testInfoData))
            .filterSuccessfulStatusCodes()
            .map(SaveTestInfoResponseData.self)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        var exampleList = [TestInfoListResponse.TestInfo.Example]()
                        response.examples.forEach {
                            let newExample = TestInfoListResponse.TestInfo.Example(exampleId: $0.exampleId, testInfoId: $0.testInfoId, content: $0.content)
                            exampleList.append(newExample)
                        }
                        
                        let newTestInfo = TestInfoListResponse.TestInfo(testInfoId: response.testInfo.testInfoId,
                                                                        userId: response.testInfo.userId,
                                                                        lectureInfoId: response.testInfo.lectureInfoId,
                                                                        semester: response.testInfo.semester,
                                                                        testType: response.testInfo.testType,
                                                                        testStrategy: response.testInfo.testStrategy,
                                                                        questionTypes: response.testInfo.questionTypes,
                                                                        examples: exampleList,
                                                                        createdAt: response.testInfo.createdAt)
                        
                        let userInfo = ["testInfo": newTestInfo]
                        NotificationCenter.default.post(name: .testInfoDidShare, object: nil, userInfo: userInfo)
                        
                    case ResultCode.fail.rawValue:
                        self.alertVersion3(title: "알림", message: "이미 존재하는 시험정보 입니다.", handler: nil)
                    default:
                        break
                    }
                case .failure(let error):
                    self.alertVersion3(title: "알림", message: error.localizedDescription, handler: nil)
                }
            }
            .disposed(by: rx.disposeBag)
    }
}



/// 시험정보 작성 화면을 나타냄
/// - Author: 남정은(dlsl7080@gmail.com)
extension TestInfoWriteViewController: UITableViewDataSource {
    /// 시험정보 작성 화면 셀의 개수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 시험정보 작성 화면 테이블 뷰
    ///   - section: 시험정보 작성 화면을 나누는 section
    /// - Returns: section 안에 포함된 row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    /// 시험정보 작성 화면 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 시험정보 작성 화면 테이블 뷰
    ///   - indexPath: 시험정보 작성 화면 셀의 indexPath
    /// - Returns: 시험정보 작성 화면 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestInfoWriteTableViewCell", for: indexPath) as! TestInfoWriteTableViewCell
        guard let lecture = lectureInfo else {
            return cell
        }
        
        cell.receiveSemestersAndAddDropDownData(lecture: lecture)
        return cell
    }
}




