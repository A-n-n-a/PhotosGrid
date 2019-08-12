//
//  Photo.swift
//  PhotosGrid
//
//  Created by Anna on 8/10/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation
import UIKit

struct Photo: Decodable {
    var id: String
    var description: String?
    var width: CGFloat
    var height: CGFloat
    var urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id
        case description = "alt_description"
        case width
        case height
        case urls
    }
}
