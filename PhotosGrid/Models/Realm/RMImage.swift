//
//  RMImage.swift
//  PhotosGrid
//
//  Created by Anna on 8/12/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation
import RealmSwift

class RMImage: Object {
    @objc dynamic var key: String = ""
    @objc dynamic var data: Data?
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
    convenience init(key: String, data: Data) {
        self.init()
        self.key = key
        self.data = data
    }
}
