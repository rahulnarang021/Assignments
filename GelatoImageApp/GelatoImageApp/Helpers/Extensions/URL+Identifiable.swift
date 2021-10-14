//
//  URL+Identifiable.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import Foundation
extension URL {

    var identifier: String {
        return "\(self.absoluteString.hash)"
    }
}
