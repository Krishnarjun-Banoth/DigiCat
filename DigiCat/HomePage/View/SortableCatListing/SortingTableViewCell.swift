//
//  SortingTableViewCell.swift
//  DigiCat
//
//  Created by Krishnarjun on 31/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import UIKit

class SortingTableViewCell: UITableViewCell {
    var label: String = "" {
        didSet {
            setupView()
        }
    }
    
    @IBOutlet var tickImage: UIImageView!
    @IBOutlet var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView() {
        labelText.text = label
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)
        if selected {
            tickImage.isHidden = false
            labelText.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            tickImage.isHidden = true
            labelText.font = UIFont.italicSystemFont(ofSize: 14)
        }
    }
}
