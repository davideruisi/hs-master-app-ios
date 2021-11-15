//
//  Data+Extension.swift
//  HSMaster
//
//  Created by Davide Ruisi on 14/11/21.
//

import Foundation

extension Data {
  /// Pretty print JSON Data.
  var prettyPrintedJSONString: NSString? {
    guard
      let object = try? JSONSerialization.jsonObject(with: self, options: []),
      let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
      let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    else {
      return nil
    }

    return prettyPrintedString
  }
}
