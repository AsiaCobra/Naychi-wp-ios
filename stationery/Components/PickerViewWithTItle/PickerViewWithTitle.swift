//
//  PickerViewWithTitle.swift
//  FWD
//
//  Created by Codigo NOL on 10/08/2020.
//  Copyright © 2020 codigo. All rights reserved.
//

import UIKit

@objc public protocol PickerViewWithTitleProtocol: AnyObject {
    func pickerViewWithTitle(onSelected selectedString: String, picker: PickerViewWithTitle)
    @objc optional func pickerViewWithTitle(editingDone selectedString: String?, picker: PickerViewWithTitle)
}

public class PickerViewWithTitle: UIView {
    
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
    @IBInspectable var descColor: UIColor = Color.Black.instance() {
        didSet { setTitle() }
    }
    @IBInspectable var errorColor: UIColor? = .red
    
    @IBInspectable public var textFieldPlaceHolder: String? = nil {
        didSet { pickerView.textFieldPlaceHolder = textFieldPlaceHolder }
    }
    @IBInspectable public var rightActionButtonImage: UIImage? = nil {
        didSet { pickerView.rightActionButtonImage = rightActionButtonImage }
    }
    @IBInspectable var inactiveBorderColor: UIColor? = Color.Black.instance() {
        didSet { pickerView.inactiveBorderColor = inactiveBorderColor }
    }
    @IBInspectable var activeBorderColor: UIColor? = Color.Black.instance() {
        didSet { pickerView.activeBorderColor = activeBorderColor }
    }
    @IBInspectable var errorBorderColor: UIColor? = .red {
        didSet { pickerView.errorBorderColor = errorBorderColor }
    }
    
    @IBInspectable var viewBackgroundColor: UIColor? = .white {
        didSet { pickerView.viewBackgroundColor = viewBackgroundColor }
    }
    @IBInspectable var isEnabled: Bool = true {
        didSet { pickerView.isEnabled = isEnabled }
    }
    @IBInspectable var textColor: UIColor = .black {
        didSet { pickerView.textColor = textColor }
    }
    @IBInspectable var placeHolderTextColor: UIColor = .lightGray {
        didSet { pickerView.placeHolderTextColor = placeHolderTextColor }
    }
    
    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var pickerView: PickerView!
    private var textFont = Font.Regular.of(size: 13)
    private var descFont = Font.Regular.of(size: 12)
    
    // MARK: Variable
    public var text: String? {
        get {
            return pickerView.txtTextField.text
        } set {
            pickerView.txtTextField.text = newValue
        }
    }
    weak var delegate: PickerViewWithTitleProtocol?
    
    var didSelect: (Int, String?) -> Void = { _, _ in }
    
//    var field: Field?
    
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
        pickerView.addTarget(target, action: action)
    }
    
    fileprivate func setupView() {
        guard let textField = loadViewFromNib() else { return }
        textField.frame = bounds
        textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundColor = .clear
        
        pickerView.delegate = self
        
        lblTitle.fontMm = "regular"
        lblTitle.fontEng = "regular"
        lblTitle.fontSizeMm = 13
        lblTitle.fontSizeEng = 13
        
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
        pickerView.disable()
    }
    
    public func setDate(minDate: Date?, maxDate: Date?, dateFormat: String = "dd-MM-yyyy") {
        pickerView.setDate(minDate: minDate, maxDate: maxDate, dateFormat: dateFormat)
    }
    
    public func setTime(timeFormat: String = "hh:mm a") {
        pickerView.setTime(timeFormat: timeFormat)
    }
    
    public func setData(items: [(id: String?, value: String?)], selectedIndex: Int? = nil) {
        pickerView.setData(items: items, selectedIndex: selectedIndex)
    }
    
    public func setSelected(index: Int, callDelegate: Bool = false) {
        pickerView.setSelected(index: index, callDelegate: callDelegate)
    }
    
    public func reset() {
        pickerView.reset()
    }
    
    @objc public func makeFirstResponder() {
        pickerView.makeFirstResponder()
    }
    
    public func resignFirstResponder() {
        pickerView.resignFirstsResponder()
    }
    
    public func setError(_ error: String? = nil) {
        if let e = error {
            lblTitle.text = e
        } else {
            lblTitle.text = titleError == nil ? title : titleError
        }
        lblTitle.textColor = errorColor
        pickerView.setErrorBorder()
        CustomAnimation.shake(view: self, direction: .horizontal, duration: 0.8, animationType: .easeOut, density: .HARD)
    }
    
    public func getSelectedId() -> String? {
        return pickerView.getSelectedId()
    }
    
    public func getSelectedValue(ignoreValue: String? = nil) -> String? {
        return pickerView.getSelectedValue(ignoreValue: ignoreValue)
    }
    
    public func setDateValue(_ newDate: Date) {
        return pickerView.setDateValue(newDate)
    }
    
    public func getDateValue(_ withFormat: String) -> String? {
        return pickerView.getDateValue(withFormat)
    }
    
    public func getDate() -> Date? {
        return pickerView.getDate()
    }
    
    public func getSelectedIndex(ignoreIndex: Int? = nil) -> Int? {
        return pickerView.getSelectedIndex(ignoreIndex: ignoreIndex)
    }
    
    public func getTextField() -> UITextField {
        pickerView.txtTextField
    }
    
    public func getPickerType() -> PickerType {
        return pickerView.pickerType
    }
    
    public func setValue(_ value: String) {
        pickerView.setValue(value)
    }
}

extension PickerViewWithTitle: PickerViewProtocol {
    public func pickerView(onSelected selectedString: String, picker: PickerView) {
        setTitle()
        didSelect(
            picker.selectedIndex.orElse(0),
            picker.getDateValue("yyyy-MM-dd") ?? selectedString
        )
        delegate?.pickerViewWithTitle(onSelected: selectedString, picker: self)
        
    }
    public func pickerView(editingDone selectedString: String?, picker: PickerView) {
        setTitle()
        delegate?.pickerViewWithTitle?(editingDone: selectedString, picker: self)
        didSelect(
            picker.selectedIndex.orElse(0),
            picker.getDateValue("yyyy-MM-dd") ?? selectedString
        )
    }
}
