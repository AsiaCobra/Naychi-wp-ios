//
//  DiscountView.swift
//  stationery
//
//  Created by Codigo NOL on 18/07/2021.
//

import UIKit

struct DiscountModel {
    let titleEng, titleMm, discount: String
    let type: DiscountType
}

enum DiscountType: String {
    case percentage = "percentage"
    case fixed = "fixed"
}

class DiscountView: UIView {

    @IBOutlet weak var lblDiscountTitle: LanguageLabel!
    @IBOutlet weak var lblDiscount: LanguageLabel!

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
    
    func setData(_ data: DiscountModel) {
        
        lblDiscountTitle.setUp(textMyanmar: data.titleMm, textEnglish: data.titleEng)
        lblDiscountTitle.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblDiscount.text = "\(AppUtil.shared.currentLanguage == .myanmar ? data.discount.mmNumbers() : data.discount) "
        lblDiscount.text?.append(AppUtil.shared.currentLanguage == .myanmar ? "ကျပ်" : "Ks")
        
    }
}
