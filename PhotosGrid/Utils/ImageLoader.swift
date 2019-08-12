//
//  ImageLoader.swift
//  PhotosGrid
//
//  Created by Anna on 8/11/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

typealias Completion = ((UIImage?) -> Void)?
typealias CompletionWithData = ((Data?) -> Void)?

final class ImageLoader {
    private let downloadSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    func loadImage(fromURL url: URL?, completion: Completion) {
        self.downloadImage(fromURL: url, completion: completion)
    }
    
    func loadImage(fromURLString url: String?, completion: Completion) {
        var URLObject: URL?
        
        if let URLString = url {
            URLObject = URL(string: URLString)
        }
        
        self.loadImage(fromURL: URLObject, completion: completion)
    }
    
    private func downloadImage(fromURL url: URL?, completion: Completion) {
        guard let url = url else {
            completion?(nil)
            return
        }
        
        let urlPath = url.path
        
        // Show image from our cache if it's there
        if let image = imageCache.object(forKey: urlPath as AnyObject) as? UIImage {
            completion?(image)
            return
        }
        
        let request = URLRequest(url: url)
        let dataTask = downloadSession.dataTask(with: request) { (data, _, error) in
            guard error == nil, let data = data else {
                completion?(nil)
                return
            }
            
            let realmImage = RMImage(key: url.absoluteString, data: data)
            RealmManager.addOrUpdate(object: realmImage)
            
            if let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: urlPath as AnyObject)
                completion?(image)
            } else {
                completion?(nil)
            }
        }
        
        dataTask.resume()
    }
}

