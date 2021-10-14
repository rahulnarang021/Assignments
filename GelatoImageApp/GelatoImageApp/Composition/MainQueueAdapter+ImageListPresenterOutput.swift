//
//  MainQueueAdapter+ImageListPresenterOutput.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import Foundation
extension MainQueueAdapter: ImageListPresenterOutput where T: ImageListPresenterOutput {

    func display(images: [ImageCellViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.adapter.display(images: images)
        }
    }

    func displayError(viewModel: ErrorViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.adapter.displayError(viewModel: viewModel)
        }
    }

    func showLoader(viewModel: LoadingViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.adapter.showLoader(viewModel: viewModel)
        }
    }

    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.adapter.hideLoader()
        }
    }

    func showShareSheet(from indexPath: IndexPath, imageURL: URL) {
        DispatchQueue.main.async { [weak self] in
            self?.adapter.showShareSheet(from: indexPath, imageURL: imageURL)
        }
    }

}
