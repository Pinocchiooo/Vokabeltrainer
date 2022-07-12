//
//  DBVocable.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 20.02.22.
//

import RealmSwift

/// VocableFormat for saving in realm
class DBVocable: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var native: String = ""
    @objc dynamic var foreign: String = ""
    @objc dynamic var level: Int = 0
    @objc dynamic var failure: Int = 0
    
 
    override static func primaryKey() -> String? {
        "id"
    }
}

extension DBVocable {
    convenience init(_ model: Vocable) {
        self.init()
        self.id = model.id
        self.native = model.native
        self.foreign = model.foreign
        self.level = model.level
        self.failure = model.failure
    }
}
