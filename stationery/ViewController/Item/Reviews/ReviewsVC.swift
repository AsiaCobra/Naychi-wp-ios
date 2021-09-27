//  
//  ReviewsVC.swift
//  stationery
//
//  Created by Codigo NOL on 15/01/2021.
//

import UIKit

protocol ReviewsDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class ReviewsVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.items
    
    var router: (NSObjectProtocol & ReviewsRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var tblReviews: UITableView!

    var vm: ReviewsVM?
    var navTitle: String = ""
    var data: [ReviewResponse] = []
    
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
        let router = ReviewsRouter()
        let vm = ReviewsVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navBarEffect = false
        self.navBar?.setEffect(1)
        self.navBar?.title = navTitle
        
        tblReviews.register(nib: ReviewCell.className, bundle: Bundle(for: type(of: self)))
//        tblReviews.registerHeaderFooter(nib: CartFooter.className, bundle: Bundle(for: type(of: self)))
        tblReviews.estimatedRowHeight = 120
        tblReviews.rowHeight = UITableView.automaticDimension
        tblReviews.delegate = self
        tblReviews.dataSource = self
        tblReviews.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
}

extension ReviewsVC: ReviewsDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}

extension ReviewsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(ReviewCell.self)
        cell.setData(data[indexPath.row])
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}

