//
//  ImageItem.swift
//  GelatoImageApp
//
//  Created by RN on 02/07/21.
//

import Foundation
public struct ImageItem: Codable, Equatable {
    let id: String
    let author: String?
    let width: Double
    let height: Double
    let url: URL
    let download_url: URL
}
