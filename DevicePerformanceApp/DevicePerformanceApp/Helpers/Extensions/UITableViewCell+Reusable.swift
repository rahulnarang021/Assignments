//
//  UITableViewCell+Reusable.swift
//  FinanceStackApp
//
//  Created by RN on 09/05/21.
//

import UIKit

protocol Reusable {
    static var reusableIdentifier: String { get }
}

extension UITableViewCell: Reusable {
    static var reusableIdentifier: String {
        return String(describing: Self.self)
    }
}
