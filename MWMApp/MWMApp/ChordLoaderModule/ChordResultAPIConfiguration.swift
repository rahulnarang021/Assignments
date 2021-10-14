//
//  ChordResultAPIConfiguration.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation

struct ChordResultAPIConfiguration: APIConfiguration {
    func getGetParams() -> [String : String?]? {
        return nil
    }

    func getHeaders() -> [String : String]? {
        return nil
    }

    func getUrl() -> URL {
        return URL(string: ChordResultAPIConstants.url)!
    }

    func getRequestType() -> RequestType {
        return .GET
    }

    func getRequestTimeout() -> TimeInterval {
        return ChordResultAPIConstants.timeout
    }

    func getPostParams() -> [String : Any?]? {
        return nil
    }
}

enum ChordResultAPIConstants {
    static let url: String = "https://europe-west1-mwm-sandbox.cloudfunctions.net/midi-chords"
    static let timeout: TimeInterval = 5.0//hardcoded timeout
}
