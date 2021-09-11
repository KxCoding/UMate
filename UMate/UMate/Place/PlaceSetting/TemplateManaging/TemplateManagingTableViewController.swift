//
//  TemplateManagingTableViewController.swift
//  UMate
//
//  Created by Effie on 2021/09/03.
//

import UIKit
import Loaf

class TemplateManagingTableViewController: UITableViewController {
    
    // MARK: Outlets - Editing Tools
    
    @IBOutlet weak var resetTemplateBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var nameCountLabel: UILabel!
    @IBOutlet weak var contentCountLabel: UILabel!
    
    // MARK: Outlets - Template list
    
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var contentLabel1: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var contentLabel2: UILabel!
    @IBOutlet weak var nameLabel3: UILabel!
    @IBOutlet weak var contentLabel3: UILabel!
    
    
    // MARK: Properties
    
    /// 리뷰 제한 글자수
    let nameCharLimit = 6
    let contentCharLimit = 300
    
    var currentEditingTemplate: ReviewTemplate = {
        guard let temp = PlaceUser.tempUser.userData.reviewTemplate.first else {
            return ReviewTemplate.init(id: 0, name: "temp", content: "content")
        }
        
        return temp
    }()
    
    
    // MARK: Loafs
    
    lazy var overLimitLoaf = Loaf("제목이나 내용의 글자 수 제한을 확인해주세요", state: .warning, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
    lazy var nothingChangedLoaf = Loaf("변경 사항이 없습니다", state: .warning, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
    lazy var savedLoaf = Loaf("저장되었습니다", state: .success, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
    lazy var loadedLoaf = Loaf("템플릿을 불러왔습니다", state: .success, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
    lazy var resetLoaf = Loaf("초기화되었습니다", state: .info, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
    lazy var editingTemplateLoaf = Loaf("현재 편집중인 템플릿입니다", state: .warning, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
    
    
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
    
    
    func updateListContents() {
        /// 순서대로 처리
        let nameLabels = [nameLabel1, nameLabel2, nameLabel3]
        let contentLabels = [contentLabel1, contentLabel2, contentLabel3]
        
        guard nameLabels.count == PlaceUser.tempUser.userData.reviewTemplate.count,
              contentLabels.count == PlaceUser.tempUser.userData.reviewTemplate.count else { return }
        for i in 0 ..< PlaceUser.tempUser.userData.reviewTemplate.count {
            let template = PlaceUser.tempUser.userData.reviewTemplate[i]
            nameLabels[i]?.text = template.name
            contentLabels[i]?.text = template.content
        }
    }
    
    func updateCount(of field: UITextInput) {
        switch field {
        case let content as UITextView:
            contentCountLabel.text = "\(content.text.count) / \(contentCharLimit)"
            contentCountLabel.textColor = content.text.count > contentCharLimit ? .systemRed : .tertiaryLabel
        case let title as UITextField:
            guard let titleText = title.text else { return }
            nameCountLabel.text = "\(titleText.count) / \(nameCharLimit)"
            nameCountLabel.textColor = titleText.count > nameCharLimit ? .systemRed : .tertiaryLabel
        default:
            break
        }
    }
    
    func updateCountOfAllField() {
        updateCount(of: nameTextField)
        updateCount(of: contentTextView)
    }
    
    
    /// 최근 저장된 템플릿에 따라 초기화 버튼, 저장 버튼 활성화 및 비활성화
    func checkIfAnyChangedAndSet() {
        if (nameTextField.text ?? "") == currentEditingTemplate.name &&
            contentTextView.text == currentEditingTemplate.content {
            updateFooterTitle(with: "변경 사항 없음!")
            resetTemplateBtn.isEnabled = false
            saveBtn.isEnabled = false
        } else {
            resetTemplateBtn.isEnabled = true
            saveBtn.isEnabled = true
            saveBtn.isEnabled = true
        }
    }
    
    func setInputSystem(withNewItemId id: Int, checkMsg: String, newFooter: String, loaf: Loaf) {
        
        /// 키보드 내리기
        nameTextField.endEditing(false)
        contentTextView.endEditing(false)
        
        /// 리셋 작업
        let resetting: ((UIAlertAction) -> Void) = { [weak self] _ in
            guard let self = self else { return }
            
            /// 현재 편집 중인 템플릿 속성을 재설정
            self.currentEditingTemplate = PlaceUser.tempUser.userData.reviewTemplate[id]
            
            /// 입력 시스템 설정
            self.nameTextField.text = self.currentEditingTemplate.name
            self.contentTextView.text = self.currentEditingTemplate.content
            self.updateFooterTitle(with: newFooter)
            
            /// 초기화 및 저장 버튼 비활성화
            self.resetTemplateBtn.isEnabled = false
            self.saveBtn.isEnabled = false
            
            /// 테이블 스크롤
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                       at: .top, animated: true)
            
            loaf.show(.custom(1.2))
        }
        
        /// 변경 사항이 없다면 경고창이 표시되지 않음
        guard let currentName = nameTextField.text,
              currentName != currentEditingTemplate.name ||
                contentTextView.text != currentEditingTemplate.content else {
            resetting(UIAlertAction())
            return
        }
        
        let alert = UIAlertController(title: "경고",
                                      message: checkMsg,
                                      preferredStyle: .alert)
        
        
        
        let resetAction = UIAlertAction(title: "네", style: .destructive, handler: resetting)
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(resetAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func doneBtnTapped() {
        view.endEditing(true)
    }
    
    
    func setupInputSystems() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let saveButton = UIBarButtonItem(title: "저장", style: .plain,
                                         target: self, action: #selector(saveNewTemplate(_:)))
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneBtnTapped))
        
        toolbar.setItems([saveButton, flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        nameTextField.inputAccessoryView = toolbar
        contentTextView.inputAccessoryView = toolbar
    }
    
    
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// UI 초기화
        [resetTemplateBtn, saveBtn].forEach({ $0?.configureStyle(with: [.squircleSmall]) })
        setupInputSystems()
        
        /// text field , text view delegation
        nameTextField.delegate = self
        contentTextView.delegate = self
        
        /// 리스트 초기화
        updateListContents()
        
        /// text view 초기화
        nameTextField.text = currentEditingTemplate.name
        contentTextView.text = currentEditingTemplate.content
        
        /// 제목, 내용 character count label 초기화
        updateCountOfAllField()
        
        /// 초기화 버튼 및 저장 버튼 상태 초기화
        resetTemplateBtn.isEnabled = false
        saveBtn.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(self, #function)
        contentTextView.endEditing(true)
    }
    
    
    // MARK: Actions
    
    /// 버튼을 누르면 작성 중이던 내용을 버리고 저장된 텍스트로 초기화하는 메소드
    /// - Parameter sender: 버튼
    @IBAction func resetTemplate(_ sender: UIButton) {
        setInputSystem(withNewItemId: currentEditingTemplate.id,
                       checkMsg: "작성 중인 내용은 저장되지 않아요.\n정말 초기화하실 건가요?",
                       newFooter: "이전 내용을 불러왔어요.",
                       loaf: resetLoaf)
    }
    
    
    /// 작성 중이던 텍스트를 템플릿으로 저장하는 메소드
    /// - Parameter sender: 버튼
    @IBAction func saveNewTemplate(_ sender: UIButton) {
        
        /// 키보드 내리기
        nameTextField.endEditing(false)
        contentTextView.endEditing(false)
        
        /// 변경 내용이 없으면 경고창
        if (nameTextField.text ?? "") == currentEditingTemplate.name &&
            contentTextView.text == currentEditingTemplate.content {
            nothingChangedLoaf.show(.custom(1.2))
        }
        
        /// 글자수 제한을 초과하면 저장 불가 경고창
        guard let title = nameTextField.text,
              title.count <= nameCharLimit,
              contentTextView.text.count <= contentCharLimit else {
            
            /// show loaf
            self.overLimitLoaf.show(.custom(1.2)) { [weak self] _ in
                guard let self = self else { return }
                /// loaf 표시 후 키보드 표시
                self.contentTextView.becomeFirstResponder()
            }
            return
        }
        
        /// 알림창
        let alert = UIAlertController(title: "알림", message: "새로 작성한 내용을 템플릿으로 저장할까요?", preferredStyle: .alert)
        
        let saveAction: ((UIAlertAction) -> Void) = { [weak self] _ in
            guard let self = self else { return }
            
            /// 템플릿을 사용자 데이터에 저장
            let new = ReviewTemplate(id: self.currentEditingTemplate.id,
                                     name: self.nameTextField.text ?? "",
                                     content: self.contentTextView.text)
            PlaceUser.tempUser.userData.reviewTemplate[self.currentEditingTemplate.id] = new
            
            /// 테이블 뷰 셀 업데이트
            guard let nameLabel = [self.nameLabel1, self.nameLabel2, self.nameLabel3][new.id] else { return }
            guard let contentLabel = [self.contentLabel1, self.contentLabel2, self.contentLabel3][new.id] else { return }
            nameLabel.text = new.name
            contentLabel.text = new.content
            
            /// 초기화 및 저장 버튼 비활성화
            self.resetTemplateBtn.isEnabled = false
            self.saveBtn.isEnabled = false
            
            /// show loaf
            self.savedLoaf.show(.custom(1.2))
            
            /// footer title 변경
            self.updateFooterTitle(with: "저장되었습니다. 멋진 템플릿이네요!")
        }
        
        let yes = UIAlertAction(title: "네", style: .default, handler: saveAction)
        let no = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// 제목 필드의 텍스트가 변경되면 호출 - 텍스트 상태에 따라 ui 업데이트
    /// - Parameter sender: 편집 중인 텍스트 필드
    @IBAction func titleDidChange(_ sender: UITextField) {
        updateFooterTitle(with: "작성 중...")
        checkIfAnyChangedAndSet()
        updateCount(of: sender)
    }
    
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.frame.height / 14
        case 1:
            return tableView.estimatedRowHeight
        case 2:
            return tableView.estimatedRowHeight
        default:
            return tableView.estimatedRowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 {
            /// 편집 중인 템플릿이면 경고
            if currentEditingTemplate.id == indexPath.row {
                editingTemplateLoaf.show(.custom(1.2))
                return
            } else {
                setInputSystem(withNewItemId: indexPath.row,
                               checkMsg: "수정 중인 내용은 저장되지 않아요.\n선택한 템플릿을 가져올까요?",
                               newFooter: "선택한 템플릿을 가져왔어요 :)",
                               loaf: loadedLoaf)
                
                updateCountOfAllField()
            }
        }
    }
    
}




// MARK: - Text Field delegate

extension TemplateManagingTableViewController: UITextFieldDelegate {
    
    /// 리턴 키를 누르면 다음 필드(내용 작성 필드)로 넘어가도록 하는 델리게이트 메소드
    /// - Parameter textField: text field
    /// - Returns: return 할지의 여부, 항상 리턴
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTextView.becomeFirstResponder()
        return true
    }
}



// MARK: - Text view delegate

extension TemplateManagingTableViewController: UITextViewDelegate {
    
    /// 필드의 내용이 변경될 때마다 호출되는 메소드
    /// - Parameter textView: 텍스트뷰
    func textViewDidChange(_ textView: UITextView) {
        updateFooterTitle(with: "작성 중...")
        checkIfAnyChangedAndSet()
        updateCount(of: textView)
    }
    
    
    /// 템플릿 내용 작성할 때 위치를 조정하는 메소드 (클리핑 방지)
    /// - Parameter textView: 내용 필드
    func textViewDidBeginEditing(_ textView: UITextView) {
        /*
         guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) else { return }
         guard let indexPath = tableView.indexPath(for: cell) else { return }
         tableView.scrollToRow(at: indexPath, at: .top, animated: true)
         */
    }
    
    
    
}
