//
//  Coordinator.swift
//  MWMApp
//
//  Created by RAHUL on 19/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import UIKit

protocol Deinitcallable: AnyObject {
    var onDeinit: (() -> Void)? { get set }
}


protocol NavigationCoordinator: AnyObject {
    var childCoordinators: [NavigationCoordinator] { get set }
    var navigationController: UINavigationController? { get set }

    func start()
    var didFinish: (() -> Void)? { get set }
    func setDeallocallable(with object: Deinitcallable)
    var deallocallable: Deinitcallable? { get set }
    func removeCoordinatorOnFinish(_ coordinator: NavigationCoordinator)
}

extension NavigationCoordinator {
    func setDeallocallable(with object: Deinitcallable) {
        deallocallable?.onDeinit = nil
        object.onDeinit = {[weak self] in
            self?.didFinish?()
        }
        deallocallable = object
    }

    func removeCoordinatorOnFinish(_ coordinator: NavigationCoordinator) {
        coordinator.didFinish = {[weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else {
                return
            }
            self.childCoordinators.removeAll(where: {childCoordinator -> Bool in
                return childCoordinator === coordinator
            })
        }
    }
}
