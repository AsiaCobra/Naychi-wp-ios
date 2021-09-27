//
//  ReviewCell.swift
//  stationery
//
//  Created by Codigo NOL on 15/01/2021.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    func setData(_ data: ReviewResponse) {
        imgProfile.setImage(data.reviewerAvatarUrls?.medium ?? "")
        lblRating.text = "\(data.rating ?? 0)"
        lblName.text = data.reviewer
        lblDate.text = data.dateString
        lblComment.text = data.comment
    }
}
