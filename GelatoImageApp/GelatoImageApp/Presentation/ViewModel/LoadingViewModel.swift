//
//  LoadingViewModel.swift
//  GelatoImageApp
//
//  Created by RN on 04/07/21.
//

import Foundation
public struct LoadingViewModel: Equatable {
    let message: String

    public init(message: String) {
        self.message = message
    }
}
