//
//  RemoteLoaderExtensions.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import Foundation

extension RemoteLoader: ImageItemLoader where Resource == [ImageItem] {
}

extension RemoteLoader: ImageDataLoader where Resource == Data {
}
