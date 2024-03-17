//
//  Array.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/23/23.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        let count = self.count
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
