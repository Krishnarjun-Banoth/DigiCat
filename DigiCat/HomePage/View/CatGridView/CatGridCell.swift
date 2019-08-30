//
//  CatGridView.swift
//  DigiCat
//
//  Created by Krishnarjun on 27/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//


import UIKit

class CatGridCell: UICollectionViewCell {
    @IBOutlet var imageView: KRImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(imageUrl: String) {
        imageView.imageDownloaded(FromURL: imageUrl, contentMode: .scaleAspectFill)
    }
}
