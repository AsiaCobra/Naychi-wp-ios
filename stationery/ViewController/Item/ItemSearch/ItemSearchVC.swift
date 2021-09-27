//  
//  ItemSearchVC.swift
//  stationery
//
//  Created by Codigo NOL on 30/12/2020.
//

import UIKit
import CRRefresh

protocol ItemSearchDisplayLogic: AnyObject {
    func didSuccessGetItems(data: [ProductResponse])
    func didSuccessLoadMore(data: [ProductResponse])
    func didFailLoadMore()
    func didFailGetItems()
}

class ItemSearchVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.items
    
    var router: (NSObjectProtocol & ItemSearchRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtProduct: TextField!
    @IBOutlet weak var pickerCategory: PickerView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var colItems: UICollectionView!
    @IBOutlet weak var emptyView: UIView!

    var vm: ItemSearchVM?
    var cellPadding: CGFloat = 20
    var data: [ProductResponse] = []
    
    var selectCatId: String?
    
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
        let router = ItemSearchRouter()
        let vm = ItemSearchVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navigationController?.hero.isEnabled = true
        self.hero.isEnabled = true
        setUpCategoryData()
        
        colItems.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            self.loadMoreList()
        }
        
        colItems.delegate = self
        colItems.dataSource = self
        colItems.register(nib: ItemCell.className)
        colItems.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        btnSearch.addTarget(self, action: #selector(self.onTappedSearch), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(self.quit), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if !(selectCatId ?? "").isEmpty { onTappedSearch() }
    }
    
    func setUpCategoryData() {
        let cat = ShopUtil.getCategoriesForPicker(selectId: selectCatId)
        pickerCategory.setData(items: cat.data, selectedIndex: cat.selectedIndex)
    }
    
    @objc func onTappedSearch() {
        self.view.endEditing(true)
        vm?.page = 1
        vm?.shouldShowLoading = true
        getProducts()
    }
    
    func getProducts() {
        vm?.getProduct(txtProduct.text ?? "", category: pickerCategory.getSelectedId() ?? "")
    }
    
    func loadMoreList() {
        vm?.page += 1
        getProducts()
    }
    
    @objc func quit() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ItemSearchVC: ItemSearchDisplayLogic {
    func removeLoadMore() {
        colItems.cr.removeFooter()
    }
    
    func stopRefreshLoadingMore() {
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
        stopRefreshLoadingMore()
        self.data = data
        colItems.reloadData()
        setupLoadMore(dataCount: data.count)
        emptyView.isHidden = !self.data.isEmpty
        colItems.scrollToSection(0)
    }
    
    func didFailGetItems() {
        stopRefreshLoadingMore()
        Dialog.showApiError(tryAgain: { self.getProducts() })
    }
    
    func didSuccessLoadMore(data: [ProductResponse]) {
        stopRefreshLoadingMore()
        setupLoadMore(dataCount: data.count)
        self.data.append(contentsOf: data)
        colItems.reloadData()
    }
    
    func didFailLoadMore() {
        stopRefreshLoadingMore()
        Dialog.showApiError(tryAgain: { self.getProducts() })
    }
}

extension ItemSearchVC: ItemCellProtocol {
    
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

extension ItemSearchVC: CartDialogProtocol {
    
    func cartDialog(onSelect data: ProductCart) {
        router?.routeToDetail(heroIdImage: "", data: data.toProductResponse())
    }
    
    func cartDialog(viewCart price: Int) { router?.routeToCart() }
    func cartDialog(checkOut price: Int) { router?.routeToCheckOut() }
}

extension ItemSearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
}

