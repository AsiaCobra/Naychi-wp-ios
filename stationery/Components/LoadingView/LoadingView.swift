//
//  LoadingView.swift
//  stationery
//
//  Created by Codigo NOL on 22/12/2020.
//

import UIKit
import NVActivityIndicatorView

public class LoadingView: UIView {

    static public let shared = LoadingView()
    
    var indicator = NVActivityIndicatorView(frame: .zero)
    var loadingAdded = false
    
    fileprivate var activityIndicatorView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 10
//        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
//        activityIndicatorView.center = view.center
//        activityIndicatorView.startAnimating()
//        view.addSubview(activityIndicatorView)
//        view.addShadow(with: .black, opacity: 0.4, radius: 8, offset: CGSize(width: 2, height: 2))
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        activityIndicatorView.center = self.center
        addSubview(activityIndicatorView)
        addIndicator(activityIndicatorView)
    }
    
    func addIndicator(_ inView: UIView) {
        if loadingAdded { return }
        loadingAdded = true
        indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: inView.frame.width, height: inView.frame.height),
                                            type: .ballClipRotatePulse, color: Color.Red.instance(), padding: 20)
//        indicator.center = inView.center
        indicator.startAnimating()
        inView.addSubview(indicator)
    }

    fileprivate func setBackgroundAlpha() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.activityIndicatorView.backgroundColor = UIColor.white.withAlphaComponent(0.09)
            }
        }
    }

    public func show() {
        indicator.startAnimating()
        if let window = UIApplication.shared.keyWindow {
            // window.topViewController()?.view.endEditing(true)
            for subView in window.subviews {
                if let view = subView as? LoadingView {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.2, animations: {
                            view.alpha = 0
                        }, completion: { _ in
                            view.removeFromSuperview()
                        })
                    }
                }
            }

            let view = LoadingView(frame: window.bounds)
            window.addSubview(view)
            view.setBackgroundAlpha()
        } else {
            print("No KeyWindow to add overlayLoadingView")
        }
    }

    public func hide() {
        indicator.stopAnimating()
        if let window = UIApplication.shared.keyWindow {
            for subView in window.subviews {
                if let view = subView as? LoadingView {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3, animations: {
                            view.alpha = 0
                        }, completion: { _ in
                            view.removeFromSuperview()
                        })
                    }
                }
            }

        } else {
            print("No overlayLoadingView to remove")
        }
    }
}
