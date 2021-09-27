//  
//  CategoryVC.swift
//  stationery
//
//  Created by Codigo NOL on 06/01/2021.
//

import UIKit

protocol CategoryDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class CategoryVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.home
    
    var router: (NSObjectProtocol & CategoryRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var colCategories: UICollectionView!

    var vm: CategoryVM?
    var data: [ProductCategory] = []
    
    let cellPadding: CGFloat = 10
    let horiPadding: CGFloat = 20
    
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
        let router = CategoryRouter()
        let vm = CategoryVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        navBarEffect = false
        navBar?.setEffect(1)
        
        data = ShopUtil.getCategories(sort: true)
        colCategories.delegate = self
        colCategories.dataSource = self
        colCategories.register(nib: CategorySquareCell.className)
        colCategories.register(nib: AdsBannerCell.className)
        
        colCategories.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        colCategories.reloadData()
        
//        var n: [String] = []
//        data.forEach {
//            n.append($0.name ?? "")
//            print("case \"\($0.name ?? "")\": cat.nameMM = \"\"")
//        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension CategoryVC: CategoryDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}

extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        let cell = collectionView.deque(CategorySquareCell.self, index: indexPath)
        cell.setData(data[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        router?.routeToSearch(catId: "\(data[indexPath.item].id)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let cellHeight = ((collectionView.frame.width*3)/11) + 40// 11:3
            return CGSize(width: collectionView.frame.width, height: cellHeight)
        }
        
        let extraWidth =  (horiPadding*2) + cellPadding
        let cellSize = (collectionView.frame.width - extraWidth)/2
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? .zero : UIEdgeInsets(top: 0, left: horiPadding, bottom: 0, right: horiPadding)
    }
}

