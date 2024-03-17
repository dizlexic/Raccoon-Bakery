//
//  Player.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/14/23.
//

import CoreData

extension Player {
    static var data: Player = {
        let moc = PersistenceController.shared.moc
        guard let player = try? moc.fetch(Player.fetchRequest()).first else {
            print("No player instance found, creating default player.")
            return createDefaultPlayer()
        }
        return player
    }()
    
    private static func createDefaultPlayer() -> Player {
        guard getPlayerCount() < 1 else {
            print("Warn: create default called while count > 0")
            return data /* I'm going to regret this */
        }
        let moc = PersistenceController.shared.moc
        let player = Player(context: moc)
        // do setup here
        player.id = UUID()
        player.createdAt = Date.now
        player.updatedAt = Date.now
        return player
    }
    
    private static func getPlayerCount() -> Int {
        let moc = PersistenceController.shared.moc
        guard let count = try? moc.count(for: Player.fetchRequest()) else {
            print("Warn: The count function fucked up?")
            return -1
        }
        return count
    }
    
    private static func clearData() {
        let moc = PersistenceController.shared.moc
        let req = Player.fetchRequest()
        guard let res = try? moc.fetch(req) else {
            print("No player data to remove")
            return
        }
        for obj in res {
            moc.delete(obj)
        }
        PersistenceController.shared.save()
    }

}

