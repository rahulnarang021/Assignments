//
//  File.swift
//  GelatoImageAppTests
//
//  Created by RN on 12/07/21.
//

import Foundation
@testable import GelatoImageApp

extension ImageListViewController {
    func simulateCollectionViewReloadData () {
        collectionView.layoutIfNeeded()
        RunLoop.main.run(until: Date())
    }

}
