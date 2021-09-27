//
//  BaseDialogVC.swift
//  FWD
//
//  Created by Codigo Sheilar on 27/07/2020.
//  Copyright © 2020 codigo. All rights reserved.
//

import UIKit

public enum Transition {
    case moveUp
    case moveDown
    case fadeIn
    case scale
}

public class Dialog {
    public static func show(_ title: String, message: String, btnPositiveTitle: String = "", positiveAction: (() -> Void)? = nil, btnNegativeTitle: String = "", negativeAction: (() -> Void)? = nil, transition: Transition = .moveUp, tapGestureDismissal: Bool = true, panGestureDismissal: Bool = true, didDisappear: (() -> Void)? = nil, parentVC: UIViewController? = nil) {
        DispatchQueue.main.async {
            var topVC: UIViewController?
            if let parent = parentVC { topVC = parent }
            else { topVC = UIApplication.shared.keyWindow?.topViewController() }
            if topVC == nil { return }
            
            let dialog = DialogVC(nibName: DialogVC.className, bundle: Bundle.main)
            dialog.transition = transition
            dialog.titleMessage = title
            dialog.message = message
            dialog.btnPositiveTitle = btnPositiveTitle
            dialog.btnNegativeTitle = btnNegativeTitle
            dialog.actionPositive = positiveAction
            dialog.actionNegative = negativeAction
            dialog.didDisappear = didDisappear
            dialog.tapGestureDismissal = tapGestureDismissal
            dialog.panGestureDismissal = panGestureDismissal
            
            topVC?.present(dialog, animated: true, completion: nil)
        }
    }
    
    public static func showApiError(tryAgain: (() -> Void)? = nil, cancelAble: Bool = true) {
        
        if cancelAble {
            Dialog.show(Constant.ApiMessage.errorTitle, message: Constant.ApiMessage.errorMessage, btnPositiveTitle: "Try Again",
                        positiveAction: tryAgain, btnNegativeTitle: "Cancel", negativeAction: nil, transition: .moveUp,
                        tapGestureDismissal: true, panGestureDismissal: true, didDisappear: nil)
        } else {
            Dialog.show(Constant.ApiMessage.errorTitle, message: Constant.ApiMessage.errorMessage, btnPositiveTitle: "Try Again",
                        positiveAction: tryAgain, transition: .moveUp, tapGestureDismissal: false, panGestureDismissal: false,
                        didDisappear: nil)
        }
    }
}

public class BaseDialogVC: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    var viewDidSet = false
    var transition = Transition.moveUp
    var contentViewOriginalCenterY: CGFloat = 0
    var tapGestureDismissal = true
    var panGestureDismissal = true
    
    var didDisappear: (() -> Void)?
    
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // addBlurEffect()
        addBackgroudAlpha()
        setUpAnimation()
    }
    
    func addBackgroudAlpha() {
        viewBackground.backgroundColor = .black
        viewBackground.alpha = 0.7
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
            CustomAnimation.moveFrom(
                direction: .BOTTOM,
                view: viewContent,
                fromX: 0,
                fromY: UIScreen.main.bounds.height,
                duration: 0.3,
                delay: 0,
                completed: nil,
                useBounceEffect: true
            )
        case .moveDown:
            CustomAnimation.moveFrom(
                direction: .TOP,
                view: viewContent,
                fromX: 0,
                fromY: (viewContent.frame.origin.y + viewContent.frame.height),
                duration: 0.3,
                delay: 0,
                completed: nil,
                useBounceEffect: true
            )
        case .fadeIn: break
        case .scale:
            CustomAnimation.scaleFrom(view: viewContent, scaleX: 0, scaleY: 0, duration: 0.3, options: [.curveEaseOut],
                                      completed: nil, useBounceEffect: true)
        }
    }
    
    func disappearAnimation() {
        switch transition {
        case .moveUp:
            CustomAnimation.moveTo(direction: .BOTTOM, view: viewContent, toX: 0, toY: UIScreen.main.bounds.height,
                                   duration: 0.3, delay: 0, completed: nil)
        case .moveDown:
            CustomAnimation.moveTo(direction: .TOP, view: viewContent, toX: 0,
                                   toY: (viewContent.frame.origin.y + viewContent.frame.height), duration: 0.3, delay: 0, completed: nil)
        case .fadeIn: break
        case .scale:
            CustomAnimation.scaleTo(view: viewContent, scaleX: 0.1, scaleY: 0.1, duration: 0.3, options: [.curveEaseOut], completed: nil)
        }
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
    
    func bounceBackToOrignalPosition() {
        //usingSpringWithDamping - higher values make the bouncing finish faster.
        //initialSpringVelocity - higher values give the spring more initial momentum.
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5,
                       options: [.curveEaseInOut], animations: {
            self.viewContent.center = CGPoint(x: self.viewContent.center.x, y: self.contentViewOriginalCenterY)
        }, completion: nil)
    }
    
    @objc func quit() {
        disappearAnimation()
        self.dismissVC()
    }
    
    @objc func hanldePanGesture(_ panGesture: UIPanGestureRecognizer) {
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
    
    deinit {
        print("\(self) deinited")
    }
}
