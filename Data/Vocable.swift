//
//  Vocabel.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 20.02.22.
//

import Foundation

struct Vocable: Identifiable, Hashable{
    let id: String
    let native: String
    let foreign: String
    var level: Int
    var failure: Int
    
    /// an enum of options to filter vocables with
    enum filterOption: String, CaseIterable, Identifiable{
        case native = "Muttersprache",
             failure = "Fehlerrate"
        var id: Self { self }
    }
    
    init(native: String, foreign: String) {
        self.id = UUID().uuidString
        self.foreign = foreign
        self.native = native
        self.level = 0
        self.failure = 0
    }
}

extension Vocable {
    init(_ database: DBVocable) {
        self.id = database.id
        self.native = database.native
        self.foreign = database.foreign
        self.failure = database.failure
        self.level = database.level
    }
    
    ///espacially for CSV-formattet init
    init(array: [String]) throws {
        guard let id = array[safe: 0],
              let native = array[safe: 1],
              let foreign = array[safe: 2],
              let level = array[safe: 3],
              let failure = array[safe: 4]
        else {
            throw customError.parsingCSV
        }
        self.id = id
        self.native = native
        self.foreign = foreign
        self.level = Int(level) ?? 0
        self.failure = Int(failure) ?? 0
    }
}

