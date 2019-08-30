//
//  CatsHomeViewModel.swift
//  DigiCat
//
//  Created by Krishnarjun on 26/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//


import Foundation
import UIKit
import Alamofire

class CatsHomeViewModel: NSObject {
    var pageNo = -1
    var catsData: [CatData] = []
    var sortedCatsData: [Character: [CatData]] = [Character: [CatData]]()

    
    func loadData(didFinish: @escaping (Bool) -> Void) {
        let url = Constants.EndPoints.BASE + Constants.EndPoints.HomePage + "?limit=\(Constants.LIMIT)&page=\(pageNo)"
        APIClient.loadCatsData(with: url, completion: {cats in
            guard let cats = cats else {
                print("Error")
                didFinish(false)
                return
            }
            self.pageNo = self.pageNo + 1
            self.catsData = self.catsData + cats
            didFinish(true)
        })
    }
}
