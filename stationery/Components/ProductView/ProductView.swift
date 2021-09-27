//
//  ProductView.swift
//  stationery
//
//  Created by Codigo NOL on 07/01/2021.
//

import UIKit

class ProductView: UIView {

    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var lblPrice: LanguageLabel!
    
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
        
    }
    
    func setData(title: String, price: String) {
        lblTitle.text = title
        lblPrice.changeLanguage(AppUtil.shared.currentLanguage, title: price)
    }
}
