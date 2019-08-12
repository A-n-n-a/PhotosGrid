//
//  WrapParameters.swift
//  PhotosGrid
//
//  Created by Anna on 8/11/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation

struct WrapParameters {
    var parameters: [String: Any]
    
    var dictionaryValue: [String: Any] {
        var wrapParameters = parameters
        wrapParameters[Constants.RestAPIConstants.clientId] = Constants.Keys.accessKey
        wrapParameters[Constants.RestAPIConstants.perPage] = "30"
        
        return wrapParameters
    }
}
