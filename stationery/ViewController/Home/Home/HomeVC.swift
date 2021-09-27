//  
//  HomeVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit
import Hero

protocol HomeDisplayLogic: AnyObject {
    func didSuccessProducts(section: SectionHome)
}

class HomeVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.home
    
    var router: (NSObjectProtocol & HomeRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var tblMain: UITableView!

    var vm: HomeVM?
    var sections: [SectionHome] = []
    var inThisView = true
    
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
        let router = HomeRouter()
        let vm = HomeVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navigationController?.hero.isEnabled = true
        self.hero.isEnabled = true
        
        sections = vm?.getSection() ?? []
        
        tblMain.register(nibs: [BannerCell.className, BrandsCell.className, CategoriesCell.className, HomeProductCell.className])
        tblMain.registerHeaderFooter(nib: HomeSectionHeader.className)
        tblMain.delegate = self
        tblMain.dataSource = self
        tblMain.separatorStyle = .none
        tblMain.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tblMain.reloadData()
        
        navView?.tblItems = tblMain
        vm?.getProducts(sections: sections)
        
        self.mainHeader?.onLanguageChange = { _ in
            self.tblMain.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enableDrawerPanGesture()
        inThisView = true
        tblMain.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        disableDrawerPanGesture()
        inThisView = false
    }
}

extension HomeVC: HomeProductCellProtocol, HomeSectionHeaderProtocol, CategoriesCellProtocol, BrandsCellProtocol {
    func homeProductCell(onTappedCart section: Int, itemIndex: Int, data: ProductResponse) {
        if !checkUserLogin() { return }
        ShopUtil.saveToCart(data, quantity: 1)
        CartDialog.show(self)
    }
    
    func homeProductCell(onTappedItem section: Int, itemIndex: Int, data: ProductResponse) {
        router?.routeToDetail(heroIdImage: "\(data.name ?? "")\(itemIndex)", data: data)
    }
    
    func homeProductCell(onTappedFav section: Int, itemIndex: Int, data: ProductResponse) {
        if !checkUserLogin() { return }
        guard let product = sections[section].products[itemIndex],
              let productCell = tblMain.cellForRow(at: IndexPath(row: 0, section: section)) as? HomeProductCell else {
            return
        }
        product.isFavorite = !product.isFavorite
        if product.isFavorite { ShopUtil.saveToFav(data) }
        else { ShopUtil.deleteFav("\(data.id ?? 0)") }
        
        productCell.colItems.reloadItems(at: [IndexPath(item: itemIndex, section: 0)])
    }
    
    func categoriesCell(onSelect data: ProductCategory) {
        router?.routeToSearch(catId: "\(data.id)")
    }
    
    func homeSectionHeader(viewAll type: HomeSectionType, args: Args?, title: String) {
        
        switch type {
        case .brand:
            router?.routeToBrands(args: args)
        case .category:
            router?.routeToCategories(args: args)
        case .items:
            router?.routToProducts(args: args, title: title)
        default: break
        }
    }
    
    func brandsCell(onSelect data: Brand) {
        router?.routeToBrandItems(brand: data)
    }
}

extension HomeVC: CartDialogProtocol {
    
    func cartDialog(onSelect data: ProductCart) {
        router?.routeToDetail(heroIdImage: "", data: data.toProductResponse())
    }
    
    func cartDialog(viewCart price: Int) { router?.routeToCart() }
    func cartDialog(checkOut price: Int) { router?.routeToCheckOut() }
}


extension HomeVC: HomeDisplayLogic {
    func didSuccessProducts(section: SectionHome) {
        if !inThisView { return }
        tblMain.reloadSections(IndexSet(integer: section.index), with: .fade)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section].type {
        case .banner:
            let cell = tableView.deque(BannerCell.self)
            cell.setData(sections[indexPath.section].images)
            return cell
        case .brand:
            let cell = tableView.deque(BrandsCell.self)
            cell.setData(sections[indexPath.section].brands, cellWidth: sections[indexPath.section].cellItemWidth)
            cell.delegate = self
            return cell
        case .category:
            let cell = tableView.deque(CategoriesCell.self)
            cell.delegate = self
            return cell
        case .items:
            let cell = tableView.deque(HomeProductCell.self)
            cell.setData(sections[indexPath.section].products, cellWidth: sections[indexPath.section].cellItemWidth,
                         section: indexPath.section)
            cell.delegate = self
            return cell
        
        case .none: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !sections[section].title.isEmpty {
            let header = tableView.dequeHeaderFooter(HomeSectionHeader.self)
            header.setData(sections[section].title, titleMm: sections[section].titleMm, sectionType: sections[section].type, args: sections[section].args)
            header.delegate = self
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cellHeight
    }
}
