//
//  CommonProtocols.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation
protocol Reusable {//Created this to register cell
    static var reuseIdentifier: String { get }
}

protocol Nib {//Created this to register Nib
    static var nibName: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension Nib {
    static var nibName: String {
        return String(describing: Self.self)
    }
}
