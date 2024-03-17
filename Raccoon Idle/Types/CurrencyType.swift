//
//  CurrencyType.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/21/23.
//

import SpriteKit

enum CurrencyType: String, CaseIterable {
    case Cookies
    case GoldenCookies
    case ChocolateChips

    var texture: SKTexture {
        switch self {
            default:
                SKTexture(imageNamed: "Cookie")
        }
    }

    var name: String {
        self.rawValue
    }

    init?(name: String?) {
        guard let name = name else { return nil }
        self.init(rawValue: name)
    }
}

extension CurrencyType: Codable {
    enum CodingKeys: CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        self.init(name: name)!
    }
}
