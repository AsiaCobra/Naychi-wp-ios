//
//  HomeSectionHeader.swift
//  stationery
//
//  Created by Codigo NOL on 05/01/2021.
//

import UIKit

protocol HomeSectionHeaderProtocol: AnyObject {
    func homeSectionHeader(viewAll type: HomeSectionType, args: Args?, title: String)
}

class HomeSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var btnViewAll: LanguageButton!
    
    weak var delegate: HomeSectionHeaderProtocol?
    
    var sectionType = HomeSectionType.none
    var title = ""
    var args: Args?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
        btnViewAll.addTarget(self, action: #selector(self.onTappedViewAll), for: .touchUpInside)
    }
    
    func setData(_ title: String, titleMm: String, sectionType: HomeSectionType, args: Args?) {
        self.sectionType = sectionType
        self.title = title
        self.args = args
        self.contentView.backgroundColor = sectionType == .brand ? Color.Gray.instance() : .white
        
        lblTitle.setUp(textMyanmar: titleMm, textEnglish: title)
        lblTitle.changeLanguage(AppUtil.shared.currentLanguage)
        btnViewAll.changeLanguage(AppUtil.shared.currentLanguage)
    }
    
    @objc func onTappedViewAll() {
        delegate?.homeSectionHeader(viewAll: sectionType, args: args, title: title)
    }
}
