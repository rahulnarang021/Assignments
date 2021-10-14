//
//  ChordViewController.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import UIKit

class ChordViewController: UIViewController, Storyboardable, Deinitcallable {

    var onDeinit: (() -> Void)?

    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var chordHorizontalView: HorizontalListView!
    @IBOutlet weak var keyHorizontalView: HorizontalListView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var viewModel: ChordVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func configureView() {
        self.title = "Chords"// should be localized
        keyHorizontalView.delegate = self
    }

    deinit {
        onDeinit?()// to handle callback of deinit in coordinator
    }
}

extension ChordViewController: ChordView {

    func reloadKeys(withKeys keys: [String]) {
        keyHorizontalView.reloadView(withData: keys)
    }

    func reloadChords(withChords chords: [String]) {
        chordHorizontalView.reloadView(withData: chords)
    }

    func showErrorMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))

        self.present(alert, animated: true)
    }

    func showLoader() {
        showHideLoader(isHidden: false)
    }

    func hideLoader() {
        showHideLoader(isHidden: true)
    }

    //MARK: - ViewLoadingState
    private func showHideLoader(isHidden: Bool) {
        activityIndicator.isHidden = isHidden
        if isHidden {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        containerView.isHidden = !isHidden
    }
}

extension ChordViewController: HorizontalListViewDelegate {
    func didSelectItem(atIndex index: Int) {
        viewModel.didSelectItem(at: index)
    }
}
