//
//  CommentCell.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import UIKit

class CommentCell: UICollectionViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblRating: LanguageLabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: LanguageLabel!
    @IBOutlet weak var lblComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(_ data: ReviewResponse?) {
        
        guard let review = data else {
            imgProfile.setImage("")
            lblRating.text = "-"
            lblName.text = "-----"
            lblDate.text = "----"
            lblComment.text = "----------"
            return
        }
        
        imgProfile.setImage(review.reviewerAvatarUrls?.medium ?? "")
        let rating = "\(review.rating ?? 0)"
        lblRating.changeLanguage(AppUtil.shared.currentLanguage,
                                 title: AppUtil.shared.currentLanguage == .myanmar ? rating.mmNumbers() : rating)
        lblName.text = review.reviewer
        lblDate.changeLanguage(AppUtil.shared.currentLanguage,
                               title: AppUtil.shared.currentLanguage == .myanmar ? review.dateStringMm : review.dateString)
        lblComment.text = review.comment
    }
}
