//
//  DialogVC.swift
//  Component
//
//  Created by Codigo NOL on 16/01/2020.
//  Copyright © 2020 Codigo. All rights reserved.
//

import UIKit

public class DialogVC: BaseDialogVC {
        
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnPositive: UIButton!
    @IBOutlet weak var btnNegative: UIButton!
    @IBOutlet weak var divider: UIView!
    
    var titleMessage = ""
    var message = ""
    var btnPositiveTitle = ""
    var btnNegativeTitle = ""
    var actionPositive: (() -> Void)?
    var actionNegative: (() -> Void)?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        lblTitle.text = titleMessage
        lblMessage.text = message
        
        if btnPositiveTitle.isEmpty && btnNegativeTitle.isEmpty {
            btnNegative.isHidden = true
            btnPositive.isHidden = false
            btnPositive.setTitle("Okay", for: .normal)
            btnPositive.setTitle("Okay", for: .highlighted)
            btnPositive.addTarget(self, action: #selector(quit), for: .touchUpInside)
            divider.isHidden = true
            return
        }
        
        btnPositive.isHidden = btnPositiveTitle.isEmpty
        btnPositive.setTitle(btnPositiveTitle, for: .normal)
        btnPositive.setTitle(btnPositiveTitle, for: .highlighted)
        btnPositive.addTarget(self, action: #selector(positiveBtnOnTapped), for: .touchUpInside)
        
        btnNegative.isHidden = btnNegativeTitle.isEmpty
        btnNegative.setTitle(btnNegativeTitle, for: .normal)
        btnNegative.setTitle(btnNegativeTitle, for: .highlighted)
        btnNegative.addTarget(self, action: #selector(negativeBtnOnTapped), for: .touchUpInside)
        
        divider.isHidden = btnNegative.isHidden || btnPositive.isHidden
    }
    
    @objc func positiveBtnOnTapped() {
        quit()
        actionPositive?()
    }
    
    @objc func negativeBtnOnTapped() {
        quit()
        actionNegative?()
    }
}
