//
//  Currency.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/21/23.
//

import SpriteKit

final class Currency {
    enum PlaceValue: Int {
        case MissingNo = 0, Hundred, Thousand, Million, Billion, Trillion
        
        var name: String {
            switch self {
                case .Hundred: return "Hundred"
                case .Thousand: return "Thousand"
                case .Million: return "Million"
                case .Billion: return "Billion"
                case .Trillion: return "Trillion"
                default: return "MissingNo"
            }
        }
        
        var exponent: Decimal {
            pow(1, value * 3)
        }
        
        var value: Int {
            self.rawValue
        }
    }
    
    static var Cookies: Currency {
        Currency(type: .Cookies)
    }
    
    var type: CurrencyType
    var amount: Decimal
    
    var formattedValue: String {
        amount.formatted(.number.precision(.fractionLength(0)))
    }
    
    var displayValue: String {
        guard expo > 1 else { return formattedValue }
        return formattedValue
    }
    
    var expo: Int {
        formattedValue.split(separator: ",").count
    }
    
    var placeName: String? {
        PlaceValue(rawValue: expo)?.name
    }
    
    var description: String {
        "\(displayValue) \(type.name)"
    }
    
    required init(type: CurrencyType, amount: Decimal = 20000000) {
        self.type = type
        self.amount = amount
    }
    
    init(type: CurrencyType, amount: String?) {
        self.type = type
        guard let amount = amount else {
            self.amount = .zero
            return
        }
        self.amount = Decimal(string: amount) ?? .zero
    }

    init(from type: CurrencyType) {
        self.type = type
        self.amount = .zero
    }

    init(from currency: Currency) {
        self.type = currency.type
        self.amount = currency.amount
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(CurrencyType.self, forKey: .type)
        let amount = try container.decode(String.self, forKey: .amount)
        self.type = type
        self.amount = Decimal(string: amount) ?? .zero
    }
}

extension Currency: Equatable, Hashable {
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        lhs.amount == rhs.amount && lhs.type == rhs.type
    }
    
    public static func != (lhs: Currency, rhs: Currency) -> Bool {
        lhs.amount != rhs.amount || lhs.type != rhs.type
    }
    
    public static func <= (lhs: Currency, rhs: Currency) -> Bool {
        lhs.amount.isLess(than: rhs.amount)
    }
    
    public static func >= (lhs: Currency, rhs: Currency) -> Bool {
        rhs.amount.isLess(than: lhs.amount)
    }
    
    func isEqual(_ currency: Currency) -> Bool {
        self == currency
    }
    
    func isLess(than currency: Currency) -> Bool {
        self.amount.isLess(than: currency.amount)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(amount)
    }
}

extension Currency {
    public static func += (lhs: Currency, rhs: Currency) {
        lhs.amount += rhs.amount
    }
    
    public static func -= (lhs: Currency, rhs: Currency) {
        lhs.amount -= rhs.amount
    }
    
    public static func *= (lhs: Currency, rhs: Currency) {
        lhs.amount *= rhs.amount
    }
    
    public static func /= (lhs: Currency, rhs: Currency) {
        lhs.amount /= rhs.amount
    }
}

extension Currency {
    public static func += (lhs: Currency, rhs: Decimal) {
        lhs.amount += rhs
    }
    
    public static func -= (lhs: Currency, rhs: Decimal) {
        lhs.amount -= rhs
    }
    
    public static func *= (lhs: Currency, rhs: Decimal) {
        lhs.amount *= rhs
    }
    
    public static func /= (lhs: Currency, rhs: Decimal) {
        lhs.amount /= rhs
    }
}

extension Currency {
    func adding(currency: Currency) -> Currency {
        guard currency.type == self.type else { return Currency(from: self) }
        let amount = self.amount + currency.amount
        return Self.init(type: self.type, amount: amount)
    }
    
    func subtracting(currency: Currency) -> Currency {
        guard currency.type == self.type else { return Currency(from: self) }
        let amount = self.amount - currency.amount
        return Self.init(type: self.type, amount: amount)
    }
    
    func multiplied(by currency: Currency) -> Currency {
        guard currency.type == self.type else { return Currency(from: self) }
        let amount = self.amount * currency.amount
        return Self.init(type: self.type, amount: amount)
    }
    
    func multiplied(by number: Int) -> Currency {
        multiplied(by: Decimal(number))
    }
    
    func multiplied(by number: Decimal) -> Currency {
        Currency(type: self.type, amount: self.amount * number)
    }
    
    func divided(by currency: Currency) -> Currency {
        guard currency.type == self.type else { return self }
        let amount = self.amount / currency.amount
        return Self.init(type: self.type, amount: amount)
    }
    
    func createIcon(at position: CGPoint,ofSize size: CGSize,withPhysics physics: Bool=false, animated: Bool=false) -> SKSpriteNode {
        let sprite = SKSpriteNode(texture: type.texture, size: size)
        sprite.position = position
        if physics {
            sprite.physicsBody = SKPhysicsBody(texture: type.texture, size: size)
            if let body = sprite.physicsBody {
                body.isDynamic = true
                body.categoryBitMask = .CoinBitMask
                body.contactTestBitMask = .CharacterBitMask
                body.collisionBitMask = .WallBitMask
                body.fieldBitMask = .CharacterBitMask
            }
        }
        return sprite
    }
}

extension Currency: Codable {
    enum CodingKeys: String, CodingKey {
        case type, amount
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let amount = formattedValue
        try container.encode(type.name, forKey: .type)
        try container.encode(formattedValue, forKey: .amount)
    }

}
