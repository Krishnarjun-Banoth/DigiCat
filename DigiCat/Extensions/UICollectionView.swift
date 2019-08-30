//
//  UICollectionViewExtension.swift
//  DigiCat
//
//  Created by Krishnarjun on 27/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation


import UIKit

extension UICollectionView {
 
    func registerClass(_ aClass: AnyClass) {
        register(aClass.self, forCellWithReuseIdentifier: className(aClass))
    }
    
    func registerNib(_ aClass: AnyClass) {
        register(UINib(nibName: className(aClass), bundle: nil), forCellWithReuseIdentifier: className(aClass))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name))")
        }
        
        return cell
    }
    
    private func className(_ aClass: AnyClass) -> String {
        let fullClassPath = NSStringFromClass(aClass)
        return fullClassPath.components(separatedBy: ".").last ?? fullClassPath
    }
}


extension UICollectionViewCell {
   
    static var reuseIdentifier: String {
        return nameOfClass
    }
    
    class func dequeueReusableCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: nameOfClass, for: indexPath)
    }
}


extension UITableViewCell {
    class func dequeueCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: nameOfClass, for: indexPath)
    }
}
