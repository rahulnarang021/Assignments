//
//  ItemListCellController.swift
//  GelatoImageApp
//
//  Created by RN on 08/07/21.
//

import UIKit

final public class ImageListCellController: NSObject  {
    private let viewModel: ImageCellViewModel
    private let imageDataCompressionLoader: ImageDataCompressionLoader
    private var task: LoaderTask?

    private var placeholderImage: UIImage {
        return UIImage(named: "placeholder")! // force unwrap to make sure that this image is present in current bundle
    }

    init(viewModel: ImageCellViewModel, imageDataCompressionLoader: ImageDataCompressionLoader) {
        self.viewModel = viewModel
        self.imageDataCompressionLoader = imageDataCompressionLoader
    }

    public func getCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reusableIdentifier, for: indexPath) as! ImageCollectionViewCell // force unwrapping as it should crash if configuration is not set correctly in storyboad
        cell.imageView.image = placeholderImage
        task = imageDataCompressionLoader.load(url: viewModel.image, compressionSize: cell.frame.size, completion: { [weak cell] result in
            guard let `cell` = cell else {
                return
            }
            if let data = try? result.get(), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        })
        return cell
    }

    func didEndDisplay() {
        cancelTask()
    }

    private func cancelTask() {
        task?.cancel()
        task = nil
    }

}
