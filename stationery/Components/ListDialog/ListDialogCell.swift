//
//  ListDialogCell.swift
//  Component
//
//  Created by Codigo NOL on 21/01/2020.
//  Copyright © 2020 Codigo. All rights reserved.
//

import UIKit

class ListDialogCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var imgArrow: UIImageView!
//    @IBOutlet weak var imgSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTitle(title: String, align: ListItemAlign, showArrow: Bool, isSelected: Bool) {
        switch align {
        case .left: lblTitle.textAlignment = .left
        case .centre: lblTitle.textAlignment = .center
        case .right: lblTitle.textAlignment = .right
        }
        lblTitle.font = Font.Bold.of(size: 15)
        lblTitle.text = title
//        imgArrow.isHidden = !showArrow
//        imgSelected.isHidden = !isSelected
    }
}
