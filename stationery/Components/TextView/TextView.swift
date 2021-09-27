//
//  TextView.swift
//  FWD
//
//  Created by Codigo NOL on 25/05/2020.
//  Copyright © 2020 codigo. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift

@objc public protocol TextViewDelegate {
    @objc optional func textView(didBeginEditing textView: TextView)
    @objc optional func textView(didEndEditing textView: TextView)
    @objc optional func textView(doReturnAction textView: TextView)
    @objc optional func textView(editingChanged textView: TextView, value: String?)
}

public class TextView: UIView {
    
    // MARK: IBInspectable
    @IBInspectable public var placeHolder: String? = nil {
        didSet {
            lblPlaceHoler.text = placeHolder
        }
    }
    
    @IBInspectable public var keyboardType: String? = nil {
        didSet {
            setupKeyboardType()
        }
    }
    @IBInspectable public var returnKey: String? = nil {
        didSet {
            setupReturnKey()
        }
    }
    
    @IBInspectable var inactiveBorderColor: UIColor? = Color.Silver.instance()
    @IBInspectable var activeBorderColor: UIColor? = Color.Silver.instance()
    @IBInspectable var errorBorderColor: UIColor? = Color.Red.instance()
    @IBInspectable var viewBackgroundColor: UIColor? = .white {
        didSet {
            holderView.backgroundColor = viewBackgroundColor
            textFieldView.backgroundColor = viewBackgroundColor
        }
    }
    @IBInspectable var isEnabled: Bool = true {
        didSet {
            txtTextView.isUserInteractionEnabled = isEnabled
            //            viewBackgroundColor = isEnabled ? viewBackgroundColor : .lightGray
        }
    }
    @IBInspectable public var maxLength: Int = 0 {
        didSet {
            lblCount.text = maxLength == 0 ? "" : "\(txtTextView.text.count)/\(maxLength)"
        }
    }
    @IBInspectable var isAllowSpecialCharacters: Bool = false
    @IBInspectable var isAllowSpace: Bool = true
    @IBInspectable var isForeceLowercase: Bool = false
    @IBInspectable var isForeceUppercase: Bool = false {
        didSet {
            if isForeceUppercase {
                txtTextView.autocapitalizationType = .allCharacters
            }
        }
    }
    @IBInspectable var textColor: UIColor = .black {
        didSet {
            txtTextView.textColor = textColor
        }
    }
    @IBInspectable var placeHolderTextColor: UIColor = UIColor(hexString: "#C7C7CD") ?? .gray {
        didSet {
            lblPlaceHoler.textColor = placeHolderTextColor
        }
    }
    @IBInspectable var countTextColor: UIColor = .darkGray {
           didSet {
               lblCount.textColor = countTextColor
           }
       }
    
    // MARK: IBOutlet
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var txtTextView: UITextView!
    @IBOutlet weak var lblPlaceHoler: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    // MARK: Variable
    public weak var delegate: TextViewDelegate?
    public var isValid: Bool = true
    public var isSecureText: Bool = true
    public var text: String? {
        get {
            return txtTextView.text
        } set {
            txtTextView.text = newValue ?? ""
        }
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
        txtTextView.isUserInteractionEnabled = false
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
        
        txtTextView.delegate = self
        txtTextView.autocorrectionType = .no
        txtTextView.textColor = textColor
        txtTextView.font = Font.Regular.of(size: 13)
        txtTextView.tintColor = Color.RedDark.instance()
        txtTextView.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction))
        
        lblPlaceHoler.text = placeHolder
        lblPlaceHoler.textColor = placeHolderTextColor
        lblPlaceHoler.font = Font.Regular.of(size: 13)
        
        lblCount.text = maxLength == 0 ? "" : "0/\(maxLength)"
        lblCount.textColor = countTextColor
        lblCount.font = Font.Regular.of(size: 11)
        
        setupKeyboardType()
        setupReturnKey()
        addSubview(textField)
    }
    
    fileprivate func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    public func disable() {
        self.isUserInteractionEnabled = false
        viewBackgroundColor = Color.Silver.instance()
    }
    
    public func removeDoneButtonOnToolbar() {
        if let inputView = txtTextView.inputAccessoryView as? IQToolbar {
            inputView.doneBarButton.tintColor = UIColor.clear
            inputView.doneBarButton.isEnabled = false
        }
    }
    
    fileprivate func setupKeyboardType() {
        if let keyboardType = keyboardType {
            switch keyboardType.lowercased() {
            case "email":
                txtTextView.keyboardType = .emailAddress
            case "number":
                txtTextView.keyboardType = .numberPad
            case "phone":
                txtTextView.keyboardType = .phonePad
            case "numberpunctuation":
                txtTextView.keyboardType = .numbersAndPunctuation
            case "ascii":
                txtTextView.keyboardType = .asciiCapable
            case "name":
                txtTextView.keyboardType = .default
                txtTextView.autocapitalizationType = .words
            default:
                txtTextView.keyboardType = .default
            }
        }
    }
    
    fileprivate func setupReturnKey() {
        if let returnKey = returnKey {
            switch returnKey.lowercased() {
            case "go":
                txtTextView.returnKeyType = .go
            case "next":
                txtTextView.returnKeyType = .next
            case "continue":
                txtTextView.returnKeyType = .continue
            case "search":
                txtTextView.returnKeyType = .search
            case "join":
                txtTextView.returnKeyType = .join
            case "send":
                txtTextView.returnKeyType = .send
            default:
                txtTextView.returnKeyType = .done
            }
        } else {
            txtTextView.returnKeyType = .done
        }
    }
    
    @objc func doneAction() {
        delegate?.textView?(doReturnAction: self)
    }
    
    @objc public func makeFirstResponder() {
        DispatchQueue.main.async {
            self.txtTextView.becomeFirstResponder()
        }
    }
    
    public func removeFirstResponder() {
        txtTextView.resignFirstResponder()
    }
    
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
    
    public func getText() -> String {
        return txtTextView.text
    }
}

extension TextView: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        delegate?.textView?(editingChanged: self, value: txtTextView.text)
        lblPlaceHoler.isHidden = !txtTextView.text.isEmpty
        lblCount.text = maxLength == 0 ? "" : "\(txtTextView.text.count)/\(maxLength)"
        editingChanged(txtTextView.text)

    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textView?(didBeginEditing: self)
        setActiveBorder()
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        setInactiveBorder()
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textView?(didEndEditing: self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if maxLength == 0 {
            return true
        }
        let currentString: NSString = textView.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
    }
}
