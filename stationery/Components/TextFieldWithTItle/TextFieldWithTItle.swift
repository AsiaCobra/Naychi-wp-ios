//
//  TextFieldWithTItle.swift
//  FWD
//
//  Created by Codigo NOL on 28/07/2020.
//  Copyright © 2020 codigo. All rights reserved.
//

import UIKit

@objc public protocol TextFieldWithTitleDelegate {
    @objc optional func textFieldWithTitle(didBeginEditing textField: TextFieldWithTitle)
    @objc optional func textFieldWithTitle(shouldBeginEditing textField: TextFieldWithTitle)
    @objc optional func textFieldWithTitle(didEndEditing textField: TextFieldWithTitle)
    @objc optional func textFieldWithTitle(doReturnAction textField: TextFieldWithTitle)
    @objc optional func textFieldWithTitle(editingChanged textField: TextFieldWithTitle, value: String?)
}

//@IBDesignable
public class TextFieldWithTitle: UIView {
    
    // MARK: IBInspectable
    
    @IBInspectable public var title: String? = nil {
        didSet { setTitle() }
    }
    
    @IBInspectable public var desc: String? = nil {
        didSet { setTitle() }
    }
    @IBInspectable public var titleError: String?
    @IBInspectable var titleColor: UIColor = Color.Black.instance() {
        didSet { setTitle() }
    }
    @IBInspectable var descColor: UIColor = Color.Gray.instance() {
        didSet { setTitle() }
    }
    @IBInspectable var errorColor: UIColor? = .red
    
    @IBInspectable public var placeHolder: String? = nil {
        didSet { txtTextField.placeHolder = placeHolder }
    }
    @IBInspectable public var showLeftAction: Bool = false {
        didSet { txtTextField.showLeftAction = showLeftAction }
    }
    @IBInspectable public var leftActionButtonImage: UIImage? = nil {
        didSet { txtTextField.leftActionButtonImage = leftActionButtonImage }
    }
    @IBInspectable public var leftActionTitle: String? = nil {
        didSet { txtTextField.leftActionTitle = leftActionTitle }
    }
    @IBInspectable public var showRightAction: Bool = false {
        didSet { txtTextField.showRightAction = showRightAction }
    }
    @IBInspectable public var rightActionButtonImage: UIImage? = nil {
        didSet { txtTextField.rightActionButtonImage = rightActionButtonImage }
    }
    @IBInspectable public var keyboardType: String? = nil {
        didSet { txtTextField.keyboardType = keyboardType }
    }
    @IBInspectable public var isSecureText: Bool = false {
        didSet { txtTextField.isSecureText = isSecureText }
    }
    @IBInspectable public var returnKey: String? = nil {
        didSet { txtTextField.returnKey = returnKey }
    }
    @IBInspectable var inactiveBorderColor: UIColor? = Color.Black.instance() {
        didSet { txtTextField.inactiveBorderColor = inactiveBorderColor }
    }
    @IBInspectable var activeBorderColor: UIColor? = Color.Black.instance() {
        didSet { txtTextField.activeBorderColor = activeBorderColor }
    }
    @IBInspectable var errorBorderColor: UIColor? = .red {
        didSet { txtTextField.errorBorderColor = errorBorderColor }
    }
    @IBInspectable var leftButtonBorder: Bool = false {
        didSet {
            txtTextField.leftButtonBorder = leftButtonBorder
        }
    }
    @IBInspectable var leftButtonFontColor: UIColor? = Color.Gray.instance() {
        didSet {
            txtTextField.leftButtonFont = leftButtonFontColor
        }
    }
    @IBInspectable var viewBackgroundColor: UIColor? = .white {
        didSet { txtTextField.viewBackgroundColor = viewBackgroundColor }
    }
    @IBInspectable var isEnabled: Bool = true {
        didSet { txtTextField.isEnabled = isEnabled }
    }
    @IBInspectable public var maxLength: Int = 0 {
        didSet { txtTextField.maxLength = maxLength }
    }
    @IBInspectable var isAllowSpecialCharacters: Bool = false {
        didSet { txtTextField.isAllowSpecialCharacters = isAllowSpecialCharacters }
    }
    @IBInspectable var isAllowSpace: Bool = true {
        didSet { txtTextField.isAllowSpace = isAllowSpace }
    }
    @IBInspectable var isForeceLowercase: Bool = false {
        didSet { txtTextField.isForeceLowercase = isForeceLowercase }
    }
    @IBInspectable var isForeceUppercase: Bool = false {
        didSet { txtTextField.isForeceUppercase = isForeceUppercase }
    }
    @IBInspectable var textColor: UIColor = Color.Black.instance() {
        didSet { txtTextField.textColor = textColor }
    }
    @IBInspectable var placeHolderTextColor: UIColor = Color.Gray.instance() {
        didSet { txtTextField.placeHolderTextColor = placeHolderTextColor }
    }
    
    @IBInspectable var cardMode: Bool = false {
        didSet { txtTextField.cardTextField = true }
    }
    
    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var txtTextField: TextField!
    
    public weak var delegate: TextFieldWithTitleDelegate?
    private var textFont = Font.Regular.of(size: 13)
    private var descFont = Font.Regular.of(size: 12)
    
    public var text: String? {
        get {
            if keyboardType == "phone" {
                return txtTextField.text?.removeAllSpaces()
            }
            return txtTextField.text
        }
        set { txtTextField.text = newValue }
    }
    public var onTappedAction: (() -> Void)? {
        didSet { txtTextField.onTappedAction = onTappedAction }
    }
    
    var editingChanged: (String?) -> Void = { _ in }
    
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
        txtTextField.addTarget(target, action: action)
    }
    
    fileprivate func setupView() {
        guard let textField = loadViewFromNib() else { return }
        textField.frame = bounds
        textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        
        lblTitle.fontMm = "regular"
        lblTitle.fontEng = "regular"
        lblTitle.fontSizeMm = 13
        lblTitle.fontSizeEng = 13
        
        txtTextField.placeHolder = placeHolder
        txtTextField.showLeftAction = showLeftAction
        txtTextField.leftActionButtonImage = leftActionButtonImage
        txtTextField.showRightAction = showRightAction
        txtTextField.rightActionButtonImage = rightActionButtonImage
        txtTextField.keyboardType = keyboardType
        txtTextField.isSecureText = isSecureText
        txtTextField.returnKey = returnKey
        txtTextField.inactiveBorderColor = inactiveBorderColor
        txtTextField.activeBorderColor = activeBorderColor
        txtTextField.errorBorderColor = errorBorderColor
        txtTextField.viewBackgroundColor = viewBackgroundColor
        txtTextField.isEnabled = isEnabled
        txtTextField.maxLength = maxLength
        txtTextField.isAllowSpecialCharacters = isAllowSpecialCharacters
        txtTextField.isAllowSpace = isAllowSpace
        txtTextField.isForeceLowercase = isForeceLowercase
        txtTextField.isForeceUppercase = isForeceUppercase
        txtTextField.textColor = textColor
        txtTextField.placeHolderTextColor = placeHolderTextColor
        
        txtTextField.delegate = self
        
        setTitle()
        
        addSubview(textField)
    }
    
    fileprivate func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    fileprivate func setTitle() {
        
        guard let des = desc else {
            lblTitle.text = title
            lblTitle.textColor = titleColor
            return
        }
        
        var titleText = des
        if let t = title, !t.isEmpty { titleText = "\(t) \(des)" }
        lblTitle.text = ""
        lblTitle.highlightPartOf(titleText, normalColor: titleColor, normalFont: textFont,
                                 highlightText: [des], highlightColor: descColor, highlightFont: descFont)
    }
    
    func setTitleLanguage(_ mm: String, _ eng: String) {
        lblTitle.textMyanmar = mm
        lblTitle.textEnglish = eng
        lblTitle.changeLanguage(AppUtil.shared.currentLanguage)
        if let title = lblTitle.text, let des = desc {
            lblTitle.highlightPartOf("\(title) \(des)", normalColor: titleColor, normalFont: lblTitle.font,
                                     highlightText: [des], highlightColor: descColor, highlightFont: lblTitle.font)
        }
    }
    
    public func disable() {
        txtTextField.disable()
    }
    
    public func getTextField() -> UITextField {
        return txtTextField.txtTextField
    }
    
    public func removeDoneButtonOnToolbar() {
        txtTextField.removeDoneButtonOnToolbar()
    }
    
    func addRightAction(_ target: Any?, action: Selector) {
        txtTextField.addRightAction(target, action: action)
    }
    
    @objc public func makeFirstResponder() {
        txtTextField.makeFirstResponder()
    }
    
    public func removeFirstResponder() {
        txtTextField.removeFirstResponder()
    }
    
    public func setInactiveBorder(withAnimation: Bool = true) {
        txtTextField.setInactiveBorder(withAnimation: withAnimation)
    }
    
    public func setError(_ error: String? = nil) {
        if let e = error {
            lblTitle.text = e
        } else {
            lblTitle.text = titleError == nil ? title : titleError
        }
        lblTitle.textColor = errorColor
        txtTextField.setErrorBorder()
        CustomAnimation.shake(view: self, direction: .horizontal, duration: 0.8, animationType: .easeOut, density: .HARD)
    }
    
    public func resetError() {
        setTitle()
        txtTextField.valid()
    }
    
}

extension TextFieldWithTitle: TextFieldDelegate {
    
    public func textField(didBeginEditing textField: TextField) {
        setTitle()
        delegate?.textFieldWithTitle?(didBeginEditing: self)
    }
    
    public func textField(shouldBeginEditing textField: TextField) {
        delegate?.textFieldWithTitle?(shouldBeginEditing: self)
    }
    
    public func textField(didEndEditing textField: TextField) {
        delegate?.textFieldWithTitle?(didEndEditing: self)
    }
    public func textField(doReturnAction textField: TextField) {
        delegate?.textFieldWithTitle?(doReturnAction: self)
    }
    public func textField(editingChanged textField: TextField, value: String?) {
        editingChanged(value)
        delegate?.textFieldWithTitle?(editingChanged: self, value: value)
    }
}

extension TextFieldWithTitle {
//    func validate() -> Bool {
//        guard let field = self.field else { return false }
//        let input = text.orEmpty
//
//        guard field.isMandatory == true else { return true }
//
//        if input.isEmpty {
//            setError(field.mandatoryErrorMessage)
//            return false
//        } else if input.length > field.length {
//            setError(field.validationErrorMessage)
//            return false
//        } else {
//            return true
//        }
//    }
    
//    func reloadInput() {
//        text = field?.fieldValue
//    }
}
