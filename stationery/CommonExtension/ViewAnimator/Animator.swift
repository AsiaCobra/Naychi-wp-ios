//
//  Animator.swift
//  FWD
//
//  Created by Codigo NOL on 09/07/2020.
//  Copyright © 2020 codigo. All rights reserved.
//

import UIKit

public class Animator {
    
    public enum Mode {
        case slow
        case normal
        case fast
    }
    
    
    public static func appear(_ views: [UIView]?, group2Views: Bool = false, from: Direction, mode: Animator.Mode = .normal) {
        guard let viewsToAnimate = views else { return }
        // usingSpringWithDamping - higher values make the bouncing finish faster.
        // SpringVelocity - higher values give the spring more initial momentum.
        
        var interval: TimeInterval = 0.06
        var duration: TimeInterval = 0.6
        let usingSpringWithDamping: CGFloat = 0.75
        let initialSpringVelocity: CGFloat = 0.6
        
        switch mode {
        case .slow:
            interval = 0.16
            duration = 0.8
        case .normal:
            interval = 0.08
            duration = 0.6
        case .fast:
            interval = 0.04
            duration = 0.4
        }
        
        UIView.animate(views: viewsToAnimate, animations: [AnimationType.from(direction: from, offset: 50)],
                       reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, animationInterval: interval,
                       duration: duration, usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity, options: [.curveEaseInOut],
                       completion: nil, group2Views: group2Views)
    }
    
    public static func imageCarousel(view: UIView, waveImage: String, duration: TimeInterval = 40, ratioWidth: CGFloat = 9, ratioHeight: CGFloat = 1, delay: TimeInterval = 0.4) {
        
        for sub in view.subviews {
            sub.removeFromSuperview()
        }
        
        let width = view.frame.height*(ratioWidth/ratioHeight)
        
        for i in 0..<2 {
            let wave = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: view.frame.height))
            wave.image = UIImage(named: waveImage)
            wave.frame.origin.x = width * CGFloat(i)
            wave.contentMode = .scaleAspectFill
            view.addSubview(wave)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .curveLinear], animations: {
                view.transform =  CGAffineTransform.identity.translatedBy(x: -(width), y: 0)
            }, completion: nil)
        }
    }
    
//    static func showlottie(_ view: UIView, lottieName: String, contentMode: UIView.ContentMode = .scaleAspectFit,
//                           loopMode: LottieLoopMode = .loop) {
//        let lottie = AnimationView(name: lottieName)
//        lottie.contentMode = contentMode
//        lottie.loopMode = loopMode
//        view.addSubview(lottie)
//        lottie.fillToSuperview()
//        lottie.play()
//    }
}
