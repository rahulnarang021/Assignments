//
//  RemoteLoader.swift
//  GelatoImageApp
//
//  Created by RN on 02/07/21.
//

import Foundation

public class RemoteLoader<Resource> {
    public let client: HTTPClient
    public var url: URL?
    private let mapper: Mapper

    public typealias Mapper = (Data?, HTTPURLResponse) throws -> Resource
    public init(url: URL? = nil, client: HTTPClient, mapper: @escaping Mapper) {
        self.url = url
        self.client = client
        self.mapper = mapper
    }

    public typealias ResultType = Swift.Result<Resource, Swift.Error>
    public enum Error: Swift.Error, Equatable {
        case noConnectivity
        case invalidData
        case invalidUrl
    }

    public func load(page: Int, completion: @escaping (ResultType) -> Void) {
        guard let dataUrl = url else {
            completion(.failure(Error.invalidUrl))
            return
        }
        let finalUrl = dataUrl.getURLAddingGetParams(params: ["page": "\(page)"])
        load(url: finalUrl, completion: completion)
    }

    @discardableResult
    public func load(url: URL, completion: @escaping (ResultType) -> Void) -> LoaderTask {
        let task = client.get(url: url) {[weak self]
            result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data, let response):
                do {
                    let responseData = try self.mapper(data, response)
                    completion(.success(responseData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(_):
                completion(.failure(Error.noConnectivity))
            }
        }
      return RemoteLoaderTaskWrapper(task)
    }
}
