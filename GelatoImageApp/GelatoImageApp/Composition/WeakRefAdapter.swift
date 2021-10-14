//
//  WeakRefAdapter.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import Foundation

class WeakRefAdapter<T: AnyObject> {
    weak var adapter: T?

    init(_ adapter: T) {
        self.adapter = adapter
    }
}



extension WeakRefAdapter: ImageListView where T: ImageListView {
    func display(images: [ImageListCellController]) {
        self.adapter?.display(images: images)
    }

    func displayError(viewModel: ErrorViewModel) {
        self.adapter?.displayError(viewModel: viewModel)
    }

    func showLoader(viewModel: LoadingViewModel) {
        self.adapter?.showLoader(viewModel: viewModel)
    }

    func hideLoader() {
        self.adapter?.hideLoader()
    }

    func showShareSheet(at indexPath: IndexPath, from view: ShareSheetView) {
        self.adapter?.showShareSheet(at: indexPath, from: view)
    }

}
