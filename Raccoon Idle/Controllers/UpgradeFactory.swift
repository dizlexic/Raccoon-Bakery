//
//  UpgradeFactory.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/7/23.
//

import Foundation

enum ModifierType {
    case Global, Manager
}

enum UpgradeType: String {
    case Sub, Add, Multi, Disc
    var op: AppType.OperationType {
        switch self {
            case .Add: return .Additive
            case .Sub: return .Frequency
            case .Disc: return .ManagerDiscount
            case .Multi: return .Multiplicative
        }
    }
    var cookieOp: AppType.OperationType {
        switch self {
            case .Multi: return AppType.OperationType.CPCMulti
            default: return AppType.OperationType.CPCAdd
        }
    }
}

class UpgradeFactory {
    static let shared = UpgradeFactory(initial: 0)
    private var iter: Int
    init(initial count: Int = 0) {
        iter = count > 0 ? count : 0
    }
}

extension UpgradeFactory {


}

//Coin - new bakeries are 50% cheaper
//You have the opportunity to run ghost kitchens from your bakery locations. New bakeries will be 50% cheaper.
extension UpgradeFactory {
    func createBakeryUpgrades() -> [Upgrade] {
        var out: [Upgrade] = []
        iter += 1
        out.append(createShopDiscountUpgrade(iter: iter))
        out.append(createShopDiscountUpgrade2(iter: iter))
        out.append(createCookieUpAddativeUpgrades(iter: iter))
        out.append(createCookieUpMultiplicativeUpgrades(iter: iter))
        out.append(createCookieMultiplierUpgrade(iter: iter))
        out.append(createCookieMultiplierUpgrade2(iter: iter))
        out.append(createCookieMultiplierUpgrade3(iter: iter))
        out.append(createCookieMultiplierUpgrade4(iter: iter))
        out.append(createCookieOneTimeUpgrade(iter: iter))
        return out.sorted(by: {
            $0.price.amount.isLess(than: $1.price.amount)
        })
    }
    
    //TODO
    //Shop -
    //You have landed a good real estate deal and new bakeries are 25% cheaper.
    func createShopDiscountUpgrade(iter: Int, base: Decimal = 10000) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let upgrade = Upgrade(name: "Bakery Discount!",
                              about: "TODO You have landed a good real estate deal and new bakeries are 25% cheaper.",
                              price: price,
                              type: .ManagerDiscount,
                              upgradeIcons: UpgradeIcons.Bakery.iconForImgIndex(.Building),
                              discount: 0.25,
                              id: 1)
        return upgrade
    }
    
    func createShopDiscountUpgrade(for manager: Manager, base: Decimal = 10000) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let upgrade = Upgrade(name: "Bakery Discount!",
                              about: "TODO You have landed a good real estate deal and new bakeries are 25% cheaper.",
                              price: price,
                              type: .ManagerDiscount,
                              upgradeIcons: manager.icons.iconForImgIndex(.Building),
                              discount: 0.25,
                              id: 2)
        return upgrade
    }
    
    
    // TODO
    //Coin - new bakeries are 50% cheaper
    //You have the opportunity to run ghost kitchens from your bakery locations. New bakeries will be 50% cheaper.
    func createShopDiscountUpgrade2(iter: Int, base: Decimal = 9000000) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let upgrade = Upgrade(name: "Coin",
                              about: "TODO You have the opportunity to run ghost kitchens from your bakery locations. New bakeries will be 50% cheaper.",
                              price: price,
                              type: .ManagerDiscount,
                              upgradeIcons: UpgradeIcons.Bakery.iconForImgIndex(.Coins),
                              discount: 0.50,
                              id: 3)
        return upgrade
    }
    
    //Cookie up - cookie clicks makes 1 more cookies per click
    //You can now make 1 more cookie per click
    func createCookieUpAddativeUpgrades(iter: Int, base: Decimal = 50) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let upgrade = Upgrade(name: "Cookie Up",
                              about: "cookie clicks makes 1 more cookies per click",
                              price: price,
                              cpt: nil,
                              type: .CPCAdd,
                              frequencyModifier: nil,
                              cpc: 1.0,
                              upgradeIcons: UpgradeIcons.Bakery.iconForImgIndex(.CookieUp),
                              id: 4)
        return upgrade
    }
    
    // TODO
    //Cookie up - cookie click makes double cookies per click
    //You upgrade your baking prowess and now produce twice as many cookies per click
    func createCookieUpMultiplicativeUpgrades(iter: Int, base: Decimal = 1000) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let upgrade = Upgrade(name: "Cookie Up",
                              about: "TODO You upgrade your baking prowess and now produce twice as many cookies per click",
                              price: price,
                              cpt: nil,
                              type: .CPCMulti,
                              frequencyModifier: nil,
                              cpc: 2.0,
                              upgradeIcons: UpgradeIcons.Bakery.iconForImgIndex(.CookieUp),
                              id: 5)
        return upgrade
    }
    
    //Cookie - bakery produces 10% more cookies
    //you upgrade your bakery ovens and now produce 10% more cookies.
    func createCookieMultiplierUpgrade(iter: Int, base: Decimal = 107500) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let cpt = Currency(type: .Cookies, amount: 0.1)
        let upgrade = Upgrade(name: "Cookie Up",
                              about: "You upgrade your bakery ovens and now produce 10% more cookies.",
                              price: price,
                              cpt: cpt,
                              type: .Multiplicative,
                              upgradeIcons: UpgradeIcons.Bakery.iconForImgIndex(.Cookie),
                              id: 6)
        return upgrade
    }

    func createCookieMultiplierUpgrade2(iter: Int, base: Decimal = 2500) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let cpt = Currency(type: .Cookies, amount: 0.02)
        let upgrade = Upgrade(name: "Lightbulb",
                              about: "Your training retreat energizes your workers and they now produce 2% more cookies",
                              price: price,
                              cpt: cpt,
                              type: .Multiplicative,
                              upgradeIcons: UpgradeIcons.Bakery.iconForImgIndex(.Research),
                              id: 7)
        return upgrade
    }
    
    //Milk - cookies are produced 5% faster
    //You add caffeine to the bakery employee’s milk cooler. They now produce cookies 5% faster.
    func createCookieMultiplierUpgrade3(iter: Int, base: Decimal = 57500) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let cpt = Currency(type: .Cookies, amount: 0.05)
        let upgrade = Upgrade(name: "Milk",
                              about: "you upgrade your bakery ovens and now produce 10% more cookies.",
                              price: price,
                              cpt: cpt,
                              type: .Multiplicative,
                              upgradeIcons: UpgradeIcons.Bakery.iconForImgIndex(.Milk),
                              id: 8)
        return upgrade
    }
    
    //Rocket - cookies are produced twice as fast
    //You offer production incentives to all staff, they now produce cookies twice as fast.
    func createCookieMultiplierUpgrade4(iter: Int, base: Decimal = 575000) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let cpt = Currency(type: .Cookies, amount: 2.0)
        let upgrade = Upgrade(name: "Rocket",
                              about: "You offer production incentives to all staff, they now produce cookies twice as fast.",
                              price: price,
                              cpt: cpt,
                              type: .Multiplicative,
                              upgradeIcons: UpgradeIcons.Bakery.iconForImgIndex(.Boost),
                              id: 9)
        return upgrade
    }
    
    //Clock - whole day of cookies at once?
    //You work over the holiday weekend to produce a whole extra day of cookies at once.
    func createCookieOneTimeUpgrade(iter: Int, base: Decimal = 5000000) -> Upgrade {
        let price = Currency(type: .Cookies, amount: base * Decimal(iter))
        let cpt = Currency(type: .Cookies, amount: 2.0)
        let upgrade = Upgrade(name: "Clock",
                              about: "You work over the holiday weekend to produce a whole extra day of cookies at once.",
                              price: price,
                              cpt: cpt,
                              type: .Multiplicative,
                              upgradeIcons: UpgradeIcons.Bakery.iconForImgIndex(.Time),
                              id: 10)
        return upgrade
    }
    
}
