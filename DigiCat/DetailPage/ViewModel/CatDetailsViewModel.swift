//
//  CatDetailsViewModel.swift
//  DigiCat
//
//  Created by Krishnarjun on 29/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CatDetailsViewModel: NSObject {

    var catData: CatData?
    
    func loadCatDetails(for id: String, didFinish: @escaping (Bool) -> Void) {
        let url = Constants.EndPoints.BASE + Constants.EndPoints.DetailPage + "/" + "\(id)"
        APIClient.loadCatDetails(with: url, completion: {cat in
            guard let cat = cat else {
                didFinish(false)
                return
            }
            self.catData = cat
            didFinish(true)
        })
    }
}

