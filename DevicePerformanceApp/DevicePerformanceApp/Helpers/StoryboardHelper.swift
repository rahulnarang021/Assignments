//
//  StoaryboardHelper.swift
//  FinanceStackApp
//
//  Created by RN on 12/05/21.
//

import UIKit
protocol Storyboardable {
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: self))
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
