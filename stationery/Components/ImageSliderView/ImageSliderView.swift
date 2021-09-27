//
//  ImageSliderView.swift
//  stationery
//
//  Created by Codigo NOL on 24/12/2020.
//

import UIKit
import SKPhotoBrowser

public protocol ImageSliderViewViewProtocol: AnyObject {
    func imageSliderView(_ tappedIndex: Int?, _ tappedImageString: String)
}

public class ImageSliderView: UIView {
    
    public enum ContentSize {
        case small
        case large
    }
    
    @IBOutlet weak var colImage: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var images: [String] = []
    var imageSK: [SKPhoto] = []
    var controlPadding = 4
    var controlWidth = 20
    var cellHeight: CGFloat = 0
    var imageScaleMode: UIView.ContentMode = .scaleAspectFit
    
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
        initCustomPageControl()
        colImage.register(nib: ImageCell.className, bundle: nil)
        colImage.delegate = self
        colImage.dataSource = self
        colImage.contentInset = .zero
        if let flowLayout = colImage.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = .zero
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        cellHeight = colImage.frame.height
    }
    
    public func setUpData(images: [String], imageScaleMode: UIView.ContentMode = .scaleAspectFit) {
        self.imageScaleMode = imageScaleMode
        self.images = images
        imageSK.removeAll()
        if !images.isEmpty {
            self.images.insert(images[images.count-1], at: 0)
            self.images.append(images.first ?? "")
            
            for i in images {
                let photo = SKPhoto.photoWithImageURL(i)
                photo.shouldCachePhotoURLImage = true
                imageSK.append(photo)
            }
            colImage.reloadData()
            setCustomPageControl(totalImages: images.count, shouldScrollOnTapIndicator: true)
        } else {
            colImage.reloadData()
            setCustomPageControl(totalImages: images.count, shouldScrollOnTapIndicator: true)
        }
       
    }
    
    public func scrollToItem(index: Int, animated: Bool = false) {
         self.colImage.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
    }
    
    private func initCustomPageControl() {
        if #available(iOS 14.0, *) {
            pageControl.backgroundStyle = .minimal
            pageControl.backgroundColor = .clear
            pageControl.allowsContinuousInteraction = false
        }
        
        pageControl.pageIndicatorTintColor = Color.Black.instance().withAlphaComponent(0.4)
        pageControl.currentPageIndicatorTintColor = Color.Red.instance()
    }
    
    private func setCustomPageControl(totalImages: Int, shouldScrollOnTapIndicator: Bool) {
        
//        pageControlWidth.constant = totalImages > 0 ? CGFloat((controlWidth * totalImages) + (controlPadding * (totalImages-1))) : 0
        pageControl.numberOfPages = totalImages
        let displayIndex = getDisplayIndex(index: 0)
        if displayIndex >= 0 && displayIndex < totalImages {
//            pageControl.set(progress: getDisplayIndex(index: 0), animated: false)
            pageControl.currentPage = getDisplayIndex(index: 0)
        }
//        pageControl.enableTouchEvents = shouldScrollOnTapIndicator
    }
    
//    public func didTouch(pager: CHIBasePageControl, index: Int) {
//        colImage.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
//    }
    
    public func stretch(_ posY: CGFloat, _ height: CGFloat) {
        guard let index = getCurrentIndex(), let cell = colImage.cellForItem(at: index) as? ImageCell else { return }
        cell.strech(posY, height)
//        colImage.reloadItems(at: [index])
//        colImage.layoutIfNeeded()
    }
    
}

extension ImageSliderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(ImageCell.self, index: indexPath)
        cell.setData(images[indexPath.row], contentMode: imageScaleMode)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.parentViewController, let cell = collectionView.cellForItem(at: indexPath) as? ImageCell {
            SKPhotoBrowserOptions.displayAction = false
            SKToolbarOptions.font = Font.Regular.of(size: SKToolbarOptions.font.pointSize)
//            let browser = SKPhotoBrowser(photos: imageSK, initialPageIndex: getDisplayIndex(index: indexPath.item))
//            vc.present(browser, animated: true, completion: {})
            
            let originImage = cell.imageView.image
            let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: imageSK, animatedFromView: self)
            browser.initializePageIndex(getDisplayIndex(index: indexPath.item))
            browser.delegate = self
            vc.present(browser, animated: true, completion: {})
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let visibleIndexPath = getCurrentIndex() {
            controlIndicator(index: visibleIndexPath.item)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let index = getCurrentIndex() {
            infinateLoop(index: index.item)
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate { return }
        if let index = getCurrentIndex() {
            infinateLoop(index: index.item)
        }
    }
    
    public func getCurrentIndex() -> IndexPath? {
        let visibleRect = CGRect(origin: colImage.contentOffset, size: colImage.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return colImage.indexPathForItem(at: visiblePoint)
    }
    
    func controlIndicator(index: Int) {
//        pageControl.set(progress: getDisplayIndex(index: index), animated: true)
        pageControl.currentPage =  getDisplayIndex(index: index)
    }
    
    func getDisplayIndex(index: Int) -> Int {
        if index == 0 {
            return images.count-1
        } else if index == images.count-1 {
            return 0
        } else {
            return index-1
        }
    }
    
    func infinateLoop(index: Int) {
        if index == 0 {
            colImage.scrollToItem(at: IndexPath(item: images.count-2, section: 0), at: .centeredHorizontally, animated: false)
        } else if index == images.count-1 {
            colImage.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}

extension ImageSliderView: SKPhotoBrowserDelegate {
    public func didShowPhotoAtIndex(_ browser: SKPhotoBrowser, index: Int) {
        colImage.scrollToItem(at: IndexPath(item: index+1, section: 0), at: .centeredHorizontally, animated: false)
    }
    public func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        return colImage.cellForItem(at: IndexPath(item: index+1, section: 0))
    }
}

//public class CustomPageControl: UIPageControl {
//
//    public enum ContentSize {
//        case small
//        case large
//    }
//    public var contentSize = ContentSize.large {
//        didSet { self.layoutSubviews() }
//    }
//
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//
//        guard !self.subviews.isEmpty else { return }
//
//        let multiplier: CGFloat = contentSize == .large ?  2 : 1
//        let spacing: CGFloat = 2 * multiplier
//        let width: CGFloat = 10 * multiplier
//        let height: CGFloat = 2 * multiplier
//
//        var total: CGFloat = 0
//        let frameHeight = self.frame.size.height
//
//        for view in self.subviews {
//            view.cornerRadius = height/2
//            view.frame = CGRect(x: total, y: (frameHeight/2) - (height/2), width: width, height: height)
//            total += width + spacing
//        }
//
//        total -= spacing
//
////        self.frame.origin.x = frame.origin.x + (frame.size.width/2) - (total/2)
//        self.frame.size.width = total
//    }
//}
