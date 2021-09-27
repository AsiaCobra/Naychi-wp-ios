//  
//  ReviewSubmitVC.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import UIKit
import Cosmos

protocol ReviewSubmitProtocol: AnyObject {
    func reviewSubmit(onSubmit data: ReviewResponse)
}

protocol ReviewSubmitDisplayLogic: AnyObject {
    func didSuccessSubmit(data: ReviewResponse)
    func didFailSubmit()
}

class ReviewSubmitVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.items
    
    var router: (NSObjectProtocol & ReviewSubmitRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var txtReview: TextViewWithTitle!
    @IBOutlet weak var btnSubmit: UIButton!    

    var vm: ReviewSubmitVM?
    var productId: String = ""
    var delegate: ReviewSubmitProtocol?
    
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
        let router = ReviewSubmitRouter()
        let vm = ReviewSubmitVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        starView.rating = 0
        starView.settings.fillMode = .full
        
        btnSubmit.addTarget(self, action: #selector(self.onTappedSubmit), for: .touchUpInside)
        btnCross.addTarget(self, action: #selector(self.quit), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func onTappedSubmit() {
        self.view.endEditing(true)
        vm?.submitReview(productId, rating: Int(starView.rating), review: txtReview.text ?? "")
    }
    
    @objc func quit() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReviewSubmitVC: ReviewSubmitDisplayLogic {
    
    func didSuccessSubmit(data: ReviewResponse) {
        delegate?.reviewSubmit(onSubmit: data)
        NotiBanner.toast(AppUtil.shared.currentLanguage == .myanmar ? "သုံးသပ်ချက်အား ပို့လိုက်ပါပြီ။" : "Review submitted", icon: nil, type: .success)
        quit()
    }
    
    func didFailSubmit() {
        Dialog.showApiError(tryAgain: {
            self.vm?.submitReview(self.productId, rating: Int(self.starView.rating), review: self.txtReview.text ?? "")
        }, cancelAble: true)
    }
    
}
