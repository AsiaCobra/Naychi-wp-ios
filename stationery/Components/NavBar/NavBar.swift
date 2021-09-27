//
//  NavBar.swift
//  stationery
//
//  Created by Codigo NOL on 24/12/2020.
//

import UIKit

class NavBar: UIView {
    
    // MARK: IBInspectable
    @IBInspectable public var title: String? = nil {
        didSet { lblTitle.text = title }
    }
    
    @IBInspectable public var backBtnColor: UIColor = Color.Black.instance() {
        didSet { imgBack.tintColor = backBtnColor }
    }
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
   
    
    
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
        btnBack.addTarget(self, action: #selector(self.quit), for: .touchUpInside)
        lblTitle.isUserInteractionEnabled = true
        lblTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.quit)))
    }
    
    func setTitle(_ title: String) {
        lblTitle.text = title
    }
    
    func setEffect(_ alpha: CGFloat) {
        viewBg.alpha = alpha
        lblTitle.alpha = alpha
        imgBack.tintColor = alpha == 0 ? backBtnColor : UIColor.white.withAlphaComponent(alpha)
    }
    
    @objc func quit() {
        if let nav = parentViewController?.navigationController  {
            nav.popViewController(animated: true)
        } else {
            parentViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
