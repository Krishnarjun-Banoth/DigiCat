//
//  KRImageView.swift
//  DigiCat
//
//  Created by Krishnarjun on 27/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation
import PINRemoteImage
import UIKit

/// A wrapper for the UIKit provided UIImageView containing methods to download image from an url.
class KRImageView: UIImageView {
    var url: String?
    var shouldDisplayPlaceHolderImageOnFailure = false
    weak var imageUpdateDelegate: UIImageUpdateDelegate?
    
    func imageDownloaded(FromURL imageURL: String?, contentMode mode: UIView.ContentMode) {
        // imageDownloaded(FromURL: imageURL, contentMode: mode, placeholderImage: nil);
        pin_setImage(from: URL(string: imageURL ?? ""), placeholderImage:  UIImage(named: "catPlaceholder"))
        contentMode = mode
    }
    
    // Use this method to implement custom caching.
    func imageDownloaded(FromURL imageURL: String?, contentMode mode: UIView.ContentMode, placeholderImage placeholder: String?,
                         CacheName cacheName: String? = nil, MaxLimit limit: Int = 50) {
        contentMode = mode
        let placeHolderImage = placeholder ?? "catPlaceholder"
        image = UIImage(named: placeHolderImage)
        let failureFallBackImage = shouldDisplayPlaceHolderImageOnFailure ? placeHolderImage : "catPlaceholder"
        
        guard let link = imageURL else {
            image = UIImage(named: failureFallBackImage)
            return
        }
        
        guard let url = URL(string: link) else {
            image = UIImage(named: failureFallBackImage)
            return
        }
        
        self.url = link
        let cache = KRImageCache.sharedCache(name: cacheName ?? NSObject.nameOfClass, limitedTo: limit)
        if let cachedImage = cache.object(forKey: link as AnyObject) as? UIImage {
            contentMode = mode
            image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let downloadedImage = UIImage(data: data),
                let imageViewURL = self.url, imageViewURL == url.absoluteString
                else {
                    DispatchQueue.main.async {
                        self.image = UIImage(named: failureFallBackImage)
                    }
                    return
            }
            DispatchQueue.main.async { () -> Void in
                self.alpha = 0
                cache.setObject(downloadedImage, forKey: link as AnyObject, cost: data.count)
                self.image = downloadedImage
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                }
                self.contentMode = mode
            }
        }).resume()
    }
    
    override var image: UIImage? {
        didSet {
            guard let imageUpdateDelegate = self.imageUpdateDelegate else { return }
            imageUpdateDelegate.imageUpdated(image)
        }
    }
    
    convenience init(url: String?) {
        self.init(url: url, ContentMode: .scaleAspectFill)
    }
    
    convenience init(url: String?, ContentMode contentMode: UIView.ContentMode) {
        self.init()
        imageDownloaded(FromURL: url, contentMode: contentMode)
    }
}

protocol UIImageUpdateDelegate: class {
    func imageUpdated(_ image: UIImage?)
}




/// Derivative of NSCache from Foundation, specifically used to cache images. Can be extending to cache other data too.
class KRImageCache: NSCache<AnyObject, AnyObject> {
    static var cacheStore = [String: KRImageCache]()
    
    class func sharedCache(name: String, limitedTo limit: Int) -> KRImageCache {
        if let cache = cacheStore[name] {
            return cache
        }
        let cache = KRImageCache()
        cache.name = name
        cache.countLimit = limit
        cache.totalCostLimit = 10 * 1024 * 1024 // Max 10MB used.
        cacheStore[name] = cache
        return cache
    }
}
