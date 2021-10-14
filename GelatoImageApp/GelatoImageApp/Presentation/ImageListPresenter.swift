//
//  ImageListPresenter.swift
//  GelatoImageApp
//
//  Created by RN on 04/07/21.
//

import UIKit

public class ImageListPresenter: ImageListPresenterInputProtocol {
    private let imageListView: ImageListPresenterOutput
    private let loader: ImageItemLoader

    private var imageItems: [ImageItem] = []
    private var isImageLoadingInProgress = false

    private var pageToLoad = 1
    public static var title: String {
        return "Image List"
    }

    public init(imageListView: ImageListPresenterOutput, loader: ImageItemLoader) {
        self.imageListView = imageListView
        self.loader = loader
    }

    public func loadImages() {
        if !isImageLoadingInProgress {
            isImageLoadingInProgress = true
            showLoader()
            self.loader.load(page: pageToLoad) { [weak self] result in
                guard let `self` = self else {
                    return
                }
                self.hideLoader()
                self.handleImageItemResult(result)
                self.pageToLoad = self.pageToLoad + 1
                self.isImageLoadingInProgress = false
            }
        }
    }

    public func cellDidLoad(at indexPath: IndexPath) {
        if indexPath.item == self.imageItems.count - 1 {
            loadImages()
        }
    }

    public func cellDidClick(at indexPath: IndexPath) {
        self.imageListView.showShareSheet(from: indexPath, imageURL: imageItems[indexPath.item].download_url)
    }

    private func showLoader() {
        if self.pageToLoad == 1 {
            self.imageListView.showLoader(viewModel: LoadingViewModel(message: "Loading Data"))
        }
    }

    private func hideLoader() {
        if self.pageToLoad == 1 {
            self.imageListView.hideLoader()
        }
    }

    private func handleImageItemResult(_ result: Result<[ImageItem], Error>) {
        if let items = try? result.get() {
            imageItems.append(contentsOf: items)

            imageListView.display(images: items.toViewModels())

        } else if imageItems.isEmpty {
            imageListView.displayError(viewModel: ErrorViewModel(message: "Failed to load data"))
        }
    }
}

extension Array where Element == ImageItem {
    func toViewModels() -> [ImageCellViewModel] {
        self.map { imageItem in
            ImageCellViewModel(image: imageItem.download_url)
        }
    }
}
