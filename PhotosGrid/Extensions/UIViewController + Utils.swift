//
//  UIViewController + Utils.swift
//  PhotosGrid
//
//  Created by Anna on 8/11/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(_ error: Error) {
        let myAlert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
