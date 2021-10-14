//
//  TabCoordinator.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation
import UIKit

protocol TabCoordinator: AnyObject {
    var rootViewController: UIViewController { get set }

    func start()
}
