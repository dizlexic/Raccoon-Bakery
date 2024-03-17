//
//  Upgrade.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 9/26/23.
//

import SpriteKit

extension Upgrade: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, about, cpt, cpcm, fm, owned, price, discount, icons, operation
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.self, forKey: .id)
    }
    
}

class Upgrade: Identifiable {
    let id: Int
    let name: String
    let about: String
    var price: Currency
    var currecyPerTick: Currency
    var frequencyModifier: Double = 0.0
    var cpcModifier: Currency
    var discount: [Currency] = []
    let type: AppType.OperationType
    let icons: [SKTexture]
    var owned: Int = 0
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decodeIfPresent(Int.self, forKey: .id)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let about = try container.decodeIfPresent(String.self, forKey: .about)
        let price = try container.decodeIfPresent(Currency.self, forKey: .price)
        let cpt = try container.decodeIfPresent(Currency.self, forKey: .cpt)
        let frequency = try container.decodeIfPresent(Double.self, forKey: .fm)
        let cpcm = try container.decodeIfPresent(Currency.self, forKey: .cpcm)
        let discount = try container.decodeIfPresent([Currency].self, forKey: .discount)
        let owned = try container.decodeIfPresent(Int.self, forKey: .owned)
        let icons = try container.decodeIfPresent([String].self, forKey: .icons)
        let ot = try container.decodeIfPresent(Int.self, forKey: .operation)
        
        self.id = id ?? -1
        self.name = name ?? "missingno"
        self.about = about ?? "missingno"
        self.currecyPerTick = cpt ?? Currency(type: .Cookies, amount: .zero)
        self.frequencyModifier = frequency ?? .zero
        self.cpcModifier = cpcm ?? Currency(type: .Cookies, amount: .zero)
        self.discount = discount ?? []
        self.type = AppType.OperationType(rawValue: Int16(ot ?? -1)) ?? .Additive
        self.icons = icons?.compactMap({ SKTexture(imageNamed: $0) }) ?? []
        self.price = price ?? Currency(type: .Cookies)
    }
    
    var adjustedPrice: Currency {
        let price = Currency(type: price.type, amount: max(price.amount, pow(price.amount, owned + 1) / 2))
        return price
    }
    
    var texture: SKTexture? {
        GameData.shared.canPurchaseUpgrade(upgrade: self) ? icons.first : icons.last
    }
    
    var isIterative: Bool {
        switch type {
            case .Additive, .Multiplicative:
                return true
            default:
                return false
        }
    }
    
    func apply(to currency: Currency) -> Currency {
        let out = Currency(from: currency)
        switch type {
            case .Additive:
                out += currecyPerTick.multiplied(by: owned)
            case .Multiplicative:
                out += currecyPerTick.multiplied(by: owned)
            case .CPCAdd:
                out += cpcModifier.multiplied(by: owned)
            case .CPCMulti:
                out += cpcModifier.multiplied(by: owned)
            case .ManagerDiscount:
                out -= discount.reduce(Currency(from: out), {
                    $0.subtracting(currency: $0.multiplied(by: $1))
                })
            case .Frequency:
                break //NOOP
        }
        if out <= currency {
            if type != .ManagerDiscount {
                print("Warn: Appling upgrade out var is <= in var. This probably shouldn't happen.")
            }
        }
        return out
    }
    
    func apply(to interval: TimeInterval) -> TimeInterval {
        guard interval > 0 else { return 0 }
        return interval - interval * frequencyModifier
    }
    
    init(name: String,
         about: String? = nil,
         price: Currency? = nil,
         cpt: Currency? = nil,
         type: AppType.OperationType? = nil,
         frequencyModifier: Double? = nil,
         cpc: Decimal? = nil,
         upgradeIcons: [SKTexture]? = nil,
         discount: Decimal? = nil,
         id: Int? = nil) {
        self.id = id ?? 0
        self.name = name
        self.price = price ?? Currency(type: .Cookies, amount: 0)
        self.currecyPerTick = cpt ?? Currency(type: .Cookies, amount: 0)
        self.type = type ?? .Additive
        self.frequencyModifier = frequencyModifier ?? 0.0
        let cpc = cpc ?? 0.0
        self.cpcModifier = Currency(type: .Cookies, amount: cpc)
        self.icons = upgradeIcons ?? UpgradeIcons.Bakery.iconForImgIndex(0)
        self.about = about ?? "no about provided"
        let discount = discount ?? 0
        self.discount.append(Currency(type: .Cookies, amount: discount))
    }
}

extension Upgrade: Equatable, Hashable {
    static func == (lhs: Upgrade, rhs: Upgrade) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Upgrade {
    static func +=(lhs: inout Upgrade, rhs: Upgrade) {
        switch lhs.type {
            case .CPCAdd, .CPCMulti:
                lhs.cpcModifier += rhs.cpcModifier
            case .Additive, .Multiplicative:
                lhs.currecyPerTick.amount += rhs.currecyPerTick.amount
            case .ManagerDiscount:
                lhs.discount += rhs.discount
            case .Frequency:
                lhs.frequencyModifier += rhs.frequencyModifier
        }
    }
}

extension Upgrade {
    func isLess(than upgrade: Upgrade) -> Bool {
        self.price.isLess(than: upgrade.price)
    }
}


