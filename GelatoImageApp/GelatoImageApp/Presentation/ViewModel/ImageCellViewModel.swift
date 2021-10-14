//
//  ImageCellViewModel.swift
//  GelatoImageApp
//
//  Created by RN on 04/07/21.
//

import Foundation

public struct ImageCellViewModel: Equatable {
    let image: URL

    public init(image: URL) {
        self.image = image
    }

}
