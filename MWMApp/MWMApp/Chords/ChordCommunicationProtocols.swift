//
//  ListCommunicationProtocols.swift
//  MWMApp
//
//  Created by RAHUL on 20/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation
protocol ChordVM {
    func viewDidLoad()
    func getTotalKeys() -> Int
    func getTotalChords() -> Int
    func didSelectItem(at index: Int)
}

protocol ChordView: AnyObject {
    func reloadKeys(withKeys keys: [String])
    func reloadChords(withChords chords: [String])
    func showErrorMessage(withTitle title: String, message: String)
    func showLoader()
    func hideLoader()
}
