//
//  ViewController.swift
//  GelatoImageApp
//
//  Created by RN on 02/07/21.
//

import UIKit

public protocol ImageListPresenterInputProtocol {
    func loadImages()
    func cellDidLoad(at indexPath: IndexPath)
    func cellDidClick(at indexPath: IndexPath)
}

final class ImageListViewController: UIViewController, Storyboardable {

    final private let numberOfItemsInRow = 3
    final private let spacing: CGFloat = 10

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingView: UIStackView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var activeShareSheet: ShareSheetView?
    var presenter: ImageListPresenterInputProtocol! // force unwrapping as it should compose correctly

    fileprivate var imageCellControllers: [ImageListCellController] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadImages()
        // Do any additional setup after loading the view.
    }

}

extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width - CGFloat(CGFloat(numberOfItemsInRow + 1) * spacing))/CGFloat(numberOfItemsInRow)
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return spacing
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCellControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let controller = cellController(at: indexPath)
        presenter.cellDidLoad(at: indexPath)
        return controller.getCell(from: collectionView, at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let controller = cellController(at: indexPath)
        controller.didEndDisplay()
    }

    func cellController(at indexPath: IndexPath) -> ImageListCellController {
        return imageCellControllers[indexPath.item]
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.cellDidClick(at: indexPath)
    }
}

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 1)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension ImageListViewController: ImageListView {

    public func display(images: [ImageListCellController]) {
        imageCellControllers.append(contentsOf: images)
    }

    public func displayError(viewModel: ErrorViewModel) {
        errorLabel.text = viewModel.message
        toggleLoaderState(isHidden: true)
        collectionView.isHidden = true
    }

    public func showLoader(viewModel: LoadingViewModel) {
        loadingLabel.text = viewModel.message
        toggleLoaderState(isHidden: false)
    }

    public func hideLoader() {
        toggleLoaderState(isHidden: true)
    }

    private func toggleLoaderState(isHidden: Bool) {
        loadingView.isHidden = isHidden
        collectionView.isHidden = !isHidden
        errorLabel.isHidden = !isHidden
    }

    func showShareSheet(at indexPath: IndexPath, from view: ShareSheetView) {
        guard let existingCell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        activeShareSheet = view
        view.showView(from: existingCell, in: self.view)
    }
}
