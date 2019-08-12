//
//  ViewController.swift
//  PhotosGrid
//
//  Created by Anna on 8/10/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var prevPageButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    
    
    var page = 1 {
        didSet {
            prevPageButton.alpha = page == 1 ? 0 : 1
            nextPageButton.alpha = page == 10 ? 0 : 1
        }
    }
    var padding: CGFloat = 20
    var interItemSpace: CGFloat = 10
    var itemWidth: CGFloat = 0
    var photos = [Photo]() {
        didSet {
            collectionView.reloadData()
            view.setNeedsLayout()
        }
    }
    let cellName = String(describing: PhotoCollectionViewCell.self)
    let headerName = String(describing: SearchView.self)
    var searchTimer: Timer?
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        getPhotos()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
    }
    
    func getPhotos(page: Int? = nil) {
        RequestManager.getPhotos(page: page) { [weak self] (photos, error) in
            DispatchQueue.main.async {
                if let photos = photos {
                    self?.photos = photos
                }
                if let error = error {
                    self?.showError(error)
                }
            }
        }
    }
    
    func searchPhotos() {
        RequestManager.searchPhotos(query: query) { [weak self] (photos, error) in
            DispatchQueue.main.async {
                if let photos = photos {
                    self?.photos = photos
                }
                if let error = error {
                    self?.showError(error)
                }
            }
        }
    }

    func setupCollectionView() {
        let collectionViewNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(collectionViewNib, forCellWithReuseIdentifier: cellName)
        
        itemWidth = (UIScreen.main.bounds.width - padding * 2 - interItemSpace * 2) / 3
        flowLayout.minimumInteritemSpacing = interItemSpace
        flowLayout.minimumLineSpacing = interItemSpace
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 45)
    }
    
    func itemHeight(photo: Photo) -> CGFloat {
        let ratio = photo.height / photo.width
        let height = itemWidth * ratio
        return height
    }

    @IBAction func previousPage(_ sender: Any) {
        page -= 1
        getPhotos(page: page)
    }
    
    @IBAction func nextPage(_ sender: Any) {
        page += 1
        getPhotos(page: page)
    }
}

extension GridViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.item]
        cell.urlString = photo.urls.thumb
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let height = itemHeight(photo: photo)
        return CGSize(width: itemWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let photo = photos[indexPath.item]
        if let singlePhotoVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "singlePhotoVC") as? SinglePhotoViewController {
            singlePhotoVC.urlString = photo.urls.full
            navigationController?.pushViewController(singlePhotoVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView: SearchView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerName, for: indexPath) as! SearchView
            headerView.searchBar.delegate = self
        
        return headerView
        }
        
        return UICollectionReusableView()
    }
}


extension GridViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchTimer?.isValid ?? false {
            searchTimer?.invalidate()
        }
        if searchText.count > 2 {
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] (_) in
                if self?.query != searchText {
                    DispatchQueue.main.async {
                        self?.query = searchText
                        self?.searchPhotos()
                    }
                }
            })
        }
    }
}
