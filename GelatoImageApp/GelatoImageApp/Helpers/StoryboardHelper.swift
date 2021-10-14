//
//  StoaryboardHelper.swift
//  GelatoImageApp
//
//  Created by RN on 05/07/21.
//

import UIKit
public protocol Storyboardable {
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {
    public static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: self))
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
