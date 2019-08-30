//
//  NSObject.swift
//  DigiCat
//
//  Created by Krishnarjun on 26/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation

public extension NSObject {
    class var nameOfClass: String {
        let fullClassPath = NSStringFromClass(self)
        return fullClassPath.components(separatedBy: ".").last ?? fullClassPath
    }
}
