//
//  Constants.swift
//  PhotosGrid
//
//  Created by Anna on 8/10/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation

class Constants {
    
    struct Keys {
        static let accessKey = "fdbf06b75ad12a98569ef9f26ee0cb3df6063f8440e24c5dfadd8977c435c584"
    }
    struct Links {
        static let baseUrl = "https://api.unsplash.com/"
    }
    
    struct Endpoints {
        static var getPhotos: String {
            return Constants.Links.baseUrl + "photos"
        }
        static var searchPhotos: String {
            return Constants.Links.baseUrl + "search/photos"
        }
    }
    
    struct RestAPIConstants {
        static let clientId = "client_id"
        static let perPage = "per_page"
        static let page = "page"
        static let query = "query"
    }
    
}
