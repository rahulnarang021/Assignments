//
//  ImageListView.swift
//  GelatoImageApp
//
//  Created by RN on 04/07/21.
//

import Foundation
public protocol ImageListPresenterOutput {

    func display(images: [ImageCellViewModel])
    func displayError(viewModel: ErrorViewModel)
    func showLoader(viewModel: LoadingViewModel)
    func hideLoader()
    func showShareSheet(from indexPath: IndexPath, imageURL: URL)

}
