//
//  Game.swift
//  Raccoon Idle
//
//  Created by Daniel Moore on 9/21/23.
//

import CoreData
import Combine

@Observable class GameController {
    static let shared = GameController()
    let persistence: PersistenceController
    let playerData: Player
    private var isLoaded = false
    
    var gameLoaded: Bool {
        isLoaded
    }
    private var cancellables = Set<AnyCancellable>()
    
    
    func loadTextures() {
        let tm = TextureManager.shared
    }
    
    func unload() {
        let moc = persistence.moc
        print("Saving Game")
        defer { persistence.save() }
        playerData.unloadedAt = Date.now
        let managers = GameData.shared.ownedManagers
        print("Player currently owns \(managers.count) managers")
        
        // Zero it out? I really should have or need to do this, but expediency.
        playerData.managers = nil
        let managerData = managers.map { rawManager in
            let manager = OwnedManager(context: moc)
            manager.id = rawManager.id
            manager.name = rawManager.name // can initialize type from this i THINK
            manager.owned = Int32(rawManager.owned)

            let upgradeData = rawManager.upgrades.map { rawUpgrade in
                let upgrade = OwnedUpgrade(context: moc)
                upgrade.numId = Int32(rawUpgrade.id)
                upgrade.type = rawUpgrade.type.rawValue
                upgrade.owned = Int32(rawUpgrade.owned)
                print("saving upgrade \(upgrade.numId) \(upgrade.owned)")
                return upgrade
            }
            manager.upgrades = NSSet(array: upgradeData)
            print("Manager owned upgrades count: \(manager.upgrades?.count ?? -1) vs data \(upgradeData.count)")
            return manager
        }
        playerData.managers = NSSet(array: managerData)
        print(playerData.managers?.count ?? "nil")
        
        let upgrades = managers.map { $0.upgrades }
        print("Player Currently owns \(upgrades.count) upgrades (total across all)")
        
        let wallet = GameData.shared.wallet
        playerData.cookies = wallet.getSaveString(for: .Cookies)
        playerData.goldenCookies = wallet.getSaveString(for: .GoldenCookies)
        playerData.chocolateChips = wallet.getSaveString(for: .ChocolateChips)
    }
    
    func load() {
        print("Loading Game")
        defer { playerData.loadedAt = Date.now }
        guard let unloaded = playerData.unloadedAt else { return }
        print("unloaded last as \(unloaded.formatted())")
        guard let managers = playerData.managers?.sortedArray(using: []) as? [OwnedManager] else { return }
        
        var loaded = [Manager]()
        for savedManager in managers {
            guard let baseManager = GameData.shared.allManagers.first(where: { $0.name == savedManager.name }) else { continue }
            guard let ownedUpgrades = savedManager.upgrades?.sortedArray(using: []) as? [OwnedUpgrade] else { continue }
            var upgrades = baseManager.upgrades
            for upgrade in upgrades {
                print(upgrade.owned)
                guard let owned = ownedUpgrades.first(where: {$0.numId == Int32(upgrade.id)}) else {
                    print("no owned upgrade of that type found")
                    continue
                }
                upgrade.owned = Int(owned.owned)
            }
            let basePrice = baseManager.price.amount
            let baseCharacter = baseManager.character
            let manager = Manager(
                name: savedManager.name ?? "NoOpNaMeHx",
                character: baseCharacter,
                price: basePrice,
                upgrades: upgrades,
                owned: Int(savedManager.owned))
            
            loaded.append(manager)
            GameData.shared.ownedManagers = loaded
            GameData.shared.subscribeToOwnedManagerUpdates() // hookup updates?
            print("\(manager.name) manager has \(upgrades.count) upgrades purchased")
        }
        print("found \(loaded.count) manager(s) you own")
        
        print("Doing Nothing :D")
        //loadingPublished.send(completion: true)
        let wallet = GameData.shared.wallet
        let savedWalletValues = [
            Currency(type: .Cookies, amount: playerData.cookies),
            Currency(type: .GoldenCookies, amount: playerData.goldenCookies),
            Currency(type: .ChocolateChips, amount: playerData.chocolateChips),
        ]
        
        for currency in savedWalletValues {
            wallet.setHeld(to: currency)
            var accrued: Currency
            switch currency.type {
                case .Cookies:
                    accrued = GameData.shared.CPTSince(date: unloaded)
                default:
                    accrued = Currency(type: currency.type)
            }
            wallet += accrued
        }
    }
    
    func setupPreloadSub() {
        print("setting up preload subscriber")
        let sub = NotificationCenter.default
            .publisher(for: .progressNotification, object: nil)
            .sink { [weak self] in
                guard let info = $0.userInfo else { return }
                let keys = info.keys.compactMap { $0 as? String }
                for key in keys {
                    switch key {
                        case "complete":
                            self?.isLoaded = true
                            self?.cancellables.first?.cancel()
                        default:
                            print("recieved progress notification1")
                    }
                }
            }
            .store(in: &cancellables)
        
    }
    
    init() {
        persistence = PersistenceController.shared
        playerData = Player.data
        setupPreloadSub()
    }
}
