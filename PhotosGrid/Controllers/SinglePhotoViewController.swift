//
//  SinglePhotoViewController.swift
//  PhotosGrid
//
//  Created by Anna on 8/11/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        
        guard let urlString = urlString  else { return }
        
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
