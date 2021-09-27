//
//  PaymentTypeView.swift
//  stationery
//
//  Created by Codigo NOL on 10/01/2021.
//

import UIKit

protocol PaymentTypeViewProtocol: AnyObject {
    func paymentTypeView(onSelect data: PaymentType?)
}

class PaymentTypeView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var button: UIButton!
    
    var data: PaymentType?
    var selected: Bool = false
    var delegate: PaymentTypeViewProtocol?
    
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
    
    func initView() {
        button.addTarget(self, action: #selector(self.onTappedButton), for: .touchUpInside)
    }

    func setUpData(_ data: PaymentType, select: Bool = false) {
        let lan = AppUtil.shared.currentLanguage
        self.data = data
        lblTitle.text = lan == .myanmar ? data.titleMm : data.title
        lblInfo.text = lan == .myanmar ? data.descMm : data.desc
        setSelected(select)
    }
    
    func setSelected(_ select: Bool) {
        self.selected = select
        imgCheck.image = UIImage(named: select ? "iconcheckfill" : "iconcheckempty")
        infoView.isHidden = !select
    }
    
    func getSelected() -> Bool { return selected }
    
    @objc func onTappedButton() {
        delegate?.paymentTypeView(onSelect: data)
    }
}
