//  
//  ReviewDetailVC.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import UIKit

protocol ReviewDetailDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class ReviewDetailVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.items
    
    var router: (NSObjectProtocol & ReviewDetailRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComment: UILabel!

    var vm: ReviewDetailVM?
    var data: ReviewResponse?
    var navTitle: String = ""
    
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
        let router = ReviewDetailRouter()
        let vm = ReviewDetailVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navBarEffect = false
        navBar?.setEffect(1)
        navBar?.title = navTitle
        
        guard let review = data else {
            imgProfile.setImage("")
            lblRating.text = "-"
            lblName.text = "-----"
            lblDate.text = "----"
            lblComment.text = "----------"
            return
        }
        
        imgProfile.setImage(review.reviewerAvatarUrls?.medium ?? "")
        lblRating.text = "\(review.rating ?? 0)"
        lblName.text = review.reviewer
        lblDate.text = review.dateString
        lblComment.text = review.comment
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension ReviewDetailVC: ReviewDetailDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}
