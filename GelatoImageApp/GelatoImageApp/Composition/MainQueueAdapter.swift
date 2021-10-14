//
//  MainQueueAdapter.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import Foundation
class MainQueueAdapter<T> {
    var adapter: T

    init(_ adapter: T) {
        self.adapter = adapter
    }
}
