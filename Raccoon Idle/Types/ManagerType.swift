//
//  ManagerType.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/21/23.
//

import Foundation

enum ManagerType: String, CaseIterable {
    case Manager, Bakery, Factory, DeliveryHub, Salesforce, ThinkTank, InternationalShipping, CookieUniversity, ConvoyOfCookies, CookieGrove

    var name: String {
        rawValue
    }
    
    var pallete: ColorPallette {
        var p: ColorPallette
        switch self {
            case .Bakery: p = ColorPallette.Yellow
            case .ConvoyOfCookies: p = ColorPallette.Blue
            case .CookieUniversity: p = ColorPallette.Green
            case .Manager: p = ColorPallette.Lime
            case .Factory: p = ColorPallette.Orange
            case .DeliveryHub: p = ColorPallette.Pink
            case .Salesforce: p = ColorPallette.Purple
            case .ThinkTank: p = ColorPallette.Red
            case .InternationalShipping: p = ColorPallette.Teal
            case .CookieGrove: p = ColorPallette.Green
        }
        return p
    }

    var allUpgrades: [Upgrade] {
        configData.allUpgrades
    }
    
    var configData: ManagerData {
        switch self {
            case .Bakery:
                return BakeryData.shared
            case .Factory:
                return FactoryData.shared
            case .Salesforce:
                return SalesforceData.shared
            case .ThinkTank:
                return ThinkTankData.shared
            case .InternationalShipping:
                return InternationalShippingData.shared
            case .CookieUniversity:
                return CookieUniversityData.shared
            case .ConvoyOfCookies:
                return ConvoyOfCookiesData.shared
            case .CookieGrove:
                return CookieGroveData.shared
            case .DeliveryHub:
                return DeliveryHubData.shared
            default: return BakeryData.shared
        }
    }
    
    
    init?(rawValue: String?) {
        guard let rawValue = rawValue else { return nil }
        let formattedRaw = rawValue.replacingOccurrences(of: "Manager", with: "").replacingOccurrences(of: " ", with: "")
        guard let value = Self.allCases.first(where: {
            formattedRaw == $0.name
        }) else {
            print("WARN: No Manager Type of name \(rawValue) formatted to \(formattedRaw) found!")
            return nil
        }
        self = value
    }
}

extension ManagerType: Codable {
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        self.init(rawValue: name)!
    }
}
