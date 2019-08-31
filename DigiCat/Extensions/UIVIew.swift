//
//  UIVIew.swift
//  DigiCat
//
//  Created by Krishnarjun on 26/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func removeView(_ tag: Int) -> Bool {
        var status = false
        while true {
            guard let subView = viewWithTag(tag) else { return status }
            status = true
            subView.removeFromSuperview()
        }
    }
    
    // Helper method that adds the conventional curve to the view along with a border.
    func curveAndAddBorder(radius: CGFloat = 8, borderColor: CGColor = UIColor.white.cgColor, borderWidth: CGFloat = 1) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
    }
 
    
    func showLoadingAnimation(_ enableInteraction: Bool = false) {
        isUserInteractionEnabled = enableInteraction
        _ = removeView(LoadingAnimationView.TAG)
        let loadingAnimation = LoadingAnimationView(WithSide: 120)
        addSubview(loadingAnimation)
        loadingAnimation.align(verticalPaddingValue: 0.25, horizontalPaddingValue: 0)
    }
    
    func hideLoadingAnimation() {
        viewWithTag(LoadingAnimationView.TAG)?.removeFromSuperview()
        isUserInteractionEnabled = true
    }
    
    
    func blur(_ alpha: CGFloat = 1, style: UIBlurEffect.Style = .extraLight) {
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            blurEffectView.alpha = alpha
            addSubview(blurEffectView)
            sendSubviewToBack(blurEffectView)
        } else if style == .dark {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        } else {
            self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
        }
    }
    
    func addSubview(_ subview: UIView, verticalPadding: CGFloat = 0, horizontalPadding: CGFloat = 0) {
        if subview.tag != 0 {
            _ = removeView(subview.tag)
        }
        guard subview != self else { return }
        addSubview(subview)
        subview.align(verticalPaddingValue: verticalPadding, horizontalPaddingValue: horizontalPadding)
    }
    
    func align(verticalPaddingValue: CGFloat = 0,
               horizontalPaddingValue: CGFloat = 0) {
        var verticalPadding = verticalPaddingValue
        var horizontalPadding = horizontalPaddingValue
        if verticalPadding < 1 {
            verticalPadding = (superview?.frame.height ?? 0) * verticalPaddingValue
        }
        if horizontalPadding < 1 {
            horizontalPadding = (superview?.frame.width ?? 0) * horizontalPaddingValue
        }
        let widthDelta = (superview?.frame.width ?? 0) - frame.width
        let heightDelta = (superview?.frame.height ?? 0) - frame.height
        frame.origin = CGPoint(x: widthDelta / 2, y: heightDelta / 2)
    }
}

class LoadingAnimationView: UIView {
    static let TAG = 3030
    
    convenience init(WithSide side: CGFloat) {
        self.init(frame: CGRect(side: side))
        self.layer.cornerRadius = 8
        blur()
        let loadingAnimation = UIActivityIndicatorView(frame: CGRect(side: side * 0.66, center: CGPoint(x: side / 2, y: side / 2) ))
        loadingAnimation.style = .whiteLarge
        loadingAnimation.color = #colorLiteral(red: 0.08235294118, green: 0.3411764706, blue: 0.7490196078, alpha: 1)
        loadingAnimation.startAnimating()
        tag = type(of: self).TAG
        addSubview(loadingAnimation)
    }
}


extension CGRect {

    init(size: CGSize) {
        self.init(origin: CGPoint.zero, size: size)
    }
    
    init(width: CGFloat, height: CGFloat) {
        self.init(size: CGSize(width: width, height: height))
    }
    
    init(side: CGFloat, center: CGPoint) {
        self.init(size: CGSize(width: side, height: side))
        origin = CGPoint(x: center.x - side / 2, y: center.y - side / 2)
    }
    
    init(side: CGFloat) {
        self.init(side: side, center: CGPoint.zero)
    }
}

extension CGSize {
    init(side: CGFloat) {
        self.init(width: side, height: side)
    }
}
