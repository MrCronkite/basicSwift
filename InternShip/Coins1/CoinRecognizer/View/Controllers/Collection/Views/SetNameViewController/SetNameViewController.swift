

import UIKit

final class SetNameViewController: UIViewController {
    
    var presenter: SetNamePresenter?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var saveName: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction private func closeView(_ sender: Any) {
        presenter?.closeView()
    }
    
    @IBAction func save(_ sender: UIButton) {
        presenter?.saveName()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint.constant = keyboardHeight + 20
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = 58
        }
    }
}

extension SetNameViewController {
    private func setupView() {
        view.backgroundColor = .white
        closeBtn.setImage(Asset.Assets.closeMiniGray.image, for: .normal)
        closeBtn.setTitle("", for: .normal)
        
        let attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: Asset.Color.textGray.color]
        )
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textFieldName.frame.height))
        textFieldName.leftView = leftPaddingView
        textFieldName.leftViewMode = .always
        textFieldName.backgroundColor = Asset.Color.lightBlue.color
        textFieldName.borderStyle = .none
        textFieldName.layer.cornerRadius = 15
        textFieldName.placeholder = "rename_create".localized
        textFieldName.textColor = .black
        textFieldName.attributedPlaceholder = attributedPlaceholder
        textFieldName.delegate = self
        textFieldName.addDoneButtonOnKeyboard()
        
        titleName.text = "rename_collection_name".localized
        titleName.textColor = .black
        
        saveName.setTitle("save_btn".localized, for: .normal)
        saveName.tintColor = Asset.Color.orange.color
        saveName.backgroundColor = Asset.Color.nativ.color
        saveName.layer.cornerRadius = 25
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
}

extension SetNameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        var newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newText = ""
        }
        
        if newText.count > 0 {
            presenter?.textName = newText.trimmingCharacters(in: .whitespacesAndNewlines)
            saveName.backgroundColor = Asset.Color.orange.color
            saveName.tintColor = .white
        } else {
            saveName.backgroundColor = Asset.Color.nativ.color
            saveName.tintColor = Asset.Color.orange.color
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Asset.Color.orange.color.cgColor
        textField.backgroundColor = .white
        textField.placeholder = ""
        textField.tintColor = Asset.Color.orange.color
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.backgroundColor = Asset.Color.lightBlue.color
        textField.placeholder = "rename_create".localized
    }
}

extension SetNameViewController: SetNameViewProtocol {
    func succes() {
        dismissKeyboard()
        Activity.showAlert(title: "home_done".localized)
    }
}
