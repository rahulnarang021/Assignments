//
//  UICollectionViewCell+Reusable.swift
//  GelatoImageApp
//
//  Created by RN on 05/07/21.
//

import UIKit

protocol Reusable {
    static var reusableIdentifier: String { get }
}

extension UICollectionViewCell: Reusable {
    static var reusableIdentifier: String {
        return String(describing: Self.self)
    }
}
