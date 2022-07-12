//
//  RealmMigrator.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 20.02.22.
//

import Foundation
import RealmSwift

enum RealmMigrator {
    static private func migrationBlock(
        migration: Migration,
        oldSchemaVersion: UInt64
    ) {
        //Add migration logic on database changes
    }
    
    static func setDefaultConfiguration() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: migrationBlock)
        Realm.Configuration.defaultConfiguration = config
    }
}

func getDefaultRealm(on thread: Thread = Thread.main) -> Realm? {
    if Thread.current == thread {
        return try? Realm()
    }
    fatalError("Only reachable via specified thread")
}
