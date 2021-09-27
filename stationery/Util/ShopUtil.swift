//
//  ShopUtil.swift
//  stationery
//
//  Created by Codigo NOL on 22/12/2020.
//

import Foundation
import RealmSwift

enum ItemSort: String {
    case normal = "Default sorting"
    case popular = "Sort by popularity"
    case rating = "Sort by average rating"
    case latest = "Sort by latest"
    case priceLow = "Sort by price: low to high"
    case priceHight = "Sort by price: high to low"
    
    func getMm() -> String {
        switch self {
        case .normal: return ""
        case .popular: return ""
        case .rating: return ""
        case .latest: return ""
        case .priceLow: return ""
        case .priceHight: return ""
        }
    }
}

enum ItemPrice: String {
    case pAny = "Any price"
    case p50 = "50 Ks - 100 Ks"
    case p100 = "100 Ks - 200 Ks"
    case p200 = "200 Ks - 400 Ks"
    case p400 = "400 Ks - 800 Ks"
    case p800 = "800 Ks+"
    
    func getMm() -> String {
        switch self {
        case .pAny: return "စျေးနှုန်းအားလုံး"
        case .p50: return "၅၀ ကျပ် - ၁၀၀ ကျပ်"
        case .p100: return "၁၀၀ ကျပ် - ၂၀၀ ကျပ်"
        case .p200: return "၂၀၀ ကျပ် - ၄၀၀ ကျပ်"
        case .p400: return "၄၀၀ ကျပ် - ၈၀၀ ကျပ်"
        case .p800: return "၈၀၀ ကျပ်+"
        }
    }
    
    func getMinMax() -> (min: Int?, max: Int?) {
        switch self {
        case .pAny: return (min: nil, max: nil)
        case .p50: return (min: 50, max: 100)
        case .p100: return (min: 100, max: 200)
        case .p200: return (min: 200, max: 400)
        case .p400: return (min: 400, max: 800)
        case .p800: return (min: 800, max: nil)
        }
    }
}

class ShopUtil {
    
    // MARK: Price
//    static let discountPercent1 = 95
//    static let discountPercent2 = 90
//    
//    public static func hasDisscount(_ price: Int, quantity: Int) -> Bool {
//        if quantity < 6 { return false }
//        return true
//    }
//    
//    public static func getPrice(_ price: Int, quantity: Int, withDiscount: Bool = true) -> Int {
//        if quantity < 6 { return price }
//        var precent = 100
//        if withDiscount { precent = quantity >= 12 ? ShopUtil.discountPercent2 : ShopUtil.discountPercent1 }
//        return (price*precent)/100
//    }
//    
//    public static func getDiscount(_ price: Int, quantity: Int) -> Int {
//        if quantity < 6 { return 0 }
//        let precent = quantity >= 12 ? 100 - ShopUtil.discountPercent2 : 100 - ShopUtil.discountPercent1
//        return (price*precent)/100
//    }
    
    public static func isDiscountValid(discountEndDate: String?) -> Bool {
        if let disEnd = discountEndDate, !disEnd.isEmpty,
           let endDate = disEnd.toDate(dateFormat: DateFormat.type1.toString(), setLocalTimeZone: false) {
            return Constant.AppInfo.currentDate <= endDate
        } else {
            return true
        }
    }
    
    public static func getDiscountRule(brand: String) -> Discount? {
        let rules =  Constant.AppInfo.discountRule?.items.filter { $0.id == brand }
        return isDiscountValid(discountEndDate: rules?.first?.value.discountEndDate) ? rules?.first?.value : nil
    }
    
    public static func getDiscountRange(rule: Discount, quantity: Int) -> DiscountRange? {
        
        if !isDiscountValid(discountEndDate: rule.discountEndDate) { return nil }
        
        let ranges = rule.discountRanges?.sorted { $0.startRange.toInt ?? 0 > $1.startRange.toInt ?? 0 }
        for range in ranges ?? [] {
            if let sr = range.startRange.toInt, quantity >= sr { return range }
        }
        return nil
    }
    
    public static func getDiscountRange(brand: String, quantity: Int) -> DiscountRange? {
        guard let rule = ShopUtil.getDiscountRule(brand: brand),
              isDiscountValid(discountEndDate: rule.discountEndDate) else { return nil }
        
        let ranges = rule.discountRanges?.sorted { $0.startRange.toInt ?? 0 > $1.startRange.toInt ?? 0 }
        for range in ranges ?? [] {
            if let sr = range.startRange.toInt, quantity >= sr { return range }
        }
        return nil
    }
    
    public static func getDiscountType(brand: String, quantity: Int) -> DiscountType? {
        guard let rule = ShopUtil.getDiscountRule(brand: brand) else { return nil }
        guard let range = ShopUtil.getDiscountRange(rule: rule, quantity: quantity) else { return nil }
        return DiscountType.init(rawValue: range.disType)
    }
    
    public static func getPrice(brand: String, price: Int, quantity: Int) -> Int {
        guard let rule = ShopUtil.getDiscountRule(brand: brand), isDiscountValid(discountEndDate: rule.discountEndDate) else { return price }
        guard let range = ShopUtil.getDiscountRange(rule: rule, quantity: quantity) else { return price }
        guard let type = DiscountType.init(rawValue: range.disType) else { return price }
        guard let discount = range.disValue.toInt else { return price }
        
        switch type {
        case .fixed: return price
        case .percentage:
            let percent = 100 - discount
            return (price*percent) / 100
        }
    }
    
    public static func getPrice(type: DiscountType, discount: Int, price: Int, quantity: Int) -> Int {        
        switch type {
        case .fixed: return (price*quantity) - discount
        case .percentage:
            let percent = 100 - discount
            let total = price * quantity
            return (total*percent) / 100
        }
    }
    
    public static func getDiscount(brand: String, price: Int, quantity: Int) -> Int {
        guard  let range = ShopUtil.getDiscountRange(brand: brand, quantity: quantity) else {
            return 0
        }
        
        guard let type = DiscountType.init(rawValue: range.disType) else { return 0 }
        
        switch type {
        case .fixed: return range.disValue.toInt ?? 0
        case .percentage:
            let percent = range.disValue.toInt ?? 0
            let discount = (price*percent)/100
            return discount*quantity
        }
    }
    
    // MARK: Cart
    public static func saveToCart(_ data: ProductResponse, quantity: Int) {
        var carts: [ProductCart] = []
        let cart = ProductCart()
        cart.setData(data: data, quantity: quantity)
        
        //no cart found
        guard let savedCart: [ProductCart] = ProductCart.getList() else {
            carts.append(cart)
            carts.save(updatePolicy: .all)
            return
        }
        
        //product found in cart
        let p = savedCart.filter { $0.id == "\(data.id ?? 0)" }.first
        if let product = p {
            product.saveValue { product.quantity += quantity }
            return
        }
        
        //no product found in cart
        savedCart.forEach { carts.append($0) }
        carts.append(cart)
        carts.save(updatePolicy: .all)
        
    }
    
    public static func getSavedCart() -> [ProductCart] {
        var carts: [ProductCart] = []
        if let savedCart: [ProductCart] = ProductCart.getList() {
            savedCart.forEach { carts.append($0) }
        }
        return carts
    }
    
    
    public static func deleteCart(_ id: String) {
        if let savedCart: [ProductCart] = ProductCart.getList() {
            savedCart.forEach {
                if $0.id == id {
                    $0.delete()
                    return
                }
            }
        }
    }
    
    public static func clearCart() {
        if let savedCart: [ProductCart] = ProductCart.getList() {
            savedCart.delete()
        }
    }
    
    public static func saveCartTotal(subTotal: Int, discount: Int, total: Int) {
        guard let saved: CartTotal = CartTotal.get() else {
            let cart = CartTotal()
            cart.subTotal = subTotal
            cart.discount = discount
            cart.total = total
            cart.save(updatePolicy: .all)
            return
        }
        saved.saveValue {
            saved.subTotal = subTotal
            saved.discount = discount
            saved.total = total
        }
    }
    
    public static func saveCartTotal(state: String?, township: String?) {
        guard let saved: CartTotal = CartTotal.get() else {
            let cart = CartTotal()
            cart.state = state
            cart.township = township
            cart.save(updatePolicy: .all)
            return
        }
        saved.saveValue {
            saved.state = state
            saved.township = township
        }
    }
    
    public static func getCartTotal() -> (subTotal: Int, discount: Int, total: Int) {
        let items = ShopUtil.getSavedCart()
        var discount = 0
        var subTotal = 0
        
        items.forEach {
            subTotal += ($0.price.value ?? 0) * $0.quantity
//            discount += ShopUtil.getDiscount($0.price.value ?? 0, quantity: $0.quantity) * $0.quantity
            discount += ShopUtil.getDiscount(brand: $0.brand ?? "", price: $0.price.value ?? 0, quantity: $0.quantity)
            
        }
        
        return (subTotal: subTotal, discount: discount, total: subTotal - discount)
    }
    
    // MARK: Favorite
    public static func setFav(_ data: [ProductResponse]) -> [ProductResponse] {
        let savedFavs: [ProductFav] = ShopUtil.getSavedFav()
        
        if savedFavs.isEmpty { return data }
        
        savedFavs.forEach { fav in
            data.forEach { product in
                if fav.id == "\(product.id ?? 0)" { product.isFavorite = true }
            }
        }
        
        return data
    }
    
    public static func saveToFav(_ data: ProductResponse) {
        var favs: [ProductFav] = []
        let fav = ProductFav()
        fav.setData(data: data)
        
        //no fav found
        guard let savedFav: [ProductFav] = ProductFav.getList() else {
            favs.append(fav)
            favs.save(updatePolicy: .all)
            return
        }
        
        //product found in fav
        let p = savedFav.filter { $0.id == "\(data.id ?? 0)" }.first
        if let _ = p { return }
        
        //no product found in fav
        savedFav.forEach { favs.append($0) }
        favs.append(fav)
        favs.save(updatePolicy: .all)
        
    }
    
    public static func getSavedFav() -> [ProductFav] {
        var favs: [ProductFav] = []
        if let savedFav: [ProductFav] = ProductFav.getList() {
            savedFav.forEach { favs.append($0) }
        }
        return favs
    }
    
    
    public static func deleteFav(_ id: String) {
        if let savedFav: [ProductFav] = ProductFav.getList() {
            savedFav.forEach {
                if $0.id == id {
                    $0.delete()
                    return
                }
            }
        }
    }
    
    public static func clearFav() {
        if let savedFav: [ProductFav] = ProductFav.getList() {
            savedFav.delete()
        }
    }
    
    // MARK: Region
    public static func saveRegions() {
        if let re: [Region] = Region.getList(), !re.isEmpty { return }
        let regions = Region.getAll()
        regions.save(updatePolicy: .all)
    }
    
    public static func getSavedRegions() -> [Region] {
        
        guard let res: [Region] = Region.getList() else {
            return []
        }
        var regions: [Region] = []
        res.forEach {
            let region = Region()
            region.id = $0.id
            region.name = AppUtil.shared.currentLanguage == .myanmar ? $0.nameMm : $0.name
            if $0.name == "Yangon" {
                region.townships = ShopUtil.getYangonTownships()
            } else {
                region.townships = AppUtil.shared.currentLanguage == .myanmar ? $0.townshipsMm : $0.townships
            }
            regions.append(region)
        }
        
        regions.sort { $0.name < $1.name }
        return regions
    }
    
    public static func getYangonTownships() -> List<String> {
        let townships = List<String>()
        Constant.AppInfo.groupTownship?.items.forEach({ (_, value) in
            value.forEach { towns in
                if let t = AppUtil.shared.currentLanguage == .english ? towns.first : towns.last { townships.append(t) }
            }
        })
        return townships
    }
    
    public static func getStates() -> [(id: String, value: String)] {
        let regions = ShopUtil.getSavedRegions()
        var states: [(id: String, value: String)] = []
        regions.forEach {
            states.append((id: $0.id, value: $0.name))
        }
        return states
    }
    
    public static func getTownships(_ state: String) -> [(id: String, value: String)] {
        let regions = ShopUtil.getSavedRegions()
        var townships: [(id: String, value: String)] = []
        for r in regions {
            if r.name == state {
                for i in 0..<r.townships.count {
                    townships.append((id: "\(i)", value: r.townships[i]))
                }
                break
            }
        }
        return townships
    }
    
    // MARK: Categories
    public static func saveCategories(_ categories: [ProductCategory]) {
        if let savedCategories: [ProductCategory] = ProductCategory.getList() {
            savedCategories.delete()
        }
        categories.save(updatePolicy: .all)
//        let cats = Translator.translate(categories)
//        cats.save(updatePolicy: .all)
    }
    
    
    public static func getCategories(sort: Bool = false, count: Int = 0) -> [ProductCategory] {
        guard let data: [ProductCategory] = ProductCategory.getList() else {
            return []
        }
        
        var categories = data
        if sort { categories.sort { $0.name ?? ""  < $1.name ?? "" } }
        return count == 0 ? categories : Array(categories.prefix(count))
    }
    
    public static func getCategoriesForPicker(selectId: String? = nil) -> (data: [(id: String?, value: String?)], selectedIndex: Int?) {
        guard let data: [ProductCategory] = ProductCategory.getList() else {
            return (data: [], selectedIndex: nil)
        }
        
        var selectedIndex: Int?
        var items: [(id: String?, value: String?)] = []
        data.forEach { items.append((id: "\($0.id)", value: $0.name)) }
        
        var sorted = items.sorted { $0.value ?? "" < $1.value ?? ""}
        sorted.insert((id: nil, value: "All Categories"), at: 0)
        
        if let select = selectId, !select.isEmpty {
            for i in 0..<sorted.count {
                if sorted[i].id == select {
                    selectedIndex = i
                    break
                }
            }
        }
        
        return (data: sorted, selectedIndex: selectedIndex)
    }
    
    // MARK: Sorting
    public static func getSorting() -> [(id: String?, value: String?)] {
        var sorts: [(id: String?, value: String?)] = []
        let s: [ItemSort] = [.normal, .popular, .rating, .latest, .priceLow, .priceHight]
        
        for i in 0..<s.count { sorts.append((id: "\(i)", value: s[i].rawValue)) }
        
        return sorts
        
    }
    
    // MARK: Price
    public static func getPrice() -> (prices: [ItemPrice], dataMm: [(id: String?, value: String?)],
                                      dataEng: [(id: String?, value: String?)]) {
        var dataMm: [(id: String?, value: String?)] = []
        var dataEng: [(id: String?, value: String?)] = []
        let p: [ItemPrice] = [.pAny, .p50, .p100, .p200, .p400, .p800]
        
        for i in 0..<p.count {
            dataMm.append((id: "\(i)", value: p[i].getMm()))
            dataEng.append((id: "\(i)", value: p[i].rawValue))
        }
        
        return (prices: p, dataMm: dataMm, dataEng: dataEng)
    }
    
    // MARK: Billing Detail
    public static func saveBillingDetail(name: String, country: String, state: String, township: String, address: String,
                                         mobile: String, email: String, id: String? = nil, forceEng: Bool = false) {
        guard let detail = ShopUtil.getBillingDetail() else {
            let newDetail = BillingDetail()
            newDetail.name = name
            newDetail.country = "Myanmar"
            newDetail.countryMm = "မြန်မာ"
            if AppUtil.shared.currentLanguage == .myanmar && !forceEng {
                newDetail.stateMm = state
                newDetail.townshipMm = township
                newDetail.state = Region.getStateEng(state)
                newDetail.township = Region.getTownshipEng(state, township)
            } else {
                newDetail.stateMm = Region.getStateMm(state)
                newDetail.townshipMm = Region.getTownshipMm(state, township)
                newDetail.state = state
                newDetail.township = township
            }
            newDetail.streetAddress = address
            newDetail.mobile = mobile
            newDetail.email = email.isEmpty ? nil : email
            if let customerId = id { newDetail.customerId = customerId }
            newDetail.save(updatePolicy: .all)
            return
        }
        
        detail.saveValue {
            detail.name = name
            detail.country = "Myanmar"
            detail.countryMm = "မြန်မာ"
            if AppUtil.shared.currentLanguage == .myanmar && !forceEng {
                detail.stateMm = state
                detail.townshipMm = township
                detail.state = Region.getStateEng(state)
                detail.township = Region.getTownshipEng(state, township)
            } else {
                detail.stateMm = Region.getStateMm(state)
                detail.townshipMm = Region.getTownshipMm(state, township)
                detail.state = state
                detail.township = township
            }
            detail.streetAddress = address
            detail.mobile = mobile
            detail.email = email.isEmpty ? nil : email
            if let customerId = id { detail.customerId = customerId }
        }
        
    }
    
    public static func getBillingDetail() -> BillingDetail? {
        guard let detail: BillingDetail = BillingDetail.get() else {
            return nil
        }
        return detail
    }
    
    // MARK: PaymentType
    public static func getPaymentType() -> [PaymentType] {
        guard let payments: [PaymentType] = PaymentType.getList() else {
            return []
        }
        
        var pays:  [PaymentType]  = []
        for p in payments { pays.append(p) }
        pays.sort { $0.order < $1.order }
        
        return pays.filter { $0.enabled == true }
    }
    
    // MARK: Profile
    public static func getSocialAccountData() -> SocialAccountData? {
        guard let data: SocialAccountData = SocialAccountData.get() else {
            return nil
        }
        return data
    }
}

