//
//  PickerView.swift
//  FWD
//
//  Created by Codigo NOL on 20/05/2020.
//  Copyright © 2020 codigo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

public enum PickerType {
    case date
    case custom
    case time
}

@objc protocol PickerViewProtocol: AnyObject {
    func pickerView(onSelected selectedString: String, picker: PickerView)
    @objc optional func pickerView(editingDone selectedString: String?, picker: PickerView)
}

public class PickerView: UIView {
    
    // MARK: IBInspectable
    @IBInspectable public var textFieldPlaceHolder: String? = nil {
        didSet {
            txtTextField.placeholder = textFieldPlaceHolder
        }
    }
    @IBInspectable public var rightActionButtonImage: UIImage? = nil {
        didSet {
            btnRightAction.setImage(rightActionButtonImage, for: .normal)
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
            txtTextField.isUserInteractionEnabled = isEnabled
            txtTextField.alpha = isEnabled ? 1 : 0.3
            viewBackgroundColor = isEnabled ? .white : Color.Gray.instance()
//            btnRightAction.tintColor = isEnabled ? Color.Black.instance() : Color.TimerGreen.instance()
            btnRightAction.alpha = isEnabled ? 1 : 0.3
            btnRightAction.isUserInteractionEnabled = isEnabled
        }
    }
    @IBInspectable var textColor: UIColor = .black {
        didSet {
            txtTextField.textColor = textColor
        }
    }
    @IBInspectable var placeHolderTextColor: UIColor = .lightGray {
        didSet {
            txtTextField.attributedPlaceholder = NSAttributedString(string: textFieldPlaceHolder ?? "",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: placeHolderTextColor])
        }
    }
    
    // MARK: IBOutlet
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var txtTextField: UITextField!
    
    // Right Action
    @IBOutlet weak var rightActionView: UIView!
    @IBOutlet weak var btnRightAction: UIButton!
    
    // MARK: Variable
    public var isValid: Bool = true
    public var text: String? {
        get {
            return txtTextField.text ?? ""
        } set {
            txtTextField.text = newValue
        }
    }
    private var picker: UIPickerView?
    private var datePicker: UIDatePicker?
    var pickerType = PickerType.custom
    var dateFormat = "dd-MM-yyyy"
    var timeFormat = "hh:mm a"
    var defaultDate: Date?
    weak var delegate: PickerViewProtocol?
    
    var items: [(id: String?, value: String?)] = []
    var selectedIndex: Int?
    var startIndex: Int?
    
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
        txtTextField.placeholder = textFieldPlaceHolder
        txtTextField.textColor = textColor
        txtTextField.font = Font.MMRegular.of(size: 13)
        txtTextField.tintColor = .clear
        txtTextField.attributedPlaceholder = NSAttributedString(string: textFieldPlaceHolder ?? "",
                                                                attributes: [NSAttributedString.Key.foregroundColor: placeHolderTextColor])
        
        btnRightAction.setImage(rightActionButtonImage, for: .normal)
        btnRightAction.addTarget(self, action: #selector(makeFirstResponder), for: .touchUpInside)
        
        addSubview(textField)
    }
    
    fileprivate func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    fileprivate func setupPicker() {
        pickerType = .custom
        picker = UIPickerView()
        txtTextField.isHidden = false
        txtTextField.inputView = picker
        picker?.delegate = self
        picker?.dataSource = self
    }
    
    fileprivate func setupDatePicker(minDate: Date?, maxDate: Date?) {
        pickerType = .date
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = maxDate
        if #available(iOS 13.4, *) {
            datePicker?.preferredDatePickerStyle = .wheels
            datePicker?.sizeToFit()
        }
        if let date = minDate {
            datePicker?.setDate(date, animated: false)
        }
        txtTextField.isHidden = false
        txtTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
    }
    
    fileprivate func setupTimePicker() {
        pickerType = .time
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        if #available(iOS 13.4, *) {
            datePicker?.preferredDatePickerStyle = .wheels
            datePicker?.sizeToFit()
        }
        txtTextField.isHidden = false
        txtTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
    }
    
    @objc private func pickerChanged() {
        txtTextField.text = datePicker?.date.toString(pickerType == .date ? dateFormat : timeFormat)
        if let text = txtTextField.text {
            delegate?.pickerView(onSelected: text, picker: self)
        }
    }
    
    public func disable() {
        rightActionButtonImage = nil
        self.isUserInteractionEnabled = false
        viewBackgroundColor = Color.Gray.instance()
    }
    
    public func setDate(minDate: Date?, maxDate: Date?, dateFormat: String = "dd-MM-yyyy") {
        self.dateFormat = dateFormat
        setupDatePicker(minDate: minDate, maxDate: maxDate)
    }
    
    public func setTime(timeFormat: String = "hh:mm a") {
        self.timeFormat = timeFormat
        setupTimePicker()
    }
    
    public func setData(items: [(id: String?, value: String?)], selectedIndex: Int? = nil) {
        setupPicker()
        self.items = items
        self.selectedIndex = selectedIndex
        startIndex = selectedIndex
        guard let index = selectedIndex else { return }
        picker?.selectRow(index, inComponent: 0, animated: true)
        setText()
        txtTextField.sendActions(for: .editingChanged)
    }
    
    public func setSelected(index: Int, callDelegate: Bool = false) {
        if index < 0 || index >= items.count { return }
        selectedIndex = index
        picker?.selectRow(index, inComponent: 0, animated: true)
        setText()
        txtTextField.sendActions(for: .editingChanged)
        if let text = getSelectedValue(), callDelegate {
            delegate?.pickerView?(editingDone: text, picker: self)
            delegate?.pickerView(onSelected: text, picker: self)
        }
    }
    
    public func reset() {
        switch pickerType {
        case .date, .time:
            if let date = defaultDate {
                setDateValue(date)
            } else {
                txtTextField.text = nil
            }
        default:
            selectedIndex = startIndex
            if let index = startIndex {
                txtTextField.text = items[index].value
                picker?.selectRow(index, inComponent: 0, animated: true)
            } else {
                txtTextField.text = nil
            }
        }        
    }
    
    private func setText() {
        guard let index = selectedIndex else { return }
        if items.isEmpty {
            txtTextField.text = nil
            return
        }
        txtTextField.text = items[index].value
        if let text = txtTextField.text {
            delegate?.pickerView(onSelected: text, picker: self)
        }
    }
    
    @objc public func makeFirstResponder() {
        txtTextField.becomeFirstResponder()
    }
    
    public func resignFirstsResponder() {
        txtTextField.resignFirstResponder()
    }
    
    fileprivate func setActiveBorder() {
        if let activeBorderColor = activeBorderColor,
            let inactiveBorderColor = inactiveBorderColor {
            holderView.layer.borderWidth = 1
            let color = CABasicAnimation(keyPath: "borderColor")
            color.fromValue = inactiveBorderColor.cgColor
            color.toValue = activeBorderColor.cgColor
            color.duration = 0.3
            color.repeatCount = 1
            holderView.layer.borderColor = activeBorderColor.cgColor
            holderView.layer.add(color, forKey: "borderColor")
        }
    }
    
    fileprivate func setInactiveBorder() {
        if let activeBorderColor = activeBorderColor,
            let inactiveBorderColor = inactiveBorderColor {
            holderView.layer.borderWidth = 1
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
        if let errorBorderColor = errorBorderColor {
            holderView.layer.borderWidth = 1
            holderView.layer.borderColor = errorBorderColor.cgColor
        }
    }
    
    public func getSelectedId() -> String? {
        guard let index = selectedIndex else { return nil }
        return items[index].id
    }
    
    public func getSelectedValue(ignoreValue: String? = nil) -> String? {
        let value: String? = txtTextField.text?.isEmpty ?? true ? nil : txtTextField.text
        if let ignore = ignoreValue, ignore == value { return nil }
        return value
    }
    
    public func setDateValue(_ newDate: Date) {
        txtTextField.text = newDate.toString(pickerType == .date ? dateFormat : timeFormat)
        defaultDate = newDate
        datePicker?.date = newDate
    }
    
    public func getDateValue(_ withFormat: String = "dd-MM-yyyy") -> String? {
        guard let value = txtTextField.text, !value.isEmpty else { return nil }
        let format = pickerType == .date ? dateFormat : timeFormat
        return value.toDate(dateFormat: format)?.toString(withFormat)
    }
    
    public func getDate() -> Date? {
        guard let value = txtTextField.text, !value.isEmpty else { return nil }
        let format = pickerType == .date ? dateFormat : timeFormat
        return value.toDate(dateFormat: format)
    }
    
    public func setValue(_ value: String) {
        if value.isEmpty { return }
        for i in 0..<items.count where items[i].value == value {
            selectedIndex = i
            break
        }
        if let index = selectedIndex { picker?.selectRow(index, inComponent: 0, animated: false) }
        setText()
    }
    
    public func getSelectedIndex(ignoreIndex: Int? = nil) -> Int? {
        guard let index = selectedIndex else { return nil }
        if let ignore = ignoreIndex, ignore == index { return nil }
        return index
    }
}

extension PickerView: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if !items.isEmpty {
            if selectedIndex == nil { selectedIndex = 0 }
            setText()
        }
        setActiveBorder()
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        setInactiveBorder()
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if pickerType == .date || pickerType == .time {
            if (txtTextField.text ?? "").isEmpty {
                let currentDate = datePicker?.minimumDate ?? Date()
                txtTextField.text = currentDate.toString(pickerType == .date ? dateFormat : timeFormat)
            } else {
                if let minDate = datePicker?.minimumDate, let currentDate = datePicker?.date,
                    currentDate == defaultDate {
                    if Calendar.current.dateComponents([.day], from: currentDate, to: minDate).day ?? 0 > 0 {
                        let date = datePicker?.minimumDate ?? Date()
                        txtTextField.text = date.toString(pickerType == .date ? dateFormat : timeFormat)
                    }                    
                }
            }
        }
        delegate?.pickerView?(editingDone: getSelectedValue(), picker: self)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].value
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        setText()
    }
}
