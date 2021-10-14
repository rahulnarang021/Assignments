//
//  ImageListView.swift
//  GelatoImageApp
//
//  Created by RN on 09/07/21.
//

import UIKit

public protocol ImageListView {

    func display(images: [ImageListCellController])
    func displayError(viewModel: ErrorViewModel)
    func showLoader(viewModel: LoadingViewModel)
    func hideLoader()
    func showShareSheet(at indexPath: IndexPath, from view: ShareSheetView)
}

public protocol ShareSheetView {
    func showView(from: UIView, in view: UIView)
}
