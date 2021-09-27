//
//  QuantityView.swift
//  stationery
//
//  Created by Codigo NOL on 27/12/2020.
//

import UIKit

protocol QuantityViewProtocol: AnyObject {
    func quantityView(onSelect quantity: Int)
}

class QuantityView: UIView {

    enum Style {
        case normal
        case compact
    }
    
    enum QuantityType {
        case plus
        case minus
    }
    
    @IBOutlet weak var viewMinus: UIView!
    @IBOutlet weak var viewPlus: UIView!
    
    @IBOutlet weak var imgMinus: UIImageView!
    @IBOutlet weak var imgPlus: UIImageView!
    
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var btnPlus: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnMinusTop: NSLayoutConstraint!
    @IBOutlet weak var btnMinusBot: NSLayoutConstraint!
    @IBOutlet weak var btnPlusTop: NSLayoutConstraint!
    @IBOutlet weak var btnPlusBot: NSLayoutConstraint!
    
    weak var delegate: QuantityViewProtocol?
    var quantity = 1
    
    var viewDidLayout = false
    
    var timer: Timer?
    var changeType = QuantityType.plus
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    // MAKR: Setup
    fileprivate func setupView() {
        guard let v = loadViewFromNib() else { return }
        v.frame = bounds
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initView()
        addSubview(v)
        self.backgroundColor = .clear
    }
    
    fileprivate func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if viewDidLayout { return }
        viewDidLayout = true
        self.layoutIfNeeded()
        roundCornerButtons(viewPlus.frame.height/2)
    }
    
    func roundCornerButtons(_ value: CGFloat) {
        viewPlus.cornerRadius = value
        viewMinus.cornerRadius = value
    }
    
    func setStyle(_ style: Style) {
        switch style {
        case .normal:
            stackView.spacing = 12
            btnMinusTop.constant = 0
            btnMinusBot.constant = 0
            btnPlusTop.constant = 0
            btnPlusBot.constant = 0
        case .compact:
            stackView.spacing = 4
            btnMinusTop.constant = 4
            btnMinusBot.constant = 4
            btnPlusTop.constant = 4
            btnPlusBot.constant = 4
        }
    }
    
    func initView() {
        txtNumber.text = "\(quantity)"
        
//        imgPlus.image = UIImage(named: "iconplus")?.withRenderingMode(.alwaysTemplate)
//        imgMinus.image = UIImage(named: "iconminus")?.withRenderingMode(.alwaysTemplate)
        
        btnPlus.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchDown)
        btnMinus.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchDown)
        
        btnPlus.addTarget(self, action: #selector(self.onReleasedButton(_:)), for: .touchUpOutside)
        btnMinus.addTarget(self, action: #selector(self.onReleasedButton(_:)), for: .touchUpOutside)
        btnPlus.addTarget(self, action: #selector(self.onReleasedButton(_:)), for: .touchUpInside)
        btnMinus.addTarget(self, action: #selector(self.onReleasedButton(_:)), for: .touchUpInside)
        
        txtNumber.delegate = self
    }
    
    @objc func onTappedButton(_ sender: UIButton) {
        
        changeType = sender == btnPlus ? .plus : .minus
        sender.backgroundColor = Color.Red.instance()
        switch changeType {
        case .plus: imgPlus.tintColor = .white
        case .minus: imgMinus.tintColor = .white
        }
        startTimer()
    }
    
    @objc func onReleasedButton(_ sender: UIButton) {
        sender.backgroundColor = .clear
        switch changeType {
        case .plus: imgPlus.tintColor = Color.Black.instance()
        case .minus: imgMinus.tintColor = Color.Black.instance()
        }
        delegate?.quantityView(onSelect: quantity)
        destoryTimer()
    }
    
    func changeQuantity() {
        switch changeType {
        case .plus:
            quantity += 1
        case .minus:
            if quantity <= 1 { quantity = 1 }
            else { quantity -= 1 }
        }
        txtNumber.text = "\(quantity)"
    }
    
    func startTimer() {
        if timer != nil { return }
        self.changeQuantity()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.changeQuantity()
        })
    }
    
    func destoryTimer() {
        if timer == nil { return }
        timer?.invalidate()
        timer = nil
    }
    
    func setQuantity(_ quantity: Int) {
        self.quantity = quantity
        txtNumber.text = "\(quantity)"
    }
    
    func resetQuantity() {
        quantity = 1
        txtNumber.text = "1"
    }
    
    public func getQuantity() -> Int { return quantity }
}

extension QuantityView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let number = textField.text?.toInt else {
            resetQuantity()
            return
        }
        if number < 1 { resetQuantity() }
        quantity = number
        delegate?.quantityView(onSelect: quantity)
    }
}
