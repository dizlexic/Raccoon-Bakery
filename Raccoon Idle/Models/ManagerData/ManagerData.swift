//
//  ManagerData.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/8/23.
//

import Foundation

protocol ConfigData: Codable {
    var id: UUID { get }
    var allUpgrades: [Upgrade] { get set }
    var facing: AppType.Direction { get set }
}

class ManagerData: ConfigData {
    let id: UUID
    var allUpgrades: [Upgrade]
    var facing: AppType.Direction
    var initialPosition: CGPoint = .zero
    
    enum CodingKeys: CodingKey {
        case id, upgrades, facing
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(allUpgrades.self, forKey: .upgrades)
        try container.encode(id.self, forKey: .id)
        try container.encode(facing.rawValue.self, forKey: .facing)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.allUpgrades = try container.decode([Upgrade].self, forKey: .upgrades)
        let facing = try container.decode(Int16.self, forKey: .facing)
        self.facing = AppType.Direction(rawValue: facing) ?? .down
    }
    
    init(id: UUID, allUpgrades: [Upgrade], facing: AppType.Direction) {
        self.id = id
        self.allUpgrades = allUpgrades
        self.facing = facing
    }
    
    init(builder factory: ()->[Upgrade], facing direction: AppType.Direction) {
        let id = UUID()
        self.id = id
        self.allUpgrades = factory()
        self.facing = direction
    }
}

class BakeryData: ManagerData {
    static let shared = BakeryData()
    init() {
        let factory = UpgradeFactory.shared
        super.init(builder: factory.createBakeryUpgrades, facing: .down)
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class FactoryData: ManagerData {
    static let shared = FactoryData()
    init() {
        let factory = UpgradeFactory.shared
        super.init(builder: factory.createBakeryUpgrades, facing: .up)
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class DeliveryHubData: ManagerData {
    static let shared = DeliveryHubData()
    init() {
        let factory = UpgradeFactory.shared
        super.init(builder: factory.createBakeryUpgrades, facing: .right)

    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class SalesforceData: ManagerData {
    static let shared = SalesforceData()
    init() {
        let factory = UpgradeFactory.shared
        super.init(builder: factory.createBakeryUpgrades, facing: .down)
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class ThinkTankData: ManagerData {
    static let shared = ThinkTankData()
    init() {
        let factory = UpgradeFactory.shared
        super.init(builder: factory.createBakeryUpgrades, facing: .up)
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class InternationalShippingData: ManagerData {
    static let shared = InternationalShippingData()
    init() {
        let factory = UpgradeFactory.shared
        super.init(builder: factory.createBakeryUpgrades, facing: .down)
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class CookieUniversityData: ManagerData {
    static let shared = CookieUniversityData()
    init() {
        let factory = UpgradeFactory.shared
        super.init(builder: factory.createBakeryUpgrades, facing: .left)
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class ConvoyOfCookiesData: ManagerData {
    static let shared = ConvoyOfCookiesData()
    init() {
        let factory = UpgradeFactory.shared
        super.init(builder: factory.createBakeryUpgrades, facing: .down)

    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class CookieGroveData: ManagerData {
    static let shared = CookieGroveData()
    init() {
        let factory = UpgradeFactory.shared
        super.init(builder: factory.createBakeryUpgrades, facing: .left)
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

