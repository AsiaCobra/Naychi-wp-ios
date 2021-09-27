//
//  ReviewCommentView.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import UIKit

protocol ReviewCommentViewProtocol: AnyObject {
    func reviewComment(onTapped data: ReviewResponse)
}

class ReviewCommentView: UIView {

    @IBOutlet weak var colReview: UICollectionView!
    
    var data: [ReviewResponse?] = []
    
    weak var delegate: ReviewCommentViewProtocol?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    // MAKR: Setup
    fileprivate func setupView() {
        guard let v = loadViewFromNib() else { return }
        v.frame = bounds
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initView()
        addSubview(v)
        self.backgroundColor = .clear
    }
    
    fileprivate func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    func initView() {
        colReview.delegate = self
        colReview.dataSource = self
        colReview.register(nib: CommentCell.className)
        colReview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setData(_ data: [ReviewResponse?]) {
        self.data = data.count > 5 ? Array(data.prefix(5)) : data
        colReview.reloadData()
    }
}

extension ReviewCommentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(CommentCell.self, index: indexPath)
        cell.setData(data[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let review = data[indexPath.item] {
            delegate?.reviewComment(onTapped: review)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
