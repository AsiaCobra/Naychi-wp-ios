//
//  TextViewWithTitle.swift
//  FWD
//
//  Created by Codigo NOL on 26/08/2020.
//  Copyright © 2020 codigo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@objc public protocol TextViewWithTitleDelegate {
    @objc optional func textViewWithTitle(didBeginEditing textView: TextViewWithTitle)
    @objc optional func textViewWithTitle(didEndEditing textView: TextViewWithTitle)
    @objc optional func textViewWithTitle(doReturnAction textView: TextViewWithTitle)
    @objc optional func textViewWithTitle(editingChanged textView: TextViewWithTitle, value: String?)
}

public class TextViewWithTitle: UIView {
    
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
    
    // MARK: IBInspectable
    @IBInspectable public var placeHolder: String? = nil {
        didSet { textView.lblPlaceHoler.text = placeHolder }
    }
    
    @IBInspectable public var keyboardType: String? = nil {
        didSet { textView.keyboardType = keyboardType }
    }
    @IBInspectable public var returnKey: String? = nil {
        didSet { textView.returnKey = returnKey }
    }
    
    @IBInspectable var inactiveBorderColor: UIColor? = Color.Silver.instance() {
        didSet { textView.inactiveBorderColor = inactiveBorderColor }
    }
    
    @IBInspectable var activeBorderColor: UIColor? = Color.Silver.instance() {
        didSet { textView.activeBorderColor = activeBorderColor }
    }
    
    @IBInspectable var errorBorderColor: UIColor? = Color.Red.instance() {
        didSet { textView.errorBorderColor = errorBorderColor }
    }
    @IBInspectable var viewBackgroundColor: UIColor? = .white {
        didSet { textView.viewBackgroundColor = viewBackgroundColor }
    }
    @IBInspectable var isEnabled: Bool = true {
        didSet { textView.isEnabled = isEnabled }
    }
    @IBInspectable public var maxLength: Int = 0 {
        didSet { textView.maxLength = maxLength }
    }
    @IBInspectable var isAllowSpecialCharacters: Bool = false {
        didSet { textView.isAllowSpecialCharacters = isAllowSpecialCharacters }
    }
    @IBInspectable var isAllowSpace: Bool = true {
        didSet { textView.isAllowSpace = isAllowSpace }
    }
    @IBInspectable var isForeceLowercase: Bool = false {
        didSet { textView.isForeceLowercase = isForeceLowercase }
    }
    @IBInspectable var isForeceUppercase: Bool = false {
        didSet { textView.isForeceUppercase = isForeceUppercase }
    }
    @IBInspectable var textColor: UIColor = Color.Black.instance() {
        didSet { textView.textColor = textColor }
    }
    
    @IBInspectable var placeHolderTextColor: UIColor = Color.Gray.instance() {
        didSet { textView.placeHolderTextColor = placeHolderTextColor }
    }
    
    @IBInspectable var countTextColor: UIColor = Color.DarkGray.instance() {
        didSet { textView.countTextColor = countTextColor }
    }
    
    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textView: TextView!
    
    // MARK: Variable
    public weak var delegate: TextViewWithTitleDelegate?
    private var textFont = Font.Regular.of(size: 14)
    private var descFont = Font.Regular.of(size: 12)
    
    public var text: String? {
        get { return textView.text }
        set { textView.text = newValue }
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
        textView.addTarget(target, action: action)
    }
    
    fileprivate func setupView() {
        guard let textField = loadViewFromNib() else { return }
        textField.frame = bounds
        textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundColor = .clear
        
        textView.placeHolder = placeHolder
        textView.keyboardType = keyboardType
        textView.returnKey = returnKey
        textView.inactiveBorderColor = inactiveBorderColor
        textView.activeBorderColor = activeBorderColor
        textView.errorBorderColor = errorBorderColor
        textView.viewBackgroundColor = viewBackgroundColor
        textView.isEnabled = isEnabled
        textView.maxLength = maxLength
        textView.isAllowSpecialCharacters = isAllowSpecialCharacters
        textView.isAllowSpace = isAllowSpace
        textView.isForeceLowercase = isForeceLowercase
        textView.isForeceUppercase = isForeceUppercase
        textView.textColor = textColor
        textView.placeHolderTextColor = placeHolderTextColor
        textView.countTextColor = countTextColor
        textView.delegate = self
        
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
    
    public func disable() {
        textView.disable()
    }
    
    public func removeDoneButtonOnToolbar() {
        textView.removeDoneButtonOnToolbar()
    }
    
    public func removeFirstResponder() {
        textView.removeFirstResponder()
    }
    
    public func setInactiveBorder(withAnimation: Bool = true) {
        textView.setInactiveBorder(withAnimation: withAnimation)
    }
    
    public func setError(_ error: String? = nil) {
        if let e = error {
            lblTitle.text = e
        } else {
            lblTitle.text = titleError == nil ? title : titleError
        }
        lblTitle.textColor = errorColor
        textView.setErrorBorder()
        CustomAnimation.shake(view: self, direction: .horizontal, duration: 0.8, animationType: .easeOut, density: .HARD)
    }
}

extension TextViewWithTitle: TextViewDelegate {
    public func textView(didBeginEditing textView: TextView) {
        setTitle()
        delegate?.textViewWithTitle?(didBeginEditing: self)
    }
    public func textView(didEndEditing textView: TextView) {
        delegate?.textViewWithTitle?(didEndEditing: self)
    }
    public func textView(doReturnAction textView: TextView) {
        delegate?.textViewWithTitle?(doReturnAction: self)
    }
    public func textView(editingChanged textView: TextView, value: String?) {
        delegate?.textViewWithTitle?(editingChanged: self, value: value)
        editingChanged(value.orEmpty)
    }
}
