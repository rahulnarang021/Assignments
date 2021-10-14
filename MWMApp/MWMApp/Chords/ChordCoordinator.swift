//
//  ChordCoordinator.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation
import UIKit

class ChordCoordinator: NavigationCoordinator {
    lazy var childCoordinators: [NavigationCoordinator] = []

    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    var didFinish: (() -> Void)?

    weak var deallocallable: Deinitcallable?

    func start() {
        let viewController = ChordViewController.instantiate()

        let networking = APIManager.shared
        let viewModel = ChordsViewModel(defaultSelectedIndex: 0, client: ChordListLoader(networking: networking))
        viewModel.view = viewController

        viewController.viewModel = viewModel
        setDeallocallable(with: viewController)
        navigationController?.pushViewController(viewController, animated: false)
        viewController.tabBarItem = UITabBarItem(title: "Chords", image: nil, selectedImage: nil)
    }
}
