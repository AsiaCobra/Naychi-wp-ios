//  
//  BrandVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/01/2021.
//

import UIKit

protocol BrandDisplayLogic: AnyObject {
    func didSuccessBrands(data: [Brand])
    func didFailBrands()
}

class BrandVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.home
    
    var router: (NSObjectProtocol & BrandRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var colBrand: UICollectionView!

    var vm: BrandVM?
    var data: [Brand] = []
    var args: Args?
    
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
        let router = BrandRouter()
        let vm = BrandVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        navBarEffect = false
        navBar?.setEffect(1)
        
        colBrand.delegate = self
        colBrand.dataSource = self
        colBrand.register(nib: ColBrandCell.className)
        colBrand.register(nib: AdsBannerCell.className)
        
        colBrand.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        colBrand.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        vm?.getBrands()
    }
}

extension BrandVC: BrandDisplayLogic {
    func didSuccessBrands(data: [Brand]) {
        self.data = data
        colBrand.reloadData()
    }
    func didFailBrands() {
        Dialog.showApiError(tryAgain: {
            self.vm?.getBrands()
        }, cancelAble: true)
    }
}

extension BrandVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        let cell = collectionView.deque(ColBrandCell.self, index: indexPath)
        cell.setData(data[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        router?.routeToBrandItems(brand: data[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let cellHeight = ((collectionView.frame.width*3)/11) + 40// 11:3
            return CGSize(width: collectionView.frame.width, height: cellHeight)
        }
        
        let extraWidth =  (horiPadding*2) + cellPadding
        let cellWidth = (collectionView.frame.width - extraWidth)/2
        return CGSize(width: cellWidth, height: (cellWidth*2)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? .zero : UIEdgeInsets(top: 0, left: horiPadding, bottom: 0, right: horiPadding)
    }
}

