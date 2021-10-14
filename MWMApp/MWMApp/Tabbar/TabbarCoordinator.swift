//
//  SearchCoordinator.swift
//  MWMApp
//
//  Created by RAHUL on 19/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import UIKit

class TabbarCoordinator: TabCoordinator { // it will contain reference of all coordinators that are inside the tabbar
    var rootViewController: UIViewController
    let chordCoordinator: ChordCoordinator

    init() {
        let tabbarVC = TabbarController()
        let chordNavController = UINavigationController()
        tabbarVC.viewControllers = [chordNavController]
        chordCoordinator = ChordCoordinator(navigationController: chordNavController)
        rootViewController = tabbarVC
    }

    func start() {
        chordCoordinator.start()
    }
}
