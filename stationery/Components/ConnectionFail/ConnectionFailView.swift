//
//  ConnectionFailView.swift
//  stationery
//
//  Created by Codigo NOL on 22/12/2020.
//

import UIKit

class ConnectionFailView: UIView {
    
    @IBInspectable public var title: String? = nil {
        didSet { lblTitle.text = title }
    }
    
    @IBInspectable public var message: String? = nil {
        didSet { lblMessage.text = message }
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnTryAgain: UIButton!
    
    var tryAgain: (() -> Void)?
    
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
        
        btnTryAgain.addTarget(self, action: #selector(self.onTappedTryAgain), for: .touchUpInside)
        
        addSubview(v)
        self.backgroundColor = .clear
    }
    
    fileprivate func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    @objc func onTappedTryAgain() {
        tryAgain?()
    }

}
