//
//  TemplateManagingTableViewController.swift
//  UMate
//
//  Created by Effie on 2021/09/03.
//

import Loaf
import UIKit


/// 리뷰 템플릿 관리 화면
/// - Author: 박혜정(mailmelater11@gmail.com)
class TemplateManagingTableViewController: UITableViewController {
    
    // MARK: Outlets - Editing Tools
    
    /// 초기화 버튼
    @IBOutlet weak var resetTemplateBtn: UIButton!
    
    /// 저장 버튼
    @IBOutlet weak var saveBtn: UIButton!
    
    /// 템플릿 이름 텍스트 필드
    @IBOutlet weak var nameTextField: UITextField!
    
    /// 템플릿 내용 텍스트 뷰
    @IBOutlet weak var contentTextView: UITextView!
    
    /// 현재 이름 길이 레이블
    @IBOutlet weak var nameCountLabel: UILabel!
    
    /// 현재 내용 길이 레이블
    @IBOutlet weak var contentCountLabel: UILabel!
    
    
    // MARK: Outlets - Template list
    
    /// 템플릿 1의 이름
    @IBOutlet weak var nameLabel1: UILabel!
    
    /// 템플릿 1의 내용 미리보기
    @IBOutlet weak var contentLabel1: UILabel!
    
    /// 템플릿 2의 이름
    @IBOutlet weak var nameLabel2: UILabel!
    
    /// 템플릿 2의 내용 미리보기
    @IBOutlet weak var contentLabel2: UILabel!
    
    /// 템플릿 3의 이름
    @IBOutlet weak var nameLabel3: UILabel!
    
    /// 템플릿 3의 내용 미리보기
    @IBOutlet weak var contentLabel3: UILabel!
    
    
    // MARK: Properties
    
    /// 이름 제한 글자수
    let nameCharLimit = 6
    
    /// 내용 제한 글자수
    let contentCharLimit = 300
    
    /// 현재 편집 중인 템플릿
    var currentEditingTemplate: ReviewTemplate = {
        guard let temp = PlaceUser.tempUser.userData.reviewTemplate.first else {
            return ReviewTemplate.init(id: 0, name: "temp", content: "content")
        }
        
        return temp
    }()
    
    
    // MARK: Loafs
    
    /// 글자수 제한 초과 알림 토스트
    lazy var overLimitLoaf = Loaf("제목이나 내용의 글자 수 제한을 확인해주세요",
                                  state: .warning, location: .top,
                                  presentingDirection: .vertical,
                                  dismissingDirection: .vertical, sender: self)
    
    /// 변경 사항 없음 알림 토스트
    lazy var nothingChangedLoaf = Loaf("변경 사항이 없습니다",
                                       state: .warning, location: .top,
                                       presentingDirection: .vertical,
                                       dismissingDirection: .vertical, sender: self)
    
    /// 저장 알림 토스트
    lazy var savedLoaf = Loaf("저장되었습니다",
                              state: .success, location: .top,
                              presentingDirection: .vertical,
                              dismissingDirection: .vertical, sender: self)
    
    /// 템플릿 로드 알림 토스트
    lazy var loadedLoaf = Loaf("템플릿을 불러왔습니다",
                               state: .success, location: .top,
                               presentingDirection: .vertical,
                               dismissingDirection: .vertical, sender: self)
    
    /// 템플릿이 초기화되었음을 알리는 토스트
    lazy var resetLoaf = Loaf("초기화되었습니다",
                              state: .info, location: .top,
                              presentingDirection: .vertical,
                              dismissingDirection: .vertical, sender: self)
    
    /// 편집 중인 템플릿 선택 알림 토스트
    lazy var editingTemplateLoaf = Loaf("현재 편집중인 템플릿입니다",
                                        state: .warning, location: .top,
                                        presentingDirection: .vertical,
                                        dismissingDirection: .vertical, sender: self)
    
    
    // MARK: Actions
    
    /// 수정 중인 템플릿을 초기화합니다.
    ///
    /// 작성 중이던 내용을 버리고 마지막으로 저장된 텍스트를 불러옵니다.
    /// - Parameter sender: 버튼
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func resetTemplate(_ sender: UIButton) {
        setInputSystem(withNewItemId: currentEditingTemplate.id,
                       checkMsg: "작성 중인 내용은 저장되지 않아요.\n정말 초기화하실 건가요?",
                       newFooter: "이전 내용을 불러왔어요.",
                       loaf: resetLoaf)
    }
    
    
    /// 작성 내용을 저장합니다.
    ///
    /// 저장 전 변경 사항이 있는지 확인하고 글자수 제한 초과 여부를 확인합니다. 저장 후 UI를 업데이트 하고 확인 토스트를 표시합니다.
    /// - Parameter sender: 저장 버튼
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func saveNewTemplate(_ sender: UIButton) {
        
        nameTextField.endEditing(false)
        contentTextView.endEditing(false)
        
        if (nameTextField.text ?? "") == currentEditingTemplate.name &&
            contentTextView.text == currentEditingTemplate.content {
            nothingChangedLoaf.show(.custom(1.2))
        }
        
        guard let title = nameTextField.text,
              title.count <= nameCharLimit,
              contentTextView.text.count <= contentCharLimit else {
            
            self.overLimitLoaf.show(.custom(1.2)) { [weak self] _ in
                guard let self = self else { return }
                self.contentTextView.becomeFirstResponder()
            }
            return
        }
        
        let alert = UIAlertController(title: "알림", message: "새로 작성한 내용을 템플릿으로 저장할까요?", preferredStyle: .alert)
        
        let saveAction: ((UIAlertAction) -> Void) = { [weak self] _ in
            guard let self = self else { return }
            
            let new = ReviewTemplate(id: self.currentEditingTemplate.id,
                                     name: self.nameTextField.text ?? "",
                                     content: self.contentTextView.text)
            PlaceUser.tempUser.userData.reviewTemplate[self.currentEditingTemplate.id] = new
            
            guard let nameLabel = [self.nameLabel1, self.nameLabel2, self.nameLabel3][new.id] else { return }
            guard let contentLabel = [self.contentLabel1, self.contentLabel2, self.contentLabel3][new.id] else { return }
            nameLabel.text = new.name
            contentLabel.text = new.content
            
            self.resetTemplateBtn.isEnabled = false
            self.saveBtn.isEnabled = false
            
            self.savedLoaf.show(.custom(1.2))
            
            self.updateFooterTitle(with: "저장되었습니다. 멋진 템플릿이네요!")
        }
        
        let yes = UIAlertAction(title: "네", style: .default, handler: saveAction)
        let no = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// 템플릿 이름이 바뀌면 UI를 업데이트 합니다.
    /// 템플릿 이름 필드의 텍스트가 변경되면 호출되며, 수정된 텍스트의 상태를 확인한 후 UI를 업데이트합니다.
    /// - Parameter sender: 편집 중인 텍스트 필드
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func titleDidChange(_ sender: UITextField) {
        updateFooterTitle(with: "작성 중...")
        
        checkIfAnyChangedAndSet()
        
        updateCount(of: sender)
    }
    
    
    // MARK: Methods
    
    /// 첫 번째 섹션의 footer title을 설정합니다.
    /// - Parameter newTitle: 설정할 문자열
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    
    
    /// 템플릿 리스트의 데이터를 업데이트 합니다.
    ///
    /// 순서대로 처리하기 위해 배열에 저장하고 시행을 반복합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func updateListContents() {
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

    
    /// 카운트 레이블을 업데이트합니다.
    /// - Parameter field: 글자 수 확인 대상
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    
    /// 모든 카운트 레이블을 업데이트합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func updateCountOfAllField() {
        updateCount(of: nameTextField)
        updateCount(of: contentTextView)
    }
    
    
    /// 수정 상태에 따라 초기화 버튼, 저장 버튼의 활성화 상태를 업데이트 합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    
    /// 입력 필드를 설정합니다.
    ///
    /// 수정 사항을 리셋하거나, 특정 템플릿을 편집하기 위해 불러왔을 때 호출됩니다. 수정 상태에 따라 다른 방식으로 동작합니다.
    /// - Parameters:
    ///   - id: 템플릿의 ID
    ///   - checkMsg: 경고창에 표시할 확인 메시지
    ///   - newFooter: 리셋 후 새로 표시할 footer title
    ///   - loaf: 리셋 후 표시할 토스트
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func setInputSystem(withNewItemId id: Int, checkMsg: String, newFooter: String, loaf: Loaf) {
        
        nameTextField.endEditing(false)
        contentTextView.endEditing(false)
        
        let resetting: ((UIAlertAction) -> Void) = { [weak self] _ in
            guard let self = self else { return }
            
            self.currentEditingTemplate = PlaceUser.tempUser.userData.reviewTemplate[id]
            
            self.nameTextField.text = self.currentEditingTemplate.name
            self.contentTextView.text = self.currentEditingTemplate.content
            self.updateFooterTitle(with: newFooter)
            
            self.resetTemplateBtn.isEnabled = false
            self.saveBtn.isEnabled = false
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                       at: .top, animated: true)
            
            loaf.show(.custom(1.2))
        }
        
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
    
    
    /// 키보드 툴바의 Done 버튼이 눌리면 편집을 종료합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @objc func doneBtnTapped() {
        view.endEditing(true)
    }
    
    
    /// 키보드 툴바를 설정합니다.
    ///
    /// 저장 버튼과 Done 버튼을 추가합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    /// 뷰가 로드되었을 때 화면을 초기화합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [resetTemplateBtn, saveBtn].forEach({ $0?.configureStyle(with: [.smallRoundedRect]) })
        
        setupInputSystems()
        
        nameTextField.delegate = self
        contentTextView.delegate = self
        
        updateListContents()
        
        nameTextField.text = currentEditingTemplate.name
        contentTextView.text = currentEditingTemplate.content
        
        updateCountOfAllField()
        
        resetTemplateBtn.isEnabled = false
        saveBtn.isEnabled = false
    }
    
    
    // MARK: Table View Delegate Methods
    
    /// 테이블 뷰에서 표시할 섹션의 개수를 리턴합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    /// - Parameter tableView: 테이블 뷰
    /// - Returns: 섹션의 개수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    /// 지정된 섹션에서 표시할 항목의 개수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 포함되는 항목의 개수
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    /// 지정된 indexpath의 셀 높이를 제한합니다.
    /// - Parameters:
    ///   - tableView: 이 정보를 요청하는 table view
    ///   - indexPath: 열의 위치를 가리키는 index path
    /// - Returns: 열의 높이
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.frame.height / 14
        default:
            return tableView.estimatedRowHeight
        }
    }
    
    
    /// 셀이 선택되면 선택된 템플릿을 불러옵니다.
    ///
    /// 현재 편집 중인 템플릿을 선택하면 경고 토스트를 표시하고, 그렇지 않으면 템플릿을 불러옵니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 선택된 indexpath
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 {
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
    
    /// 리턴 키를 누르면 다음 필드로 입력 포커스를 옮깁니다.
    ///
    /// 이름 필드인 텍스트 필드에서 편집을 종료하고, 내용 편집을 시작합니다.
    /// - Parameter textField: 텍스트 필드
    /// - Returns: return 할지의 여부. 항상 리턴합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTextView.becomeFirstResponder()
        return true
    }
}



// MARK: - Text view delegate

extension TemplateManagingTableViewController: UITextViewDelegate {
    
    /// 필드의 내용이 변경되면 UI를 업데이트 합니다.
    /// - Parameter textView: 텍스트뷰
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func textViewDidChange(_ textView: UITextView) {
        updateFooterTitle(with: "작성 중...")
        checkIfAnyChangedAndSet()
        updateCount(of: textView)
    }
}
