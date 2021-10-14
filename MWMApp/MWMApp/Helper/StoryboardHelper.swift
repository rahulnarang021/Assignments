//
//  StoryboardHelper.swift
//  MWMApp
//
//  Created by RAHUL on 19/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import UIKit

protocol Storyboardable {
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {

    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]

        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
