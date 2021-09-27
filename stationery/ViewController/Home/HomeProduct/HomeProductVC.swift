//  
//  HomeProductVC.swift
//  stationery
//
//  Created by Codigo NOL on 06/01/2021.
//

import UIKit
import CRRefresh

protocol HomeProductDisplayLogic: AnyObject {
    func didSuccessGetItems(data: [ProductResponse])
    func didSuccessLoadMore(data: [ProductResponse])
    func didFailLoadMore()
    func didFailGetItems()
}

class HomeProductVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.home
    
    var router: (NSObjectProtocol & HomeProductRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var colItems: UICollectionView!
    @IBOutlet weak var failView: ConnectionFailView!
    
    var navTitle: String = ""
    var args: Args?
    
    var cellPadding: CGFloat = 20
    var data: [ProductResponse] = []
    var vm: HomeProductVM?
    
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
        let router = HomeProductRouter()
        let vm = HomeProductVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navigationController?.hero.isEnabled = true
        self.hero.isEnabled = true
        
        navBar?.title = navTitle
        self.navBarEffect = false
        self.navBar?.setEffect(1)
        
        colItems.cr.addHeadRefresh(animator: NormalHeaderAnimator()) {
            self.vm?.page = 1
            self.vm?.getProduct(args: self.args)
        }
        
        colItems.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            self.loadMoreList()
        }
        
        colItems.delegate = self
        colItems.dataSource = self
        colItems.register(nib: ItemCell.className)
        colItems.register(nib: AdsBannerCell.className)
        colItems.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        failView.tryAgain = {
            self.vm?.page = 1
            self.vm?.shouldShowLoading = true
            self.vm?.getProduct(args: self.args)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        vm?.getProduct(args: args)
    }
    
    func loadMoreList() {
        vm?.page += 1
        vm?.getProduct(args: args)
    }
}

extension HomeProductVC: HomeProductDisplayLogic {
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
        failView.isHidden = true
        stopRefreshLoadingMore()
        self.data = data
        colItems.reloadData()
        setupLoadMore(dataCount: data.count)
    }
    
    func didFailGetItems() {
        stopRefreshLoadingMore()
        failView.isHidden = false
    }
    
    func didSuccessLoadMore(data: [ProductResponse]) {
        failView.isHidden = true
        stopRefreshLoadingMore()
        setupLoadMore(dataCount: data.count)
        self.data.append(contentsOf: data)
        colItems.reloadData()
    }
    
    func didFailLoadMore() {
        failView.isHidden = true
        stopRefreshLoadingMore()
    }
}

extension HomeProductVC: ItemCellProtocol {
    func itemCell(onTappedCart indexPath: IndexPath, data: ProductResponse) {
        if !checkUserLogin() { return }
        ShopUtil.saveToCart(data, quantity: 1)
        CartDialog.show(self)
    }
    
    func itemCell(onTappedItem indexPath: IndexPath, data: ProductResponse) {
        router?.routeToDetail(heroIdImage: "home\(data.name ?? "")\(indexPath.item)", data: data)
    }
    
    func itemCell(onTappedFav indexPath: IndexPath, data: ProductResponse) {
        if !checkUserLogin() { return }
        self.data[indexPath.item].isFavorite = !self.data[indexPath.item].isFavorite
        if self.data[indexPath.item].isFavorite { ShopUtil.saveToFav(data) }
        else { ShopUtil.deleteFav("\(data.id ?? 0)") }
        colItems.reloadItems(at: [indexPath])
    }
}

extension HomeProductVC: CartDialogProtocol {
    
    func cartDialog(onSelect data: ProductCart) {
        router?.routeToDetail(heroIdImage: "", data: data.toProductResponse())
    }
    
    func cartDialog(viewCart price: Int) { router?.routeToCart() }
    func cartDialog(checkOut price: Int) { router?.routeToCheckOut() }
}

extension HomeProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let adsCell = collectionView.deque(AdsBannerCell.self, index: indexPath)
            adsCell.setData(Constant.AppInfo.adsBanners)
            return adsCell
        }
        
        let cell = collectionView.deque(ItemCell.self, index: indexPath)
        cell.imgItem.hero.id = "home\(data[indexPath.item].name ?? "")\(indexPath.item)"
        cell.setData(indexPath: indexPath, data: data[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let cellHeight = ((collectionView.frame.width*3)/11) + 40// 11:3
            return CGSize(width: collectionView.frame.width, height: cellHeight)
        }
        
        let width = (collectionView.width - (cellPadding*3))/2
        return CGSize(width: width, height: (width*9)/5) //ratio 5:9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? .zero : UIEdgeInsets(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
}
