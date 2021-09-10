//
//  TemplateManagingTableViewController.swift
//  UMate
//
//  Created by Effie on 2021/09/03.
//

import UIKit

class TemplateManagingTableViewController: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var resetTemplateBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var templateTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    // MARK: Properties
    
    /// 리뷰 제한 글자수
    let reviewTextLimit = 500
    
    
    // MARK: Methods
    
    /// footer title을 설정하는 메소드
    /// - Parameter newTitle: 설정한 문자열
    private func updateFooterTitle(with newTitle: String) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        
        if let containerView = tableView.footerView(forSection: 0) {
            containerView.textLabel!.text = newTitle
            containerView.sizeToFit()
        }
        
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// navigation controller delegation
        navigationController?.delegate = self
        
        /// UI 초기화
        [resetTemplateBtn, saveBtn].forEach({ $0?.configureStyle(with: [.squircleSmall]) })
        
        /// text view delegation
        templateTextView.delegate = self
        
        /// text view 초기화
        templateTextView.text = PlaceUser.tempUser.userData.reviewTemplate
        
        /// count label 초기화
        countLabel.text = "\(templateTextView.text.count) / \(reviewTextLimit) (공백 포함)"
        
        /// 초기화 버튼 및 저장 버튼 상태 초기화
        resetTemplateBtn.isEnabled = false
        saveBtn.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        next?.touchesBegan(touches, with: event)
        
        print(self, #function)
        templateTextView.endEditing(true)
    }
    
    
    // MARK: Actions
    
    /// 버튼을 누르면 작성 중이던 내용을 버리고 저장된 텍스트로 초기화하는 메소드
    /// - Parameter sender: 버튼
    @IBAction func resetTemplate(_ sender: UIButton) {
        
        /// 변경 사항이 없다면 경고창이 표시되지 않음
        guard templateTextView.text != PlaceUser.tempUser.userData.reviewTemplate else {
            return
        }
        
        let msg = "작성 중인 내용을 버리고 마지막으로\n저장된 템플릿으로 초기화됩니다.\n정말 초기화하실 건가요?"
        
        let alert = UIAlertController(title: "경고",
                                      message: msg,
                                      preferredStyle: .alert)
        
        /// 리셋 작업
        let resetting: ((UIAlertAction) -> Void) = { [weak self] _ in
            guard let self = self else { return }
            
            self.templateTextView.text = PlaceUser.tempUser.userData.reviewTemplate
            self.updateFooterTitle(with: "이전 내용을 불러왔어요.")
            
            /// 초기화 및 저장 버튼 비활성화
            self.resetTemplateBtn.isEnabled = false
            self.saveBtn.isEnabled = false

        }
        
        let resetAction = UIAlertAction(title: "초기화", style: .destructive, handler: resetting)
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(resetAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// 작성 중이던 텍스트를 템플릿으로 저장하는 메소드
    /// - Parameter sender: 버튼
    @IBAction func saveNewTemplate(_ sender: UIButton) {
        
        /// 글자수 제한을 초과하면 저장 불가 경고창
        guard templateTextView.text.count <= reviewTextLimit else {
            alert(message: "작성하신 템플릿은 제한 글자수를 초과해요")
            return
        }
        
        /// 알림창
        let alert = UIAlertController(title: "알림", message: "새로 작성한 내용을 템플릿으로 저장할까요?", preferredStyle: .alert)
        
        let saveAction: ((UIAlertAction) -> Void) = { [weak self] _ in
            guard let self = self else { return }
            
            /// 템플릿을 사용자 데이터에 저장
            PlaceUser.tempUser.userData.reviewTemplate = self.templateTextView.text
            
            /// 초기화 및 저장 버튼 비활성화
            self.resetTemplateBtn.isEnabled = false
            self.saveBtn.isEnabled = false
            
            /// footer title 변경
            self.updateFooterTitle(with: "저장되었습니다. 멋진 템플릿이네요!")
        }
        
        let yes = UIAlertAction(title: "네", style: .default, handler: saveAction)
        let no = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.frame.height / 14
        case 1:
            return tableView.frame.height / 2.5
        default:
            return tableView.estimatedRowHeight
        }
    }
    
}




// MARK: - Text view delegate

extension TemplateManagingTableViewController: UITextViewDelegate {
    
    /// 필드의 내용이 변경될 때마다 호출되는 메소드
    /// - Parameter textView: 텍스트뷰
    func textViewDidChange(_ textView: UITextView) {
        updateFooterTitle(with: "작성 중...")
        
        /// 최근 저장된 템플릿에 따라 초기화 버튼, 저장 버튼 활성화 및 비활성화
        if textView.text == PlaceUser.tempUser.userData.reviewTemplate {
            updateFooterTitle(with: "변경 사항 없음!")
            resetTemplateBtn.isEnabled = false
            saveBtn.isEnabled = false
        } else {
            resetTemplateBtn.isEnabled = true
            saveBtn.isEnabled = true
            saveBtn.isEnabled = true
        }
        
        /// 글자 개수 카운트
        countLabel.text = "\(textView.text.count) / \(reviewTextLimit) (공백 포함)"
        
        /// 글자 수 제한 초과하면 글자 색으로 경고
        countLabel.textColor = textView.text.count > reviewTextLimit ? .systemRed : .tertiaryLabel
    }
    
}




// MARK: - Navigation Controller delegate

extension TemplateManagingTableViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let parentVC = viewController as? PlaceSettingTableViewController {
            
        }
    }
}
