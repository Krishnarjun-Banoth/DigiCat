//
//  SizeProvider.swift
//  DigiCat
//
//  Created by Krishnarjun on 27/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation
import UIKit

/**
 Use this class to obtain device based sizes, for different features.
 */
class SizeProvider {
    struct CatGridSizes {
        static var gridInterItemSpacing: CGFloat = 8.0
        static var numberOfItemsPerRow: Int = 3
        static var gridCollectionViewLeftInset: CGFloat = 16.0
        static var gridCollectionViewRightInset: CGFloat = 16.0
        static var gridCollectionViewTopInsetForSection: CGFloat = 4.0
        static var gridCollectionViewBottomInsetForSection: CGFloat = 4.0
        static var heightOfItemInGrid: CGFloat = 160.0
    }
}


