//  
//  CartVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit

protocol CartDisplayLogic: AnyObject {
    func didSuccessCurrentTime()
    func didFailedCurrentTime()
}

class CartVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.cart
    
    var router: (NSObjectProtocol & CartRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var lblEmpty: LanguageLabel!
    @IBOutlet weak var btnShopping: LanguageButton!
    @IBOutlet weak var tblItems: UITableView!
    
    var vm: CartVM?
    var items: [ProductCart] = []
    var viewAppeared = false
    
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
        let router = CartRouter()
        let vm = CartVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navigationController?.hero.isEnabled = true
        self.hero.isEnabled = true
        
        tblItems.register(nibs: [CartCell.className, CartTotalCell.className])
        tblItems.delegate = self
        tblItems.dataSource = self
        tblItems.estimatedRowHeight = 147
        tblItems.rowHeight = UITableView.automaticDimension
        tblItems.separatorStyle = .none
        tblItems.reloadData()
        
        btnShopping.addTarget(self, action: #selector(self.onTappedShopping), for: .touchUpInside)
        
        navView?.tblItems = tblItems
        
        self.mainHeader?.onLanguageChange = { _ in
            self.changeLanguage()
            self.tblItems.reloadData()
        }
    }
    
    func changeLanguage() {
        lblEmpty.changeLanguage(AppUtil.shared.currentLanguage)
        btnShopping.changeLanguage(AppUtil.shared.currentLanguage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enableDrawerPanGesture()
        if !viewAppeared { tblItems.isHidden = true }
        viewAppeared = true
        setUpData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        disableDrawerPanGesture()
    }
    
    func setUpData() {
        items = ShopUtil.getSavedCart()
        emptyView.isHidden = !items.isEmpty
        tblItems.reloadData()
        
        if !items.isEmpty {
            vm?.getCurrentTime()
        } else {
            tblItems.isHidden = true
        }
    }
    
    @objc func onTappedShopping() {
        guard let tabBar = AppUtil.getTabBar() else { return }
        tabBar.routeTo(screen: .item)
    }
}

extension CartVC: CartCellProtocol, CartTotalCellProtocol {
    
    func cartCell(onChange quantity: Int, index: Int, data: ProductCart) {
        items[index].saveValue { items[index].quantity = quantity }
        tblItems.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        tblItems.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
    }
    
    func cartCell(onDelete index: Int, data: ProductCart) {
        ShopUtil.deleteCart(data.id)
        setUpData()
//        tblItems.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
    }
    
    func cartTotalCell(checkOut subTotal: Int, discount: Int, total: Int) {
        ShopUtil.saveCartTotal(subTotal: subTotal, discount: discount, total: total)
        router?.routeToCartAddress()
    }
}

extension CartVC: CartDisplayLogic {
    func didFailedCurrentTime() {
        Dialog.showApiError(tryAgain: {
            self.vm?.getCurrentTime()
        }, cancelAble: false)
    }
    
    func didSuccessCurrentTime() {
        tblItems.isHidden = false
        tblItems.reloadData()
    }
}

extension CartVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? items.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.deque(CartCell.self)
            cell.setData(items[indexPath.row], index: indexPath)
            cell.delegate = self
            return  cell
        }
        
        let cell = tableView.deque(CartTotalCell.self)
        let price = ShopUtil.getCartTotal()
        cell.setData(subTotal: price.subTotal, discount: price.discount, total: price.total)
        cell.delegate = self
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
