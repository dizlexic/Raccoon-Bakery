//
//  Manager.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/29/23.
//

import SpriteKit
import Combine

class Manager {
    var id: UUID
    var name: String = "Manager"
    var type: ManagerType
    var character: GameCharacter
    var price: Currency = Currency(type: .Cookies, amount:  200000000)
    var baseIncomePerTick: Currency = Currency(type: .Cookies, amount: 1)
    var baseFrequency: Double = 100
    var frequencyTick: Double = 0.0
    var icons: UpgradeIcons
    var upgrades: [Upgrade] = []
    var owned: Int

    let updateTickPublisher = PassthroughSubject<Wallet?, Never>()
    
    init(name: String, character: GameCharacter? = nil, price: Decimal? = nil, upgrades: [Upgrade]? = nil, owned: Int? = nil) {
        self.id = UUID()
        self.owned = owned ?? 0
        self.character = character ?? .ManagerRaccom
        if let price = price {
            self.price = Currency(type: .Cookies, amount: price )
        }
        self.icons = UpgradeIcons(rawValue: name) ?? UpgradeIcons.Bakery
        self.type = ManagerType(rawValue: name) ?? .Bakery
        self.name = type.name
        self.upgrades = type.allUpgrades
        if let ups = upgrades {
            self.upgrades = self.upgrades.map { upgrade in
                guard let owned = ups.first(where: { $0.id == upgrade.id }) else { return upgrade }
                upgrade.owned = owned.owned
                return upgrade
            }
        }
    }
}

extension Manager {
    var sortedUpgrades: [Upgrade] {
        upgrades.sorted(by: {
            $0.price.amount.isLess(than: $1.price.amount)
        })
    }

    var incomePerTick: Currency {
        let currency = baseIncomePerTick
        let ipt = Currency(type: currency.type, amount: currency.amount).multiplied(by: owned)
        let itters = upgrades.filter({$0.isIterative})
        for upgrade in itters {
            guard upgrade.currecyPerTick.type == currency.type else { continue }
            ipt += upgrade.apply(to: ipt)
        }
        return ipt
    }

    var frequency: Double {
        var frequency = baseFrequency
        let frequencyUpgrades = upgrades.filter { $0.type == .Frequency }
        for upgrade in frequencyUpgrades {
            frequency -= upgrade.frequencyModifier
            if frequency < 0 {
                return 0
            }
        }
        return frequency
    }

    var adjustedPrice: Currency {
        let price = Currency(type: price.type, amount: max(price.amount, pow(price.amount, owned + 1) / 2))
        guard let discounts = getUpgrade(of: .ManagerDiscount) else {
            return price
        }
        let adjustedValue: Currency = Currency(from: price)
        adjustedValue -= discounts.apply(to: adjustedValue)
        return adjustedValue
    }
}

extension Manager {
    func getUpgrade(of type: AppType.OperationType) -> Upgrade? {
        upgrades.first { $0.type == type && $0.owned > 0 }
    }
    
    func doesOwnUpgrade(upgrade: Upgrade) -> Bool {
        upgrades.contains(where: {
            $0.id == upgrade.id
        })
    }
    
    func addUpgrade(upgrade: Upgrade) {
        upgrade.owned += 1
    }
    
    func tick() -> Bool {
        guard frequency > 1 else { return true }
        frequencyTick += 1
        if frequencyTick >= frequency {
            frequencyTick = 0.0
            return true
        }
        return false
    }
    
    func update() {
        guard tick() else { return }
        let wallet = GameData.shared.wallet
        wallet += incomePerTick
        updateTickPublisher.send(wallet)
    }
    
    func calcCPSecond() -> Decimal {
        let ipt = incomePerTick.amount
        let tickRate: Decimal = frequency > 1 ? Decimal(frequency) : 1
        let diff = (ipt / tickRate) * 10 // to raise it from ms to s
        return diff
    }
}
