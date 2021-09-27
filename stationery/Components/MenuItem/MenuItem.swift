//
//  MenuItem.swift
//  stationery
//
//  Created by Codigo NOL on 12/07/2021.
//

import UIKit

protocol MenuItemProtocol: AnyObject {
    func menuItem(onTapped link: String)
}

class MenuItem: UIView {

    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var button: UIButton!
    
    var data: HomeMenu? = nil {  didSet { setUpTitle() } }
    
    weak var delegate: MenuItemProtocol?
    
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
    
    func setUpTitle() {
        lblTitle.setUp(textMyanmar: data?.titleMm ?? "", textEnglish: data?.titleEng ?? "")
        lblTitle.changeLanguage(AppUtil.shared.currentLanguage)
    }
    
    @objc func onTappedButton() {
        guard let link = data?.link, !link.isEmpty else { return }
        delegate?.menuItem(onTapped: link)
    }

}
