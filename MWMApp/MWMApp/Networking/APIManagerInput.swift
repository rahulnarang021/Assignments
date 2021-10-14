//
//  APIManagerInput.swift
//  MWMApp
//
//  Created by RAHUL on 19/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation
protocol APIManagerInput {// Impelemented by APIManager to make api call
    func makeAPICall<T: Decodable>(apiConfiguration: APIConfiguration, completion: @escaping ((APIResult<T>) -> ()))
}
