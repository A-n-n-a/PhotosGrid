//
//  PhotoCollectionViewCell.swift
//  PhotosGrid
//
//  Created by Anna on 8/11/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var urlString: String? {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        guard let urlString = urlString
            else { return }
        imageView.image = #imageLiteral(resourceName: "placeholder")
        
        if let data = RealmManager.getObject(type: RMImage.self, forPrimaryKey: urlString)?.data, let cachedImage = UIImage(data: data) {
            imageView.image = cachedImage
        } else {
            activityIndicator.startAnimating()
            ImageLoader().loadImage(fromURLString: urlString) { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.imageView.image = image
                }
            }
        }
    }
}
