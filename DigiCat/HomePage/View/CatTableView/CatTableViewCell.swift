//
//  CatTableViewCell.swift
//  DigiCat
//
//  Created by Krishnarjun on 30/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import UIKit

class CatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var catImageView: KRImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(imageUrl: String) {
        catImageView.imageDownloaded(FromURL: imageUrl, contentMode: .scaleAspectFill)
    }
    
}
