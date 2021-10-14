//
//  SnapshotTestHelper.swift
//  GelatoImageAppTests
//
//  Created by RN on 05/07/21.
//

import UIKit
struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection

    static func iPhone8(style: UIUserInterfaceStyle) -> SnapshotConfiguration {
        let traitCollection = UITraitCollection(traitsFrom: [.init(layoutDirection: .leftToRight),
                                                             .init(userInterfaceStyle: style),
                                                             .init(forceTouchCapability: .available),
                                                             .init(userInterfaceIdiom: .phone),
                                                             .init(horizontalSizeClass: .compact),
                                                             .init(verticalSizeClass: .regular),
                                                             .init(displayScale: 2),
                                                             .init(displayGamut: .P3)
        ])

        let config = SnapshotConfiguration(size: CGSize(width: 375, height: 667), safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), traitCollection: traitCollection)
        return config
    }
}

class SnapshotWindow: UIWindow {
    var configuration: SnapshotConfiguration = SnapshotConfiguration.iPhone8(style: .light)
    convenience init(configuration: SnapshotConfiguration, viewController: UIViewController) {
        self.init()
        self.rootViewController = viewController
        self.makeKeyAndVisible()
        self.configuration = configuration
    }

    override var traitCollection: UITraitCollection {
        return UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
    }

    override var safeAreaInsets: UIEdgeInsets {
        return configuration.safeAreaInsets
    }

    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }

}
extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, viewController: self).snapshot()
    }
}
