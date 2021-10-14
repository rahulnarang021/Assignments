//
//  Extensions.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import UIKit

extension UICollectionView {// Register Cell in tableView
    func registerCell<T: Reusable & Nib>(cell: T.Type) {
        self.register(UINib(nibName: T.nibName, bundle: nil), forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
