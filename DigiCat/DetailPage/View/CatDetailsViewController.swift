//
//  CatDetailsViewController.swift
//  DigiCat
//
//  Created by Krishnarjun on 29/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import UIKit

class CatDetailsViewController: UIViewController {
    var catId = "" {
        didSet {
            loadCatDetails()
        }
    }
    @IBOutlet weak var imageView: KRImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temparament: UILabel!
    
    let viewModel = CatDetailsViewModel()
    var catDetails : CatData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadCatDetails() {
        viewModel.loadCatDetails(for: catId, didFinish: {success in
            if success {
                self.catDetails = self.viewModel.catData
                self.setup()
            }
            else {
            }
        })
    }
    
    func setup() {
        guard let cat = catDetails else {return}
        imageView.imageDownloaded(FromURL: cat.url, contentMode: .scaleAspectFill)
        guard let breads = cat.breeds,
            let bread = breads.first
            else {return}
        navigationItem.title = bread.name
        descriptionLabel.text = bread.description
        temparament.text = bread.temperament
    }
    
}
