//
//  BaseListDialog.swift
//  stationery
//
//  Created by Codigo NOL on 29/12/2020.
//

import UIKit

public class BaseListDialogVC: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var btnCross: UIButton!
    
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var viewDidSet = false
    var titleMessage = ""
    var tapGestureDismissal = true
    var panGestureDismissal = true
    var contentViewOriginalCenterY: CGFloat = 0
    var cellHeight: CGFloat = 58
    var titleHeight: CGFloat = 50 // get from xib
    var tableBotInset: CGFloat = 20
    var totalItems = 0
    var tableExtraHeight: CGFloat = 0
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.quit))
        viewBackground.addGestureRecognizer(tap)
        addBlurEffect()
        setUpView()
        setUpAnimation()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewDidSet { return }
        viewDidSet = true
        appearAnimation()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculateTableHeight()
        viewContent.addCornerRadius(corners: [.TOP_LEFT, .TOP_RIGHT], radius: 16)
        if tapGestureDismissal { addTapGesture() }
        if panGestureDismissal { addPanGesture() }
    }
    
    func setUpView() {
        lblTitle.font = Font.Bold.of(size: 13)
        lblTitle.text = titleMessage
        btnCross.addTarget(self, action: #selector(quit), for: .touchUpInside)
    }
    
    func calculateTableHeight() {
        let tblHeight = (cellHeight*CGFloat(totalItems)) + tableExtraHeight
        let maxHeight = UIScreen.main.bounds.height * 0.8 // 80 percent of screen
        if tblHeight+titleHeight+self.bottomSafeArea > maxHeight {
            tableHeight.constant = maxHeight
        } else {
            tableHeight.constant = tblHeight + self.bottomSafeArea
//            tblItems.isScrollEnabled = false
            tblItems.alwaysBounceVertical = false
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
    
    func setUpAnimation() {
        self.viewContent.alpha = 0
    }
    
    func appearAnimation() {
        CustomAnimation.moveFrom(direction: .BOTTOM, view: viewContent, fromX: 0, fromY: UIScreen.main.bounds.height, duration: 0.3, delay: 0, completed: nil)
    }
    
    func disappearAnimation() {
        CustomAnimation.moveTo(direction: .BOTTOM, view: viewContent, toX: 0, toY: UIScreen.main.bounds.height, duration: 0.3, delay: 0, completed: nil)
    }
    
    @objc func quit() {
        disappearAnimation()
        self.dismiss(animated: true)
    }
    
    @objc func quit(completion: (() -> Void)? = nil) {
        disappearAnimation()
        self.dismiss(animated: true, completion: completion)
    }
    
    @objc func hanldePanGesture(_ panGesture:UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self.view)
        if viewContent.center.y + translation.y > contentViewOriginalCenterY {
            viewContent.center = CGPoint(x: viewContent.center.x, y: viewContent.center.y + translation.y)
            panGesture.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if panGesture.state == UIGestureRecognizer.State.ended {
            if viewContent.center.y - contentViewOriginalCenterY > viewContent.frame.height/2 {
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
