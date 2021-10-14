//
//  ImageCollectionViewCell.swift
//  GelatoImageApp
//
//  Created by RN on 05/07/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func configure(imageCellViewModel: ImageCellViewModel) {
        imageView.clipsToBounds = true
        imageView.setImage(from: imageCellViewModel.image)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
