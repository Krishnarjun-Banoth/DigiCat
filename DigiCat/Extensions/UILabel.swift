//
//  UILabel.swift
//  DigiCat
//
//  Created by Krishnarjun on 31/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation
import UIKit



extension UIFont {
    func withTraits(traits:UIFontDescriptorSymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
