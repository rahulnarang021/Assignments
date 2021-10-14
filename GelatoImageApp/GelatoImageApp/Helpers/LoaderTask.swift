//
//  RemoteLoaderTask.swift
//  GelatoImageApp
//
//  Created by RN on 09/07/21.
//

import Foundation
public protocol LoaderTask {
    func cancel()
}

class RemoteLoaderTaskWrapper: LoaderTask {
  let task: HTTPClientTask
  init(_ task: HTTPClientTask) {
    self.task = task
  }

  func cancel() {
    task.cancel()
  }
}
