//
//  GameData.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/23/23.
//

import SwiftUI
import SpriteKit
import Combine

enum GameCharacter: String {
    case ManagerRaccom, Raccoon, Mouse

    var string: String {
        self.rawValue
    }
    
    var textureName: String {
        switch self {
            case .ManagerRaccom:
                return "Raccoon"
            default:
                return self.string
        }
    }
}

@Observable
class GameConfiguration {
    static let shared = GameConfiguration()
    var size = CGSize.zero
    var safeArea: EdgeInsets?
}

@Observable
class GameData {
    static let shared = GameData()

    let allManagers: [Manager] = [
        Manager(name: "Bakery", price: 50),
        Manager(name: "Factory", price: 50000),
        Manager(name: "Delivery Hub", price: 100000),
        Manager(name: "Salesforce", price: 500000),
        Manager(name: "Think Tank", price: 1000000),
        Manager(name: "International Shipping", price: 5000000),
        Manager(name: "Cookie University", price: 10000000),
        Manager(name: "Convoy Of Cookies", price: 100000000),
        Manager(name: "Cookie Grove", price: 500000000),
    ]
    
    private var cancellables: Set<AnyCancellable> = []

    private var perClick: [Currency] = [Currency(type: .Cookies, amount: 1)]
    
    let updateManagerPublisher = PassthroughSubject<Wallet?, Never>()

    var ownedManagers: [Manager]

    var selectedManager: Manager? = nil

    var updatedAt: Date? = nil
    
    var activeOverlay: String? = nil
    
    var isLoading: Bool = true

    var wallet: Wallet
    var wallStore: Currency? = nil
    var frameList: [Manager] {
        let unowned = allManagers.filter { manager in
            !ownedManagers.contains(where: { owned in
                owned.name == manager.name
            })
        }
        if unowned.count > 0 {
            return ownedManagers + [unowned[0]]
        }
        return ownedManagers
    }
    
    var cpc: Currency {
        let base = perClick.first { $0.type == .Cookies } ?? Currency(type: .Cookies)
        let cpc = Currency(from: base)
        
        let upgrades = ownedManagers.flatMap {
            $0.upgrades.filter {
                $0.type == .CPCAdd || $0.type == .CPCMulti
            }
        }
        
        let addative = upgrades.filter {
            $0.type == .CPCAdd && $0.owned > 0
        }.reduce(Currency(from: CurrencyType.Cookies)) {
            $0.adding(currency: $1.cpcModifier)
        }
        
        print("Computed additives \(addative.amount)")
        
        let multipliers = upgrades.filter {
            $0.type == .CPCMulti && $0.owned > 0
        }.reduce(Currency(type: .Cookies, amount: 0)) {
            $0.adding(currency: $1.cpcModifier.multiplied(by: $1.owned))
        }
        
        print("Computer multipliers \(multipliers.amount)")
        
        cpc += addative
        
        if multipliers.amount > 0 {
            cpc *= multipliers
        }
        
        return cpc
    }
    
    
    func touchCookie(times: Int = 1) {
        wallet += cpc
    }
    
    
    func doesOwnManager(named name: String?) -> Bool {
        guard let name = name?.replacingOccurrences(of: "Manager", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        else {
            return true /// if this is nil sure they own nil who doesnt?
                        /// this is probably a bad way to write this for readability but
                        /// fuck it :D
        }

        return ownedManagers.contains(where: { $0.name == name })
    }
    
    func getManagerFromCharacter(named name: String?) -> Manager? {
        guard let name = name?.replacingOccurrences(of: "Manager", with: "") else {
            print("Could not find manager by name \(name ?? "")")
            return nil
        }
        return getManager(named: name.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func getManager(named name: String?) -> Manager? {
        return allManagers.first(where: {
            $0.name == name
        })
    }
    
    func canPurchaseManager(manager: Manager) -> Bool {
        return wallet >= manager.adjustedPrice
    }
    
    func canPurchaseUpgrade(upgrade: Upgrade) -> Bool {
        return wallet >= upgrade.adjustedPrice
    }
    
    func updateSelectedManagerByCharacter(character: SKSpriteNode?) {
        self.selectedManager = getManagerFromCharacter(named: character?.name)
    }
    
//    func getWallet(for currencyType: Currency.CurrencyType) -> Currency? {
//        wallet.first(where: {
//            $0.type == currencyType
//        })
//    }
    
    func purchaseManager(manager: Manager) {
        wallet -= manager.adjustedPrice
        manager.owned += 1
        updateManagerPublisher.send(wallet)
        if doesOwnManager(named: manager.name) {
            return
        }
        ownedManagers.append(manager)
        subscribeToOwnedManagerUpdates()
    }

    func purchaseUpgrade(upgrade: Upgrade, for manager: Manager) {
        guard canPurchaseUpgrade(upgrade: upgrade) else { return }
        wallet -= upgrade.adjustedPrice
        
        manager.addUpgrade(upgrade: upgrade)
        updateManagerPublisher.send(wallet)
    }
    
    func subscribeToOwnedManagerUpdates() {
        for manager in ownedManagers {
            manager.updateTickPublisher
                .debounce(for: 0.1, scheduler: RunLoop.main)
                .sink(receiveValue: { [weak self] in
                    guard let pub = self?.updateManagerPublisher else { return }
                    pub.send($0)
                })
                .store(in: &cancellables)
        }
    }
    
    /// returns the Cookies Per Tick in date range
    /// origianlly only returned from start to now
    /// ```
    /// CPTSince(Date.now) // 0
    /// ```
    /// > Warning name is misleading it's CPT in range, but to is default to Date.now
    ///
    /// - Parameters:
    ///     - Date date: Start date for range
    ///     - Date to: End date for range defaults to Date.now
    /// - Returns: Decimal Calulated total Cookies Per Tick accumulated in date range Rounded Whole Decimal `rounded`.
    func CPTSince(date start: Date, to end: Date = Date.now) -> Currency {
        let cpt: Decimal = ownedManagers.map {
            $0.calcCPSecond()
        }.reduce(0, +)
        let interval = end.timeIntervalSince(start)
        var cpi = Decimal(interval) * cpt
        var rounded = Decimal()
        NSDecimalRound(&rounded, &cpi, 0, .bankers) // Decimal rounding is weird and scary 2 pointers, remainder, and a mode.
        return Currency(type: .Cookies, amount: rounded)
    }
    
    init() {
        let currencies = CurrencyType.allCases.map(Currency.init)
        wallet = Wallet(currencies: currencies)
        let data = Player.data
        print(data.debugDescription)
        
        ownedManagers = [] // load from CD stack
    }
}

