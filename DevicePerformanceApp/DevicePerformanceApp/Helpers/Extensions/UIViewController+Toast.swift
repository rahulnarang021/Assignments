//
//  UIViewController+Toast.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import UIKit

extension UIViewController {

    func showToast(message: String, color: UIColor, bottomPadding: CGFloat) {

    let toastLabel = UILabel(frame: CGRect(x: 50, y: self.view.frame.size.height-bottomPadding, width: self.view.frame.size.width - 100, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = .systemFont(ofSize: 12.0)
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.backgroundColor = color
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 1, delay: 2.0, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: { (isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
