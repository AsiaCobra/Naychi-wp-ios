//
//  TextField.swift
//  FWD
//
//  Created by Codigo NOL on 20/05/2020.
//  Copyright © 2020 codigo. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

@objc public protocol TextFieldDelegate {
    @objc optional func textField(didBeginEditing textField: TextField)
    @objc optional func textField(shouldBeginEditing textField: TextField)
    @objc optional func textField(didEndEditing textField: TextField)
    @objc optional func textField(doReturnAction textField: TextField)
    @objc optional func textField(editingChanged textField: TextField, value: String?)
}

//@IBDesignable
public class TextField: UIView {
    
    // MARK: IBInspectable
    @IBInspectable public var placeHolder: String? = nil {
        didSet { txtTextField.placeholder = placeHolder }
    }
    @IBInspectable public var showLeftAction: Bool = false {
        didSet {
            leftActionView.isHidden = !showLeftAction
            textFieldLeading.constant = showLeftAction ? 7 : 16
        }
    }
    @IBInspectable public var leftActionButtonImage: UIImage? = nil {
        didSet { btnLeftAction.setImage(leftActionButtonImage, for: .normal) }
    }
    @IBInspectable public var leftActionTitle: String? = nil {
        didSet {
            btnLeftAction.titleLabel?.font = UIFont(name: Font.Regular.rawValue, size: 12)
            btnLeftAction.setTitle(leftActionTitle, for: .normal)
            btnLeftAction.setTitleColor(Color.Black.instance(), for: .normal)
        }
    }
    @IBInspectable public var showRightAction: Bool = false {
        didSet {
            rightActionView.isHidden = !showRightAction
            textFieldTailing.constant = showRightAction ? 7 : 16
        }
    }
    @IBInspectable public var rightActionButtonImage: UIImage? = nil {
        didSet { btnRightAction.setImage(rightActionButtonImage, for: .normal) }
    }
    @IBInspectable public var keyboardType: String? = nil {
        didSet { setupKeyboardType() }
    }
    
    @IBInspectable public var isSecureText: Bool = false {
        didSet { txtTextField.isSecureTextEntry = isSecureText }
    }
    
    @IBInspectable public var returnKey: String? = nil {
        didSet { setupReturnKey() }
    }
    @IBInspectable var inactiveBorderColor: UIColor? = Color.Silver.instance()
    @IBInspectable var activeBorderColor: UIColor? = Color.Silver.instance()
    @IBInspectable var errorBorderColor: UIColor? = Color.Red.instance()
    @IBInspectable var leftButtonBorder: Bool = false {
        didSet {
            btnLeftAction.layer.borderWidth =  leftButtonBorder ? 1 : 0
            btnRightAction.layer.borderColor = Color.Black.instance().cgColor
//            btnRightAction.layer.cornerRadius = 4
            leftViewWidth.constant = 71
        }
    }
    @IBInspectable var leftButtonFont: UIColor? = Color.Gray.instance() {
        didSet {
            btnLeftAction.setTitleColor(Color.Gray.instance(), for: .normal)
        }
    }
    @IBInspectable var viewBackgroundColor: UIColor? = .white {
        didSet {
            holderView.backgroundColor = viewBackgroundColor
            textFieldView.backgroundColor = viewBackgroundColor
        }
    }
    @IBInspectable var isEnabled: Bool = true {
        didSet {
            txtTextField.isUserInteractionEnabled = isEnabled
            //            viewBackgroundColor = isEnabled ? viewBackgroundColor : .lightGray
            btnRightAction.isUserInteractionEnabled = isEnabled
            btnLeftAction.isUserInteractionEnabled = isEnabled
        }
    }
    @IBInspectable public var maxLength: Int = 0
    @IBInspectable var isAllowSpecialCharacters: Bool = false
    @IBInspectable var isAllowSpace: Bool = true
    @IBInspectable var isForeceLowercase: Bool = false
    @IBInspectable var isForeceUppercase: Bool = false {
        didSet {
            if isForeceUppercase { txtTextField.autocapitalizationType = .allCharacters }
        }
    }
    @IBInspectable var textColor: UIColor = Color.Black.instance() {
        didSet { txtTextField.textColor = textColor }
    }
    @IBInspectable var placeHolderTextColor: UIColor = Color.Silver.instance() {
        didSet {
//            txtTextField.attributedPlaceholder = NSAttributedString(
//                string: placeHolder ?? "",
//                attributes: [NSAttributedString.Key.foregroundColor: placeHolderTextColor]
//            )
        }
    }
    
    @IBInspectable var cardTextField:Bool = false
    var cardNumberHash:String = ""
    
    // MARK: IBOutlet
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var txtTextField: UITextField!
    @IBOutlet weak var textFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var textFieldTailing: NSLayoutConstraint!
    
    // Right Action
    @IBOutlet weak var rightActionView: UIView!
    @IBOutlet weak var btnRightAction: UIButton!
    
    // Left Action
    @IBOutlet weak var leftViewWidth: NSLayoutConstraint!
    @IBOutlet weak var leftActionView: UIView!
    @IBOutlet weak var btnLeftAction: UIButton!
    @IBOutlet weak var btnLeftActionBottom: NSLayoutConstraint!
    
    // MARK: Variable
    public var iconClear = UIImage(named: "iconcross")
    public weak var delegate: TextFieldDelegate?
    public var isValid: Bool = true
    public var isUseDefaultRightAction = false
    public var text: String? {
        get {
            if keyboardType == "phone" {
                return txtTextField.text?.removeAllSpaces()
            }
        
            return txtTextField.text
        } set {
            if keyboardType == "phone" {
                setTextFieldForPhone(newString: newValue ?? "", isBackSpace: false)
            } else {
                txtTextField.text = newValue
            }
        }
    }
    public var cardNumber: String?
    public var onTappedAction: (() -> Void)?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    public func addTarget(_ target: Any?, action: Selector) {
        txtTextField.isUserInteractionEnabled = false
        btnRightAction.isUserInteractionEnabled = false
        let gesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(gesture)
    }
    
    fileprivate func setupView() {
        guard let textField = loadViewFromNib() else { return }
        textField.frame = bounds
        textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundColor = .clear
//        holderView.layer.cornerRadius = 4
        holderView.layer.borderWidth = 1
        holderView.layer.borderColor = inactiveBorderColor?.cgColor
        holderView.backgroundColor = viewBackgroundColor
        textFieldView.backgroundColor = viewBackgroundColor
        
        txtTextField.delegate = self
        txtTextField.autocorrectionType = .no
        txtTextField.placeholder = placeHolder
        txtTextField.textColor = textColor
        txtTextField.font = Font.MMRegular.of(size: 13)
        txtTextField.tintColor = Color.RedDark.instance()
//        txtTextField.attributedPlaceholder = NSAttributedString(
//            string: placeHolder ?? "",
//            attributes: [NSAttributedString.Key.foregroundColor: placeHolderTextColor]
//        )
        txtTextField.addTarget(self, action: #selector(textEditingChanged), for: .editingChanged)
        
        if !showLeftAction { textFieldLeading.constant = 16 }
        if !showRightAction { textFieldTailing.constant = 16 }
        
        btnRightAction.setImage(rightActionButtonImage, for: .normal)
        btnLeftAction.setTitle(leftActionTitle, for: .normal)
        btnLeftAction.titleLabel?.font = UIFont(name: Font.Bold.rawValue, size: 12)
        btnLeftAction.setTitle(leftActionTitle, for: .normal)
        btnLeftAction.setTitleColor(Color.Black.instance(), for: .normal)
        
        setupKeyboardType()
        setupReturnKey()
        txtTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction))
        btnRightAction.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        addSubview(textField)
    }
    
    fileprivate func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    public func disable() {
        rightActionButtonImage = nil
        self.isUserInteractionEnabled = false
        viewBackgroundColor = Color.Gray.instance()
    }
    
    public func removeDoneButtonOnToolbar() {
        if let inputView = txtTextField.inputAccessoryView as? IQToolbar {
            inputView.doneBarButton.tintColor = UIColor.clear
            inputView.doneBarButton.isEnabled = false
        }
    }
    
    fileprivate func setupKeyboardType() {
        if let keyboardType = keyboardType {
            switch keyboardType.lowercased() {
            case "email":
                txtTextField.keyboardType = .emailAddress
            case "number":
                txtTextField.keyboardType = .numberPad
            case "phone":
                txtTextField.keyboardType = .phonePad
            case "numberpunctuation":
                txtTextField.keyboardType = .numbersAndPunctuation
            case "ascii":
                txtTextField.keyboardType = .asciiCapable
            case "name":
                txtTextField.keyboardType = .default
                txtTextField.autocapitalizationType = .words
            case "decimalpad":
                txtTextField.keyboardType = .decimalPad
            default:
                txtTextField.keyboardType = .default
            }
        }
    }
    
    fileprivate func setupReturnKey() {
        if let returnKey = returnKey {
            switch returnKey.lowercased() {
            case "go":
                txtTextField.returnKeyType = .go
            case "next":
                txtTextField.returnKeyType = .next
            case "continue":
                txtTextField.returnKeyType = .continue
            case "search":
                txtTextField.returnKeyType = .search
            case "join":
                txtTextField.returnKeyType = .join
            case "send":
                txtTextField.returnKeyType = .send
            default:
                txtTextField.returnKeyType = .done
            }
        } else {
            txtTextField.returnKeyType = .done
        }
    }
    
    func addRightAction(_ target: Any?, action: Selector) {
        isUseDefaultRightAction = false
        btnRightAction.removeTarget(self, action: #selector(clearText), for: .touchUpInside)
        btnRightAction.addTarget(target, action: action, for: .touchUpInside)
    }
    
    @objc func clearText() {
        txtTextField.text = ""
        if let rightImage = rightActionButtonImage {
            btnRightAction.setImage(rightImage, for: .normal)
        } else {
            showRightAction = false
        }
        makeFirstResponder()
    }
    
    @objc func doneAction() { delegate?.textField?(doReturnAction: self) }
    
    @objc func textEditingChanged(textField: UITextField) {
        
        if !isUseDefaultRightAction { return }
        if let rightImage = rightActionButtonImage {
            switchRightActionImage(image: txtTextField.text?.isEmpty ?? false ? rightImage : iconClear)
        } else {
            showRightAction = !(txtTextField.text?.isEmpty ?? false)
        }
        
        if isForeceLowercase {
            self.text = self.text?.lowercased()
        }
        if isForeceUppercase {
            self.text = self.text?.uppercased()
        }
        setActiveBorder(withAnimation: false)
        delegate?.textField?(editingChanged: self, value: textField.text)
    }
    
    public func switchRightActionImage(image: UIImage?) { btnRightAction.setImage(image, for: .normal) }
    
    @objc public func makeFirstResponder() { txtTextField.becomeFirstResponder() }
    
    public func removeFirstResponder() { txtTextField.resignFirstResponder() }
    
    fileprivate func setActiveBorder(withAnimation: Bool = true) {
        if let activeBorderColor = activeBorderColor,
            let inactiveBorderColor = inactiveBorderColor {
            holderView.layer.borderWidth = 1
            if !withAnimation {
                holderView.layer.borderColor = activeBorderColor.cgColor
                return
            }
            let color = CABasicAnimation(keyPath: "borderColor")
            color.fromValue = inactiveBorderColor.cgColor
            color.toValue = activeBorderColor.cgColor
            color.duration = 0.3
            color.repeatCount = 1
            holderView.layer.borderColor = activeBorderColor.cgColor
            holderView.layer.add(color, forKey: "borderColor")
        }
    }
    
    public func setInactiveBorder(withAnimation: Bool = true) {
        if let activeBorderColor = activeBorderColor,
            let inactiveBorderColor = inactiveBorderColor {
            holderView.layer.borderWidth = 1
            if !withAnimation {
                holderView.layer.borderColor = inactiveBorderColor.cgColor
                return
            }
            let color = CABasicAnimation(keyPath: "borderColor")
            color.fromValue = activeBorderColor.cgColor
            color.toValue = inactiveBorderColor.cgColor
            color.duration = 0.3
            color.repeatCount = 1
            holderView.layer.borderColor = inactiveBorderColor.cgColor
            holderView.layer.add(color, forKey: "borderColor")
        }
    }
    
    public func setErrorBorder() {
        if let activeBorderColor = activeBorderColor,
            let errorBorderColor = errorBorderColor {
            holderView.layer.borderWidth = 1
            let color = CABasicAnimation(keyPath: "borderColor")
            color.fromValue = activeBorderColor.cgColor
            color.toValue = errorBorderColor.cgColor
            color.duration = 0.3
            color.repeatCount = 1
            holderView.layer.borderColor = errorBorderColor.cgColor
            holderView.layer.add(color, forKey: "borderColor")
        }
    }
}

extension TextField: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        delegate?.textField?(editingChanged: self, value: textView.text)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        setActiveBorder()
        onTappedAction?()
        delegate?.textField?(didBeginEditing: self)
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.textField?(shouldBeginEditing: self)
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textField?(didEndEditing: self)
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        setInactiveBorder()
        return true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if maxLength == 0 { return true }
        let currentString: NSString = textView.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
    }
}

extension TextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setActiveBorder()
        onTappedAction?()
        delegate?.textField?(didBeginEditing: self)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textField?(shouldBeginEditing: self)
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textField?(didEndEditing: self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        setInactiveBorder()
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if IQKeyboardManager.shared.canGoNext {
            return IQKeyboardManager.shared.goNext()
        } else {
            delegate?.textField?(doReturnAction: self)
            return endEditing(true)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !isAllowSpace && string == " " { return false }
        if !isAllowSpecialCharacters && string.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")) != nil {
            return false
        }
        if string.containsEmoji { return false }
        //extra check for emoji, was handled with "ascii" on top
        if (textField.textInputMode?.primaryLanguage == "emoji") || textField.textInputMode?.primaryLanguage == nil { return false }
        
        if keyboardType == "phone" {

            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            if maxLength != 0 && newString.count > maxLength { return false }

            let char = string.cString(using: String.Encoding.utf8)!
            self.setTextFieldForPhone(newString: newString, isBackSpace: strcmp(char, "\\b") == -92)
            
            return false
        }
        
        if cardTextField {
            
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            if maxLength != 0 && newString.count > maxLength { return false }

            let char = string.cString(using: String.Encoding.utf8)!
            self.setTextFieldForCard(newString: newString, isBackSpace: strcmp(char, "\\b") == -92)
            
            return false
        }
        
        if maxLength == 0 { return true }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func setTextFieldForPhone(newString: String, isBackSpace: Bool, range: NSRange? = nil, selectedRange: UITextRange? = nil) {
        
        var cursorOffset = 0
        
        if isBackSpace {
            cursorOffset = -1
            txtTextField.text = newString.count <= 5 ? newString.removedSpace : newString
        } else {
            var newText = newString.removedSpace
            if newText.count >= 4 {
                newText.insert(" ", at: newText.index(newText.startIndex, offsetBy: 4))
                cursorOffset = range?.location == 3 ? 2 : 1
                txtTextField.text = newText
            } else {
                cursorOffset = 1
                txtTextField.text = newText
            }
        }
        
        if let sRange = selectedRange {
            if let cursorPos = txtTextField.position(from: sRange.start, offset: cursorOffset) {
                txtTextField.selectedTextRange = txtTextField.textRange(from: cursorPos, to: cursorPos)
            }
        }
    }
    
    func setTextFieldForCard(newString: String, isBackSpace: Bool, range: NSRange? = nil, selectedRange: UITextRange? = nil) {
        
        var cursorOffset = 0
        if isBackSpace {
            cursorOffset = -1
            txtTextField.text = newString.count <= 5 ? newString.removedSpace : newString
        } else {
            var newText = newString.removedSpace
            if newText.count >= 4 {
                newText.insert(" ", at: newText.index(newText.startIndex, offsetBy: 4))
                cursorOffset = range?.location == 3 ? 2 : 1
                let data = newText.chunkFormatted(withChunkSize: 4, withSeparator: " ")
                cardNumber = data.1
                txtTextField.text = data.0
            } else {
                cursorOffset = 1
                txtTextField.text = newText
            }
        }
        
        if let sRange = selectedRange {
            if let cursorPos = txtTextField.position(from: sRange.start, offset: cursorOffset) {
                txtTextField.selectedTextRange = txtTextField.textRange(from: cursorPos, to: cursorPos)
            }
        }
        
        var strings = txtTextField.text.orEmpty.map { String($0) }
        if strings.count <= 14 {

            strings = strings.map { !($0 == " ") ? "*" : $0}

        }
        print(strings.joined())
        txtTextField.text = strings.joined()

    }

}
