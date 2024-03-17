//
//  SetupCapable.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/27/23.
//

import Foundation

protocol SetupCapable {
    typealias SetupMethods = ()->Void
    var isSetup: Bool { get set }
    var setupsToRun: [()->Void] { get set }
    func setup() throws -> Void
}

protocol UpdateCapable {
    var lastInterval: TimeInterval { get set }
    var delta_time: TimeInterval { get set }
    var updateTimeInterval: TimeInterval { get }
    var updateCounter: TimeInterval { get set }

    func update(timeInterval: TimeInterval) -> Void
    func updateTick(timeInterval: TimeInterval) -> Bool
}
