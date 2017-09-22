//
//  LottieExtension.swift
//  TestLottie
//
//  Created by Kyle Kirkland on 9/22/17.
//  Copyright © 2017 Kirkland Enterprises. All rights reserved.
//

import Foundation
import Lottie

private let halogenLottieLoadingAnimationName = "loading"
private let halogenLottieLoadingSmallAnimationName = "loadingSmall"

enum LoadingAnimationStyle {
    case large
    case medium
    case small
    
    var name: String {
        switch self {
        case .medium, .large:
            return "loading"
        case .small:
            return "loadingSmall"
        }
    }
    
    var size: CGSize {
        switch self {
        case .large:
            return CGSize(width: 64.0, height: 64.0)
        case .medium:
            return CGSize(width: 32.0, height: 32.0)
        case .small:
            return CGSize(width: 16.0, height: 16.0)
        }
    }
}

final class NameRetrieavableLOTAnimationView: LOTAnimationView {
    
    var name: String
    
    init(name: String, bundle: Bundle = .main) {
        self.name = name
        
        let filename = (name as NSString).deletingPathExtension
        var pathExtension = (name as NSString).pathExtension
        if pathExtension.isEmpty {
            pathExtension = "json"
        }
        let resourcePath = bundle.path(forResource: filename, ofType: pathExtension) ?? ""
        
        let url = URL(fileURLWithPath: resourcePath)
        
        super.init(contentsOf: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    
    func halogenPlayLottieAnimation(named animationName: String) {
        let animationView = halogenAddLottieAnimation(named: animationName)
        
        animationView.play() { _ in
            animationView.removeFromSuperview()
        }
    }
    
    @discardableResult func halogenAddLoopingLottieAnimation(named animationName: String) -> LOTAnimationView {
        let animationView = halogenAddLottieAnimation(named: animationName)
        
        animationView.loopAnimation = true
        animationView.play()
        
        return animationView
    }
    
    func halogenRemoveLoopingLottieAnimation(_ animationView: LOTAnimationView) {
        UIView.animate(withDuration: 0.15, animations: {
            animationView.alpha = 0.0
        }) { _ in
            animationView.loopAnimation = false
            animationView.removeFromSuperview()
        }
    }
    
    // MARK: Loading Animation (loading.json)
    
    func halogenAddLoadingAnimation(style: LoadingAnimationStyle) -> LOTAnimationView {
        //DispatchQueue.main.async {
        let animationView = self.halogenAddLoopingLottieAnimation(named: style.name)
        
        // if the loader is smaller than the bounds, change its size to the loader size, else keep it the bound size
        if (style.size.width <= self.bounds.size.width && style.size.height <= self.bounds.size.width) {
            animationView.frame.size = style.size
        }
        
        animationView.contentMode = .scaleAspectFit
        animationView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        // }
        
        return animationView
    }
    
    func halogenRemoveLoadingAnimation(style: LoadingAnimationStyle) {
        guard let animationView = halogenFindLottieAnimation(named: style.name) else {
            return
        }
        
        halogenRemoveLoopingLottieAnimation(animationView)
    }
    
    // MARK: Helpers
    
    private func halogenAddLottieAnimation(named animationName: String) -> LOTAnimationView {
        let animationView = NameRetrieavableLOTAnimationView(name: animationName)
        
        animationView.frame = bounds
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        animationView.contentMode = .scaleAspectFill
        
        addSubview(animationView)
        
        return animationView
    }
    
    private func halogenFindLottieAnimation(named animationName: String) -> LOTAnimationView? {
        return subviews.first(where: { ($0 as? NameRetrieavableLOTAnimationView)?.name == animationName }) as? LOTAnimationView
    }
    
}
