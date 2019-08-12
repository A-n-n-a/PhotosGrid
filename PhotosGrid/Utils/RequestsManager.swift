//
//  RequestsManager.swift
//  PhotosGrid
//
//  Created by Anna on 8/11/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation
import Networking

class RequestManager {
    typealias Completion = ((_ success: Bool, _ error: Error?) -> Void)?
    typealias CompletionWithPhotos = ((_ photos: [Photo]?, _ error: Error?) -> Void)?
    
    static func getPhotos(page: Int? = nil, completion: CompletionWithPhotos) {
        var parameters = [String: Any]()
        if let page = page {
            parameters[Constants.RestAPIConstants.page] = "\(page)"
        }
        let wrapParameters = WrapParameters(parameters: parameters).dictionaryValue
        Network.request(api: Constants.Endpoints.getPhotos, method: .get, parameters: wrapParameters, completion: { (data) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let photos = try JSONDecoder().decode([Photo].self, from: data)
                        completion?(photos, nil)
                    } catch let error {
                        completion?(nil, error)
                    }
                }
            }
        }) { (error) in
            completion?(nil, error)
        }
    }
    
    static func searchPhotos(query: String, completion: CompletionWithPhotos) {
        let queryParam = [Constants.RestAPIConstants.query : query]
        let parameters = WrapParameters(parameters: queryParam).dictionaryValue
        Network.request(api: Constants.Endpoints.searchPhotos, method: .get, parameters: parameters, completion: { (data) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(SearchResult.self, from: data)
                        completion?(result.results, nil)
                    } catch let error {
                        completion?(nil, error)
                    }
                }
            }
        }) { (error) in
            completion?(nil, error)
        }
    }
}
