//
//  ImageDataCompressionLoader.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import UIKit

protocol ImageDataCompressionLoader {
    func load(url: URL, compressionSize: CGSize?, completion: @escaping (Result<Data, Error>) -> Void) -> LoaderTask
}

