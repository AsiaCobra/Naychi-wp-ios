//  
//  ItemVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit
import CRRefresh
import Hero

protocol ItemDisplayLogic: AnyObject {
    func didSuccessGetItems(data: [ProductResponse])
    func didSuccessLoadMore(data: [ProductResponse])
    func didFailLoadMore()
    func didFailGetItems()
}

class ItemVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.items
    
    var router: (NSObjectProtocol & ItemRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var colItems: UICollectionView!
    @IBOutlet weak var failView: ConnectionFailView!
    @IBOutlet weak var emptyView: UIView!
    
    var cellPadding: CGFloat = 20
    var data: [ProductResponse] = []
    
    var vm: ItemVM?
    var showFilter = false
    
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
        let router = ItemRouter()
        let vm = ItemVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navigationController?.hero.isEnabled = true
        self.hero.isEnabled = true
//        self.view.hero.modifiers = [.duration(0.6), .fade]
        
        colItems.cr.addHeadRefresh(animator: NormalHeaderAnimator()) {
            self.vm?.page = 1
            self.getProducts()
        }
        
        colItems.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            self.loadMoreList()
        }
        
        colItems.delegate = self
        colItems.dataSource = self
        colItems.register(nib: ItemCell.className)
        colItems.registerSectionHeader(nib: ItemHeader.className)
        colItems.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        failView.tryAgain = {
            self.vm?.page = 1
            self.vm?.shouldShowLoading = true
            self.getProducts()
        }
        
        navView?.colItems = colItems
        
        self.mainHeader?.onLanguageChange = { _ in
            self.colItems.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getProducts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enableDrawerPanGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        disableDrawerPanGesture()
    }
    
    func loadMoreList() {
        vm?.page += 1
        getProducts()
    }
    
    func getProducts() {
        emptyView.isHidden = true
        vm?.getProduct()
    }
}

extension ItemVC: ItemDisplayLogic {
    
    func removeLoadMore() {
        colItems.cr.removeFooter()
    }
    
    func stopRefreshLoadingMore() {
        colItems.cr.endHeaderRefresh()
        colItems.cr.endLoadingMore()
    }
    
    func setupLoadMore(dataCount: Int) {
        if dataCount < vm?.totalPerPage ?? 0 {
            removeLoadMore()
            return
        }
        
        if dataCount >= vm?.totalPerPage ?? 0 {
            colItems.cr.resetNoMore()
        }
    }
    
    func didSuccessGetItems(data: [ProductResponse]) {
        emptyView.isHidden = true
        failView.isHidden = true
        stopRefreshLoadingMore()
        self.data = data
        colItems.reloadData()
        setupLoadMore(dataCount: data.count)
        if data.isEmpty { emptyView.isHidden = false }
    }
    
    func didFailGetItems() {
        stopRefreshLoadingMore()
        self.data.removeAll()
        colItems.reloadData()
        failView.isHidden = false
        emptyView.isHidden = true
    }
    
    func didSuccessLoadMore(data: [ProductResponse]) {
        failView.isHidden = true
        stopRefreshLoadingMore()
        setupLoadMore(dataCount: data.count)
        self.data.append(contentsOf: data)
        colItems.reloadData()
    }
    
    func didFailLoadMore() {
        emptyView.isHidden = true
        failView.isHidden = true
        stopRefreshLoadingMore()
    }
}

extension ItemVC: ItemCellProtocol {
    func itemCell(onTappedCart indexPath: IndexPath, data: ProductResponse) {
        if !checkUserLogin() { return }
        ShopUtil.saveToCart(data, quantity: 1)
        CartDialog.show(self)
    }
    
    func itemCell(onTappedItem indexPath: IndexPath, data: ProductResponse) {
        router?.routeToDetail(heroIdImage: "\(data.name ?? "")\(indexPath.item)", data: data)
    }
    
    func itemCell(onTappedFav indexPath: IndexPath, data: ProductResponse) {
        if !checkUserLogin() { return }
        self.data[indexPath.item].isFavorite = !self.data[indexPath.item].isFavorite
        if self.data[indexPath.item].isFavorite { ShopUtil.saveToFav(data) }
        else { ShopUtil.deleteFav("\(data.id ?? 0)") }
        colItems.reloadItems(at: [indexPath])
    }
}

extension ItemVC: CartDialogProtocol {
    
    func cartDialog(onSelect data: ProductCart) {
        router?.routeToDetail(heroIdImage: "", data: data.toProductResponse())
    }
    
    func cartDialog(viewCart price: Int) { router?.routeToCart() }
    func cartDialog(checkOut price: Int) { router?.routeToCheckOut() }
}

extension ItemVC: ItemHeaderProtocol {
    
    func itemHeader(filter show: Bool) {
        showFilter = show
        colItems.reloadData()
    }
    
    func itemHeader(sort sorting: ItemSort) {
        if vm?.sortOrder ?? .normal == sorting { return }
        vm?.sortOrder = sorting
        self.vm?.page = 1
        self.vm?.shouldShowLoading = true
        self.getProducts()
    }
    
    func itemHeader(filter categoryId: String, price: ItemPrice) {
        
        if self.vm?.categoryId ?? "" == categoryId && self.vm?.price ?? .pAny == price {
            return
        }
        self.vm?.page = 1
        self.vm?.shouldShowLoading = true
        self.vm?.categoryId = categoryId.isEmpty ? nil : categoryId
        self.vm?.price = price
        self.getProducts()
    }
}

extension ItemVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(ItemCell.self, index: indexPath)
        cell.imgItem.hero.id = "\(data[indexPath.item].name ?? "")\(indexPath.item)"
        cell.setData(indexPath: indexPath, data: data[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.width - (cellPadding*3))/2
        return CGSize(width: width, height: (width*9)/5) //ratio 5:9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeHeader(ItemHeader.self, index: indexPath)
            header.setUpData(showFilter: showFilter)
            header.delegate = self
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: showFilter ? 131 : 81)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}
