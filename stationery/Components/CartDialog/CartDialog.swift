//
//  CartDialog.swift
//  stationery
//
//  Created by Codigo NOL on 29/12/2020.
//

import UIKit

protocol CartDialogProtocol: AnyObject {
    func cartDialog(onSelect data: ProductCart)
    func cartDialog(viewCart price: Int)
    func cartDialog(checkOut price: Int)
}

class CartDialog: BaseListDialogVC {
    
    static func show(_ delegate: CartDialogProtocol?, tapGestureDismissal: Bool = true, panGestureDismissal: Bool = true) {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.shared.keyWindow?.topViewController() else { return }
            let dialog = CartDialog(nibName: CartDialog.className, bundle: Bundle.main)
            dialog.delegate = delegate
            dialog.tapGestureDismissal = tapGestureDismissal
            dialog.panGestureDismissal = panGestureDismissal
            topVC.present(dialog, animated: true, completion: nil)
        }
    }

    public weak var delegate: CartDialogProtocol?
    public var items: [ProductCart] = []
    var totalPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calculateTableHeight()
    }
    
    func setUpData() {
        lblTitle.changeLanguage(AppUtil.shared.currentLanguage)
        items = ShopUtil.getSavedCart()
        totalItems = items.count
        cellHeight = 95
        tableExtraHeight = 105
        calculateTotalPrice()
    }
    
    func calculateTotalPrice() {
        totalPrice = 0
        items.forEach { (product) in
//            let price = ShopUtil.getPrice(product.price.value ?? 0, quantity: product.quantity)
            let price = ShopUtil.getPrice(brand: product.brand ?? "", price: product.price.value ?? 0, quantity: product.quantity)
            totalPrice += (price * product.quantity)
            
            //check fixed discount
            if let range = ShopUtil.getDiscountRange(brand:  product.brand ?? "", quantity: product.quantity),
               let type = DiscountType(rawValue: range.disType), type == .fixed {
                totalPrice -= range.disValue.toInt ?? 0
            }
        }
    }
    
    func refresh() {
        items = ShopUtil.getSavedCart()
        totalItems = items.count
        calculateTotalPrice()
        tblItems.reloadData()
        calculateTableHeight()
    }
    
    func setUpTable() {
        tblItems.register(nib: CartProductCell.className, bundle: Bundle(for: type(of: self)))
        tblItems.registerHeaderFooter(nib: CartFooter.className, bundle: Bundle(for: type(of: self)))
        tblItems.delegate = self
        tblItems.dataSource = self
        tblItems.rowHeight = cellHeight
        tblItems.estimatedRowHeight = cellHeight
        tblItems.reloadData()
    }
}

extension CartDialog: CartProductProtocol, CartFooterProtocol {
    
    func cartProduct(onDelete index: Int, data: ProductCart) {
        ShopUtil.deleteCart(data.id)
        refresh()
        if ShopUtil.getSavedCart().isEmpty { quit() }
    }
    
    func cartProduct(onSelect index: Int, data: ProductCart) {
        delegate?.cartDialog(onSelect: data)
        quit()
    }
    
    func cartFooter(viewCart price: Int) {
        quit(completion: {
            self.delegate?.cartDialog(viewCart: price)
        })
    }
    
    func cartFooter(checkOut price: Int) {
        let cart = ShopUtil.getCartTotal()
        ShopUtil.saveCartTotal(subTotal: cart.subTotal, discount: cart.discount, total: cart.total)
        quit(completion: {
            self.delegate?.cartDialog(checkOut: price)
        })
    }
}

extension CartDialog: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(CartProductCell.self)
        cell.setData(items[indexPath.row], index: indexPath)
        cell.delegate = self
        return  cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeHeaderFooter(CartFooter.self)
        footer.setData(totalPrice)
        footer.delegate = self
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 105
    }
    
}

