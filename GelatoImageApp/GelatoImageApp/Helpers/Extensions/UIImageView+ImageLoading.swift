//
//  UIImageView+ImageLoading.swift
//  GelatoImageApp
//
//  Created by RN on 05/07/21.
//

import UIKit

extension UIImageView {//download image from server and display in imageview
    private static var _imageUrlString = [String: String?]()// created this variable to map imageView memory address and url, helped when cells got reused

    private var imageUrlString: String? { // to check for image when reusing cells
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIImageView._imageUrlString[tmpAddress] ?? nil
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIImageView._imageUrlString[tmpAddress] = newValue
        }
    }

    // MARK: - Download Image from Server
    func setImage(from imageUrl: URL) {
        self.imageUrlString = imageUrl.absoluteString
        do {
            let data = try self.getImage(from: imageUrl)
            if !data.isEmpty {
                self.setImage(from: data, downloadedUrl: imageUrl)
                return
            }
        } catch {
            // handle exception here
        }
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else {
                return
            }
            if let data = try? Data(contentsOf: imageUrl) {// not caching the image ion this project else we can use NSCache too
                do {
                    try self.saveImage(from: imageUrl, data: data)

                } catch {
                    
                    // handle image save failure here
                }
                self.setImage(from: data, downloadedUrl: imageUrl)
            }
        }
    }

    func setImage(from data: Data, downloadedUrl: URL) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {[weak self] in
                if self?.imageUrlString == downloadedUrl.absoluteString {//check for cell reuse case
                    self?.image = image
                }
            }
        }
    }

    func saveImage(from url: URL, data: Data) throws {
        let tempDirectoryPath = FileManager.default.temporaryDirectory
        try data.write(to: URL(string: "\(url.hashValue).jpg", relativeTo: tempDirectoryPath)!)
    }

    func getImage(from url: URL) throws -> Data {
        let tempDirectoryPath = FileManager.default.temporaryDirectory
        let imagePath = tempDirectoryPath.absoluteURL.appendingPathComponent("\(url.hashValue).jpg")

        let data = try Data(contentsOf: imagePath)
        return data
    }
}

