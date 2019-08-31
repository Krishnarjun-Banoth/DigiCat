//
//  APIClient.swift
//  DigiCat
//
//  Created by Krishnarjun on 28/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Alamofire
import Foundation


class APIClient {
    static func loadCatsData(with url: String, completion: @escaping (([CatData]?) -> Void)) {
        Alamofire.request(url, method: .get, parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: APIClient.getHttpHeaders()).validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote cats: \(String(describing: response.result.error))")
                        completion(nil)
                    return
                }
                
                guard let data = response.data,
                    let jsonString = String(data: data, encoding: .utf8) else {
                        completion(nil)
                        return}
                let jsonData = jsonString.data(using: .utf8)!
                do {
                    let cats = try JSONDecoder().decode([CatData].self, from: jsonData)
                    completion(cats)
                } catch {
                    completion(nil)
                    print(error.localizedDescription)
                }
        }
    }
    
    static func loadCatDetails(with url: String, completion: @escaping ((CatData?) -> Void)) {
        Alamofire.request(url, method: .get, parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: APIClient.getHttpHeaders()).validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote cats: \(String(describing: response.result.error))")
                    completion(nil)
                    return
                }
                
                guard let data = response.data,
                    let jsonString = String(data: data, encoding: .utf8) else {
                        completion(nil)
                        return}
                let jsonData = jsonString.data(using: .utf8)!
                do {
                    let cat = try JSONDecoder().decode(CatData.self, from: jsonData)
                    completion(cat)
                } catch {
                    completion(nil)
                    print(error.localizedDescription)
                }
        }
    }
    
    
    static func loadCategoriesData(with url: String, completion: @escaping (([Category]?) -> Void)) {
        Alamofire.request(url, method: .get, parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: APIClient.getHttpHeaders()).validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching categories: \(String(describing: response.result.error))")
                    completion(nil)
                    return
                }
                
                guard let data = response.data,
                    let jsonString = String(data: data, encoding: .utf8) else {
                        completion(nil)
                        return}
                let jsonData = jsonString.data(using: .utf8)!
                do {
                    let categories = try JSONDecoder().decode([Category].self, from: jsonData)
                    completion(categories)
                } catch {
                    completion(nil)
                    print(error.localizedDescription)
                }
        }
    }
    
    static func loadBreedsData(with url: String, completion: @escaping (([Breed]?) -> Void)) {
        Alamofire.request(url, method: .get, parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: APIClient.getHttpHeaders()).validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching breeds: \(String(describing: response.result.error))")
                    completion(nil)
                    return
                }
                
                guard let data = response.data,
                    let jsonString = String(data: data, encoding: .utf8) else {
                        completion(nil)
                        return}
                let jsonData = jsonString.data(using: .utf8)!
                do {
                    let breeds = try JSONDecoder().decode([Breed].self, from: jsonData)
                    completion(breeds)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
        }
    }
    static func getHttpHeaders() -> HTTPHeaders {
        var httpHeaders: [String: String] = [:]
        httpHeaders["x-api-key"] = Constants.API_KEY
        httpHeaders["Content-Type"] = "application/json"
        return httpHeaders
    }
}

