//  
//  FavoriteVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit

protocol FavoriteDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class FavoriteVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.favorite
    
    var router: (NSObjectProtocol & FavoriteRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var lblEmpty: LanguageLabel!
    @IBOutlet weak var btnShopping: LanguageButton!
    @IBOutlet weak var tblItems: UITableView!

    var vm: FavoriteVM?
    var items: [ProductFav] = []
    
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
        let router = FavoriteRouter()
        let vm = FavoriteVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navigationController?.hero.isEnabled = true
        self.hero.isEnabled = true
        
        tblItems.register(nibs: [FavoriteCell.className])
        tblItems.delegate = self
        tblItems.dataSource = self
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
        setUpData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        disableDrawerPanGesture()
    }
    
    func setUpData() {
        items = ShopUtil.getSavedFav()
        emptyView.isHidden = !items.isEmpty
        tblItems.isHidden = items.isEmpty
        tblItems.reloadData()
    }
    
    
    @objc func onTappedShopping() {
        guard let tabBar = AppUtil.getTabBar() else { return }
        tabBar.routeTo(screen: .item)
    }
}

extension FavoriteVC: FavoriteDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}

extension FavoriteVC: FavoriteCellProtocol {
    func favoriteCell(onTappedCart index: Int, data: ProductFav) {
        if !checkUserLogin() { return }
        ShopUtil.saveToCart(data.toProductResponse(), quantity: 1)
        CartDialog.show(self)
    }
    
    func favoriteCell(onTappedItem index: Int, data: ProductFav) {
        router?.routeToDetail(heroIdImage: "\(data.name ?? "")\(index)", data: data.toProductResponse())
    }
    
    func favoriteCell(onTappedFav index: Int, data: ProductFav) {
        Dialog.show("", message: "Are you sure you want to remove this item from wishlist?", btnPositiveTitle: "Yes", positiveAction: {
            ShopUtil.deleteFav(data.id)
            self.setUpData()
        }, btnNegativeTitle: "No")
    }
}

extension FavoriteVC: CartDialogProtocol {
    
    func cartDialog(onSelect data: ProductCart) {
        router?.routeToDetail(heroIdImage: "", data: data.toProductResponse())
    }
    func cartDialog(viewCart price: Int) { router?.routeToCart() }
    func cartDialog(checkOut price: Int) { router?.routeToCheckOut() }
}

extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(FavoriteCell.self)
        cell.imgItem.hero.id = "\(items[indexPath.item].name ?? "")\(indexPath.item)"
        cell.setData(index: indexPath.row, data: items[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

