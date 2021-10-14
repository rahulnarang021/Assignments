//
//  ChordResult.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation
struct ChordResult: Decodable {
    var allkeys: [ChordKey]
    var allchords: [Chords]
}

struct ChordKey: Decodable {
    var keyid: Int
    var name: String
    var keychordids: [Int]
}

struct Chords: Decodable {
    var chordid: Int
    var suffix: String
    var midi: [Int]
    var fingers: [Int]
}
