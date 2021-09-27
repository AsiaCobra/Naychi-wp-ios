//  
//  SplashVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit
import DrawerMenu
import NVActivityIndicatorView

protocol SplashDisplayLogic: AnyObject {
    func didSuccessMasterData()
    func didFailMasterData()
}

class SplashVC: UIViewController, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.main
    
    var router: (NSObjectProtocol & SplashRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var indicatorView: UIView!

    var vm: SplashVM?
    var viewAppeared = false
    var indicator = NVActivityIndicatorView(frame: .zero)
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let router = SplashRouter()
        let vm = SplashVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        

//        let data = ShopUtil.getCategories(sort: true)
//        data.forEach {
//            print("debug:", "api ->", "\"\($0.name ?? "")\": \"\",")
//        }
        ShopUtil.saveRegions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewAppeared { return }
        viewAppeared = true
        
        indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: indicatorView.frame.width, height: indicatorView.frame.height),
                                            type: .ballClipRotateMultiple, color: UIColor.white, padding: 20)
        indicator.startAnimating()
        indicatorView.addSubview(indicator)

        vm?.getMasterData()
    }
}

extension SplashVC: SplashDisplayLogic {
    
    func didSuccessMasterData() {
        router?.routeToApp()
    }
    
    func didFailMasterData() {
        Dialog.showApiError(tryAgain: {
            self.vm?.getMasterData()
        }, cancelAble: false)
    }
}
