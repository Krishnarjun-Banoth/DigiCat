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
    var pageNo = 0
    var catsData: [CatData] = []
    var sortedCatsData: [Character: [CatData]] = [Character: [CatData]]()
    var sortBy = SortingLogic.DESC.rawValue
    var filterName = ""
    var filterType : FilterWidget?
    
    var filterData = [FilterWidget: Any]()
    
    func loadData(didFinish: @escaping (Bool) -> Void) {
        var url = Constants.EndPoints.BASE + Constants.EndPoints.HomePage
        
        if let filterType = filterType {
            if filterType == .CATEGORY {
                url += "?category_ids=\(filterName)"
            }
            else {
                url += "?breed_id=\(filterName)"
            }
            url += "&limit=\(Constants.LIMIT)&page=\(pageNo)"
        }
        else {
            url += "?limit=\(Constants.LIMIT)&page=\(pageNo)" + "&order=\(sortBy)"
        }
        
        APIClient.loadCatsData(with: url, completion: { cats in
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
    
    func loadCategories(){
        let url = Constants.EndPoints.BASE + Constants.EndPoints.CATEGORIES
        APIClient.loadCategoriesData(with: url, completion: { categories in
            guard let categories = categories else {
                print("Error while feching categories")
                return
            }
            self.filterData[FilterWidget.CATEGORY] = categories
        })
    }
    
    func loadBreeds() {
        let url = Constants.EndPoints.BASE + Constants.EndPoints.BREEDS
        print()
        APIClient.loadBreedsData(with: url, completion: { breeds in
            guard let breeds = breeds else {
                print("Error while feching breeds")
                return
            }
            self.filterData[FilterWidget.BREEDS] = breeds
        })
    }
}

