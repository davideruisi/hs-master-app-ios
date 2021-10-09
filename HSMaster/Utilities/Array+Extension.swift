//
//  Collection+Extension.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/10/21.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
