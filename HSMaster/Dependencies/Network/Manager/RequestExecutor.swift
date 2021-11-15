//
//  RequestExecutor.swift
//  HSMaster
//
//  Created by Davide Ruisi on 06/11/21.
//

import Hydra

/// A protocol for an entry that is responsible of executing a Request and provide a serialized response.
protocol RequestExecutor {
  /// Execute the request.
  func execute<R: Request>(_ request: R) -> Promise<R.ResponseModel>
}
