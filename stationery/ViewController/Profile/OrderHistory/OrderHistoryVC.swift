//  
//  OrderHistoryVC.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import UIKit

protocol OrderHistoryDisplayLogic: AnyObject {
    func didSuccessOrders(data: [OrderHistory])
    func didFailOrders()
}

class OrderHistoryVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.profile
    
    
    var router: (NSObjectProtocol & OrderHistoryRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var tblOrders: UITableView!
    
    var vm: OrderHistoryVM?
    var data: [OrderHistory] = []
    
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
        let router = OrderHistoryRouter()
        let vm = OrderHistoryVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navBarEffect = false
        self.navBar?.setEffect(1)
        
        tblOrders.register(nibs: [OrderHistoryCell.className])
        tblOrders.delegate = self
        tblOrders.dataSource = self
        tblOrders.estimatedRowHeight = 131
        tblOrders.rowHeight = UITableView.automaticDimension
        tblOrders.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        vm?.getOrders()
    }
}

extension OrderHistoryVC: OrderHistoryDisplayLogic {
    func didSuccessOrders(data: [OrderHistory]) {
        self.data = data
        tblOrders.reloadData()
    }
    
    func didFailOrders() {
        Dialog.showApiError(tryAgain: {[weak self] in
            self?.vm?.getOrders()
        }, cancelAble: true)
    }
}

extension OrderHistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.deque(OrderHistoryCell.self)
        cell.setUpData(data: data[indexPath.row])
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToDetail(data: data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

