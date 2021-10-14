//
//  ImageListPresenterAdapter.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import Foundation
class ImageListPresenterAdapter: ImageListPresenterOutput {
    let receiver: ImageListView
    let imageDataLoader: ImageDataLoader
    let imageDataCompressionLoader: ImageDataCompressionLoader
    init(_ receiver: ImageListView, imageDataLoader: ImageDataLoader, imageDataCompressionLoader: ImageDataCompressionLoader) {
        self.receiver = receiver
        self.imageDataLoader = imageDataLoader
        self.imageDataCompressionLoader = imageDataCompressionLoader
    }

    func display(images: [ImageCellViewModel]) {
        let controllers = images.map { viewModel -> ImageListCellController in
            ImageListCellController(viewModel: viewModel, imageDataCompressionLoader: imageDataCompressionLoader)
        }
        self.receiver.display(images: controllers)
    }

    func displayError(viewModel: ErrorViewModel) {
        self.receiver.displayError(viewModel: viewModel)
    }

    func showLoader(viewModel: LoadingViewModel) {
        self.receiver.showLoader(viewModel: viewModel)
    }

    func hideLoader() {
        self.receiver.hideLoader()
    }

    func showShareSheet(from indexPath: IndexPath, imageURL: URL) {
        let controller = ShareImageController(imageDataLoader: imageDataLoader, imageURL: imageURL)
        receiver.showShareSheet(at: indexPath, from: controller)
    }
}
