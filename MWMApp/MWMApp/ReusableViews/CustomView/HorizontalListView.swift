//
//  HorizontalListView.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import UIKit

protocol HorizontalListViewDelegate: AnyObject {
    func didSelectItem(atIndex index: Int)
}

class HorizontalListView: UIView, Nib {

    lazy var contentList: [String] = [] // could have used custom viewModel here if data is more

    weak var delegate: HorizontalListViewDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        if let view = UINib.init(nibName: HorizontalListView.nibName, bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.addSubview(view)
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.translatesAutoresizingMaskIntoConstraints = true
        }
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView.collectionViewLayout = CarouselFlowLayout()
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.registerCell(cell: TitleCell.self)

    }
    private func reloadView() {
        collectionView.reloadData()
    }

    func reloadView(withData data: [String]) {// could have used custom viewModel here if data is more
        contentList = data
        collectionView.reloadData()
    }
}

extension HorizontalListView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.reuseIdentifier, for: indexPath) as! TitleCell// if it crashes that means we have not registered the cell and its a developer error
        cell.configureCell(withText: contentList[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.didSelectItem(atIndex: indexPath.item)
    }
}
