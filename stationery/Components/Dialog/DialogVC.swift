//
//  DialogVC.swift
//  Component
//
//  Created by Codigo NOL on 16/01/2020.
//  Copyright © 2020 Codigo. All rights reserved.
//

import UIKit

public class Dialog: UIViewController {
    
//    public func showDialog(_ vc: UIViewController, title: String, message: String, btnPositiveTitle: String = "", positiveAction: (() -> Void)? = nil, btnNegativeTitle: String = "", negativeAction: (() -> Void)? = nil, transition: DialogVC.Transition = .scale, tapGestureDismissal: Bool = true, panGestureDismissal: Bool = true, didDisappear: (() -> Void)? = nil) {
//        DispatchQueue.main.async {
//            let dialog = DialogVC(nibName: DialogVC.className, bundle: Bundle(for: type(of: self)))
//            dialog.transition = transition
//            dialog.titleMessage = title
//            dialog.message = message
//            dialog.btnPositiveTitle = btnPositiveTitle
//            dialog.btnNegativeTitle = btnNegativeTitle
//            dialog.actionPositive = positiveAction
//            dialog.actionNegative = negativeAction
//            dialog.didDisappear = didDisappear
//            dialog.tapGestureDismissal = tapGestureDismissal
//            dialog.panGestureDismissal = panGestureDismissal
//            vc.present(dialog, animated: true, completion: nil)
//        }
//    }
    
    public enum Transition {
        case moveUp
        case moveDown
        case fadeIn
        case scale
    }
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnPositive: UIButton!
    @IBOutlet weak var btnNegative: UIButton!
    
    var transition = Transition.moveUp
    var viewDidSet = false
    var titleMessage = ""
    var message = ""
    var btnPositiveTitle = ""
    var btnNegativeTitle = ""
    var actionPositive: (() -> Void)?
    var actionNegative: (() -> Void)?
    var didDisappear: (() -> Void)?
    var tapGestureDismissal = true
    var panGestureDismissal = true
    var contentViewOriginalCenterY: CGFloat = 0
    
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
        
        addBlurEffect()
        setUpView()
        setUpAnimation()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappear?()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewDidSet { return }
        viewDidSet = true
        appearAnimation()
        if tapGestureDismissal { addTapGesture() }
        if panGestureDismissal { addPanGesture() }
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tapGestureDismissal { addTapGesture() }
        if panGestureDismissal { addPanGesture() }
    }
    
    func setUpView() {
        
        if btnPositiveTitle.isEmpty && btnNegativeTitle.isEmpty {
            btnNegative.isHidden = false
            btnPositive.isHidden = true
            btnNegative.setTitle("Ok", for: .normal)
            btnNegative.addTarget(self, action: #selector(quit), for: .touchUpInside)
            return
        }
        
        btnPositive.isHidden = btnPositiveTitle.isEmpty
        btnPositive.setTitle(btnPositiveTitle, for: .normal)
        btnPositive.addTarget(self, action: #selector(positiveBtnOnTapped), for: .touchUpInside)
        
        btnNegative.isHidden = btnNegativeTitle.isEmpty
        btnNegative.setTitle(btnNegativeTitle, for: .normal)
        btnNegative.addTarget(self, action: #selector(negativeBtnOnTapped), for: .touchUpInside)
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.quit))
        viewBackground.addGestureRecognizer(tap)
    }
    
    func addPanGesture() {
        contentViewOriginalCenterY = viewContent.center.y
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(hanldePanGesture(_:)))
        viewContent.addGestureRecognizer(panGesture)
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = viewBackground.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewBackground.alpha = 0.9
        viewBackground.addSubview(blurEffectView)
    }
    
    @objc func positiveBtnOnTapped() {
        actionPositive?()
        quit()
    }
    
    @objc func negativeBtnOnTapped() {
        actionNegative?()
        quit()
    }
    
    func setUpAnimation() {
        switch transition {
        case .moveUp: self.viewContent.alpha = 0
        case .moveDown: self.viewContent.alpha = 0
        case .fadeIn: break
        case .scale: break
        }
    }
    
    func appearAnimation() {
        switch transition {
        case .moveUp:
            CustomAnimation.moveFrom(direction: .BOTTOM, view: viewContent, fromX: 0, fromY: UIScreen.main.bounds.height, duration: 0.3, delay: 0, completed: nil, useBounceEffect: true)
        case .moveDown:
            CustomAnimation.moveFrom(direction: .TOP, view: viewContent, fromX: 0, fromY: (viewContent.frame.origin.y + viewContent.frame.height), duration: 0.3, delay: 0, completed: nil, useBounceEffect: true)
        case .fadeIn: break
        case .scale:
            CustomAnimation.scaleFrom(view: viewContent, scaleX: 0, scaleY: 0, duration: 0.3, options: [.curveEaseOut], completed: nil, useBounceEffect: true)
        }
    }
    
    func disappearAnimation() {
        switch transition {
        case .moveUp:
            CustomAnimation.moveTo(direction: .BOTTOM, view: viewContent, toX: 0, toY: UIScreen.main.bounds.height, duration: 0.3, delay: 0, completed: nil)
        case .moveDown:
            CustomAnimation.moveTo(direction: .TOP, view: viewContent, toX: 0, toY: (viewContent.frame.origin.y + viewContent.frame.height), duration: 0.3, delay: 0, completed: nil)
        case .fadeIn: break
        case .scale:
            CustomAnimation.scaleTo(view: viewContent, scaleX: 0.1, scaleY: 0.1, duration: 0.3, options: [.curveEaseOut], completed: nil)
        }
    }
    
    @objc func quit() {
        disappearAnimation()
        self.dismissVC()
    }
    
    @objc func hanldePanGesture(_ panGesture:UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self.view)
        if viewContent.center.y + translation.y > contentViewOriginalCenterY {
            viewContent.center = CGPoint(x: viewContent.center.x, y: viewContent.center.y + translation.y)
            panGesture.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if panGesture.state == UIGestureRecognizer.State.ended {
            if viewContent.center.y - contentViewOriginalCenterY > self.view.frame.height/4 {
                quit()
            } else {
                bounceBackToOrignalPosition()
            }
        }
    }
    
    func bounceBackToOrignalPosition() {
        //usingSpringWithDamping - higher values make the bouncing finish faster.
        //initialSpringVelocity - higher values give the spring more initial momentum.
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.viewContent.center = CGPoint(x: self.viewContent.center.x, y: self.contentViewOriginalCenterY)
        }, completion: nil)
    }
}
