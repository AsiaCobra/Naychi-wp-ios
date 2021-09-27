//  
//  ItemDetailVC.swift
//  stationery
//
//  Created by Codigo NOL on 24/12/2020.
//

import UIKit
import Hero
import SwiftyUserDefaults
import Cosmos

protocol ItemDetailDisplayLogic: AnyObject {
    func didSuccessRelatedProduct(data: ProductResponse, index: Int)
    func didFailedRelatedProduct()
    func didSuccesReview(data: [ReviewResponse], product: ProductResponse)
    func didSuccessCurrentTime()
    func didFailedCurrentTime()
}

class ItemDetailVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.items
    
    var router: (NSObjectProtocol & ItemDetailRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageSlider: ImageSliderView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: LanguageLabel!
    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var lblHighlightTitle: LanguageLabel!
    @IBOutlet weak var lblHighlight: UILabel!
    
    @IBOutlet weak var stackQuantity: UIStackView!
    @IBOutlet weak var lblDiscountTitle: LanguageLabel!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var stackDiscount: UIStackView!
    
    @IBOutlet weak var lblQuantity: LanguageLabel!
    @IBOutlet weak var lblQuantityPrice: LanguageLabel!
    
    @IBOutlet weak var quantityView: QuantityView!
    
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var lblFavorite: LanguageLabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblCategoriesTitle: LanguageLabel!
    @IBOutlet weak var lblCategories: LabelHyperLink!
    
    @IBOutlet weak var colRelated: UICollectionView!
    @IBOutlet weak var colRelatedHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnBuy: UIButton!
    
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var lblStar: LanguageLabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var reviewCommentViews: ReviewCommentView!
    @IBOutlet weak var lblReview: LanguageLabel!
    @IBOutlet weak var btnReview: LanguageButton!
    @IBOutlet weak var btnReviewSeeAll: LanguageButton!
    
    @IBOutlet weak var lblRelatedTitle: LanguageLabel!

    var vm: ItemDetailVM?
    var data: ProductResponse?
    var heroIdImage: String = ""
    var cellWidth: CGFloat = 0
    var cellPadding: CGFloat = 10
    var relatedItems: [ProductResponse?] = []
    var timerRelated: Timer?
    var viewAppeared = false
    var reviews: [ReviewResponse] = []
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        destoryTimer()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let router = ItemDetailRouter()
        let vm = ItemDetailVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.hero.isEnabled = true
        imageSlider.hero.id = heroIdImage
        
        showhideAction(false)
        
        scrollView.delegate = self
        
        setUpImages()
        
        navBar?.setTitle(data?.name ?? "")
        lblName.text = data?.name
//        lblPrice.text = "\(ShopUtil.getPrice(price, quantity: 0).toCurrency() ?? "0") Ks"
        lblPrice.changeLanguage(AppUtil.shared.currentLanguage,
                                title: AppUtil.shared.currentLanguage == .myanmar ? data?.priceMm : data?.priceEng)
        
        lblHighlightTitle.changeLanguage(AppUtil.shared.currentLanguage)
        var highlight = data?.shortDescription?.htmlToString ?? ""
        highlight = highlight.replacingOccurrences(of: "\n\n", with: "\n")
        lblHighlight.text = highlight.trimmingCharacters(in: .whitespacesAndNewlines)
         
        lblDiscountTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblQuantity.changeLanguage(AppUtil.shared.currentLanguage)
        lblQuantityPrice.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblFavorite.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblCategoriesTitle.changeLanguage(AppUtil.shared.currentLanguage)
        var categories: [String] = []
        data?.categories?.forEach {
            if let cat = $0.name { categories.append(cat) }
        }
        
        lblCategories.setHyperLink(fullText: categories.joined(separator: ", "), hyperLinkText: categories, urlString: categories,
                                   textColor: Color.DarkGray.instance(), hyperLinkColor: Color.DarkGray.instance(), textFont: Font.Bold.of(size: 16),
                                   linkFont: Font.Bold.of(size: 16), underLineForLink: false, textAlign: .left, lineSpacing: 0, delegate: self)
        
        lblReview.changeLanguage(AppUtil.shared.currentLanguage)
        btnReviewSeeAll.changeLanguage(AppUtil.shared.currentLanguage)
        btnReview.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblRelatedTitle.changeLanguage(AppUtil.shared.currentLanguage)
        relatedItems = .init(repeating: nil, count: data?.relatedIds?.count ?? 0)
        vm?.productIds = data?.relatedIds ?? []
            
        cellWidth = ((UIScreen.main.bounds.width - 40) - cellPadding - 40)/2
        colRelatedHeight.constant = (cellWidth*9)/5 //ratio 5:9
        
        colRelated.delegate = self
        colRelated.dataSource = self
        colRelated.register(nib: ItemCell.className)
        colRelated.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        setUpReview()
        
        btnFavorite.addTarget(self, action: #selector(self.onTappedFav), for: .touchUpInside)
        btnCart.addTarget(self, action: #selector(self.onTappedCart), for: .touchUpInside)
        btnBuy.addTarget(self, action: #selector(self.onTappedBuy), for: .touchUpInside)
        btnReview.addTarget(self, action: #selector(self.onTappedReview), for: .touchUpInside)
        btnReviewSeeAll.addTarget(self, action: #selector(self.onTappedReviewSeeAll), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        vm?.getCurrentTime()
        vm?.getRelatedProduct()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewAppeared { return }
        viewAppeared = false
        setStrechyView(imageSlider)
    }
    
    func setUpReview() {
        reviewCommentViews.delegate = self
        starsView.settings.fillMode = .precise
        lblReview.isHidden = false
        reviewView.isHidden = true
        btnReviewSeeAll.isHidden = true
        if let productId = data?.id {
            getReviews(productId: "\(productId)")
        }
    }
    
    func setUpImages() {
        guard let images = data?.images else { return }
        var img: [String] = []
        images.forEach { img.append($0.src ?? "") }
        imageSlider.setUpData(images: img)
    }
    
    @objc func onTappedFav() {
        if !checkUserLogin() { return }
        guard let d = data else { return }
        d.isFavorite = !d.isFavorite
        
        if d.isFavorite { ShopUtil.saveToFav(d) }
        else { ShopUtil.deleteFav("\(d.id ?? 0)") }
        
        imgFavorite.image = UIImage(named: d.isFavorite ? "iconheartfill" : "iconheartempty")
    }
    
    @objc func onTappedCart() {
        if !checkUserLogin() { return }
        guard let d = data else { return }
        ShopUtil.saveToCart(d, quantity: quantityView.getQuantity())
        CartDialog.show(self)
    }
    
    @objc func onTappedBuy() {
        
    }
    
    @objc func onTappedReview() {
        if !checkUserLogin() { return }
        router?.routeToReviewSubmit()
    }
    
    @objc func onTappedReviewSeeAll() {
        router?.routeToReviews()
    }
    
    func showhideAction(_ show: Bool) {
        btnCart.superview?.superview?.isHidden = !show
        stackQuantity.isHidden = !show
        
        if show { displayDiscount() }
    }
    
    func displayDiscount() {
        let discounts = vm?.getDiscount(normalPrice: data?.priceNormal, brands: data?.brands) ?? []
        if discounts.isEmpty {
            lblDiscountTitle.isHidden = true
            discountView.isHidden = true
        } else {
            stackDiscount.subviews.forEach { if $0.className == DiscountView.className { $0.removeFromSuperview() } }
            lblDiscountTitle.isHidden = false
            discountView.isHidden = false
            discounts.forEach({ dis in
                let disView = DiscountView()
                disView.setData(dis)
                stackDiscount.addArrangedSubview(disView)
                disView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            })
        }
    }
}

extension ItemDetailVC: ReviewSubmitProtocol, ReviewCommentViewProtocol {
    func reviewSubmit(onSubmit data: ReviewResponse) {
        getReviews(productId: "\(data.productId ?? 0)")
    }
    
    func reviewComment(onTapped data: ReviewResponse) {
        router?.routeToReviewDetail(review: data)
    }
}

extension ItemDetailVC: CartDialogProtocol {
    
    func cartDialog(onSelect data: ProductCart) {
        if data.id == "\(self.data?.id ?? 0)" { return }
        router?.routeToDetail(heroIdImage: "", data: data.toProductResponse())
    }
    
    func cartDialog(viewCart price: Int) { router?.routeToCart() }
    func cartDialog(checkOut price: Int) { router?.routeToCheckOut() }
    
    func getReviews(productId: String) {
        lblReview.text = "Loading..."
        btnReview.isHidden = true
        vm?.getReviews(productId)
    }
}

extension ItemDetailVC: ItemDetailDisplayLogic {
    
    func didSuccesReview(data: [ReviewResponse], product: ProductResponse) {
        
        self.reviews = data
        
        lblReview.changeLanguage(AppUtil.shared.currentLanguage)
        btnReview.isHidden = false
        btnReviewSeeAll.isHidden = true
        
        if product.ratingCount ?? 0 <= 0 {
            lblReview.isHidden = false
            reviewView.isHidden = true
            return
        }
        
        btnReviewSeeAll.isHidden = false
        lblReview.isHidden = true
        reviewView.isHidden = false

        let rating = Double(product.averageRating ?? "0")?.roundToPlaces(1) ?? 0
        lblStar.changeLanguage(AppUtil.shared.currentLanguage,
                               title: AppUtil.shared.currentLanguage == .myanmar ? "\(rating)".mmNumbers() : "\(rating)")
        starsView.rating = rating
        
        reviewCommentViews.setData(data)
    }
    
    func didSuccessRelatedProduct(data: ProductResponse, index: Int) {
        relatedItems[index] = data
        colRelated.reloadItems(at: [IndexPath(item: index, section: 0)])
        vm?.getRelatedProduct()
    }
    
    func didFailedRelatedProduct() {
        if timerRelated != nil { return }
        timerRelated = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.vm?.getRelatedProduct()
            self.destoryTimer()
        })
    }
    
    func destoryTimer() {
        if timerRelated == nil { return }
        timerRelated?.invalidate()
        timerRelated = nil
    }
    
    func didFailedCurrentTime() {
        Dialog.showApiError(tryAgain: {
            self.vm?.getCurrentTime()
        }, cancelAble: true)
    }
    
    func didSuccessCurrentTime() {
        showhideAction(true)
    }
}

extension ItemDetailVC: LabelHyperLinkProtocol {
    func labelHyperLink(onTappedUrlInLabel urlString: String) {
        print(urlString)
    }
}

extension ItemDetailVC: ItemCellProtocol {
    func itemCell(onTappedCart indexPath: IndexPath, data: ProductResponse) {
        if !checkUserLogin() { return }
        ShopUtil.saveToCart(data, quantity: 1)
        CartDialog.show(self)
    }
    
    func itemCell(onTappedItem indexPath: IndexPath, data: ProductResponse) {
        router?.routeToDetail(heroIdImage: "\(self.data?.name ?? "")\(relatedItems[indexPath.item]?.name ?? "")\(indexPath.item)",
                              data: data)
    }
    
    func itemCell(onTappedFav indexPath: IndexPath, data: ProductResponse) {
        if !checkUserLogin() { return }
        guard let item = relatedItems[indexPath.item] else { return }
        item.isFavorite = !item.isFavorite
        
        if item.isFavorite { ShopUtil.saveToFav(data) }
        else { ShopUtil.deleteFav("\(data.id ?? 0)") }
        
        colRelated.reloadItems(at: [indexPath])
    }
}
    
extension ItemDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(ItemCell.self, index: indexPath)
        cell.imgItem.hero.id = "\(data?.name ?? "")\(relatedItems[indexPath.item]?.name ?? "")\(indexPath.item)"
        cell.setData(indexPath: indexPath, data: relatedItems[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
}
