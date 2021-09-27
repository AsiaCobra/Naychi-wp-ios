//
//  OrderHistoryCell.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import UIKit

class OrderHistoryCell: UITableViewCell {

    @IBOutlet weak var lblOrderNo: LanguageLabel!
    @IBOutlet weak var lblDate: LanguageLabel!
    @IBOutlet weak var lblTotalTop: LanguageLabel!
    @IBOutlet weak var lblPaymentMethod: LanguageLabel!
    @IBOutlet weak var lblStatus: LanguageLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    func setUpData(data: OrderHistory) {
        let lan = AppUtil.shared.currentLanguage
        lblOrderNo.changeLanguage(lan, title: lan == .myanmar ? data.number?.mmNumbers() : data.number)
        let date = data.dateCreated?.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss", setLocalTimeZone: true) ?? Date()
        let month = date.toString("MMMM", setLocalTimeZone: true)
        let dateNo = date.toString("d, yyyy", setLocalTimeZone: true)
        let dateString = lan == .myanmar ? "\(month.mmMonth()) \(dateNo.mmNumbers())" : "\(month) \(dateNo)"
        lblDate.changeLanguage(lan, title: dateString)
        
        let methodMm = PaymentType.getTypeMm(data.paymentMethodTitle?.lowercased() ?? "")
        lblPaymentMethod.changeLanguage(lan, title: lan == .myanmar ? methodMm.title : data.paymentMethodTitle)
        
        
//        pending, processing, on-hold, completed, cancelled, refunded, and failed.
        lblStatus.text = data.status?.capitalized
        switch OrderStatus(rawValue: data.status ?? "") {
        case .pending, .processing, .onHold: lblStatus.textColor = Color.JungleGreen.instance()
        case .completed: lblStatus.textColor = Color.Blue.instance()
        case .cancelled, .refunded, .failed: lblStatus.textColor = Color.Red.instance()
        case .none: lblStatus.textColor = Color.Black.instance()
        }
        
        lblTotalTop.changeLanguage(lan, title: AppUtil.getPriceString(price: data.total?.toInt ?? 0))
    }
    
}
