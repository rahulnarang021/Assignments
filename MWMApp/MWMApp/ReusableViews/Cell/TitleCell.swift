//
//  TitleCell.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import UIKit

class TitleCell: UICollectionViewCell, Reusable, Nib {

    @IBOutlet weak var titleLabel: UILabel!

    func configureCell(withText title: String) {
        titleLabel.text = title
    }
}
