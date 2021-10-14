//
//  AlertTableViewCell.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ messageModel: AlertModel) {
        titleLabel.text = messageModel.alert
        subtitleLabel.text = "\(messageModel.date)"
    }
}
