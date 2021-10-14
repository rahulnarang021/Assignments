//
//  ImageListLoader.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation

protocol ChordClient {
    func loadResults(completion: @escaping (_ data: ChordResult?, _ errorMessage: String?) -> Void)
}

class ChordListLoader: ChordClient {

    let networking: APIManagerInput

    init(networking: APIManagerInput) {
        self.networking = networking
    }

    func loadResults(completion: @escaping (_ data: ChordResult?, _ errorMessage: String?) -> Void) {
        let configuration = ChordResultAPIConfiguration()
        networking.makeAPICall(apiConfiguration: configuration) {[weak self] (result: APIResult<ChordResult>) in
            self?.handleResult(result, completion: completion)
        }
    }

    //MARK: - Result Handling
    private func handleResult(_ result: APIResult<ChordResult>, completion: (_ data: ChordResult?, _ errorMessage: String?) -> Void) {
        switch result {
        case .success(let ChordResults):
            completion(ChordResults, nil)
            break
        case .failure(let error):
            completion(nil, error.message)
            break
        }
    }
}
