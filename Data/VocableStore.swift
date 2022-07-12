//
//  VocableStore.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 20.02.22.
//

import RealmSwift
import PromiseKit
import Combine
import SwiftUI

/// Singleton-Class for holding and operate with the up to date Vocables
class VocableStore: Observable {
    
    static let instance = VocableStore()
    
    var observers: [ObservationToken: ((Void)) -> Void] = [:]
    typealias Observed = Void
    
    private var vocableNotificationToken: NotificationToken? = nil
    
    // private init for prevent using this class except as an singelton
    private init() {
        fetchRealm()
    }
    
    deinit {
        vocableNotificationToken?.invalidate()
    }
    
    /// should always the latest array of all Vocables written in realm
    private(set) var vocables: [Vocable] = []
    
    
    /// update vocables with realm objects
    private func fetchRealm() {
        do {
            let realm = try Realm()
            self.vocables = realm.objects(DBVocable.self).map{ Vocable.init($0) }
            self.informObservers(())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// write Vocables into realm
    /// - Parameter vocable: Vocables to save
    func saveNewVocable(vocable: Vocable) {
        DispatchQueue.global().async { [weak self] in
            do {
                let realm = getDefaultRealm(on: Thread.current)
                let dbvocable = DBVocable.init(vocable)
                
                try realm?.write {
                    realm!.add(dbvocable, update: .all)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            self?.fetchRealm()
        }
    }
    
    
    /// import new vocables from csv-file
    /// - Parameter url: the url of the csv-file
    func importVocable(url: URL) throws {
        guard url.startAccessingSecurityScopedResource() else {
            throw customError.loadingURL
        }
        do {
            let content = try String(contentsOfFile: url.path)
            print(content)
            url.stopAccessingSecurityScopedResource()
            do {
                try parseVocableFromCSV(data: content)
            } catch {
                throw customError.parsingCSV
            }
        } catch {
            throw customError.loadingURL
        }
    }
    
    
    /// data will be parsed into Vocables and saved in realm
    /// - Parameter data: the content of an csv-file
    private func parseVocableFromCSV(data: String) throws  {
        var rows = data.components(separatedBy: "\n")
        
        let columnCount = rows.first?.components(separatedBy: ";").count
        //remove header row
        if rows.first == "ID;Muttersprache;Fremdsprache;Stufe;Fehlerrate" {
            rows.removeFirst()
        }
        
        for row in rows {
            let csvColumns = row.components(separatedBy: ";")
            if columnCount == csvColumns.count {
                if vocables.filter({ voc in
                    return voc.id == csvColumns[0]
                }).isEmpty {
                    do {
                        saveNewVocable(vocable: try Vocable.init(array: csvColumns))
                    } catch {
                        throw customError.parsingCSV
                    }
                }
            }
        }
    }
    
    
    /// creates an csv-file with all VocableData of the store
    /// - Returns: gives the url of the created csv-file
    func exportVocable() -> URL? {
        var csvString = "\("ID");\("Muttersprache");\("Fremdsprache");\("Stufe");\("Fehlerrate")\n"
        for vocable in vocables {
            csvString = csvString.appending("\(String(describing: vocable.id));\(String(describing: vocable.native));\(String(describing: vocable.foreign));\(String(describing: String(vocable.level)));\(String(describing: String(vocable.failure)))\n")
        }
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("Vokabeln.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV Export succsessed")
            return fileURL
        } catch {
            print("error creating file")
            return nil
        }
    }
    
    /// updates a specific vocabel based on its ID
    /// - Parameter vocable: vocable which has to be updated
    func updateVocable(vocable: Vocable) {
        DispatchQueue.global().async { [weak self] in
            do {
                let dbvocable = DBVocable.init(vocable)
                
                let realm = try! Realm()
                let currentVoc = realm.objects(DBVocable.self).filter("id = %@", vocable.id).first
                
                if let voc = currentVoc {
                    try realm.write {
                        voc.failure = dbvocable.failure
                        voc.level = dbvocable.level
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            self?.fetchRealm()
        }
    }
    
    /// Delete a specific Vokable from Realm
    /// - Parameter vocable: the vocable which has to be deletet
    func deleteVocable(vocable: Vocable) {
        DispatchQueue.global().async { [weak self] in
            do {
                let realm = try! Realm()
                let currentVoc = realm.objects(DBVocable.self).filter("id = %@", vocable.id).first
                
                if let voc = currentVoc {
                    try realm.write {
                        realm.delete(voc)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            self?.fetchRealm()
        }
    }
    
    /// delete all Data written in Realm
    func deleteAllVocables() {
        DispatchQueue.global().async { [weak self] in
            do {
                let realm = try! Realm()
                try realm.write {
                    realm.deleteAll()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            self?.fetchRealm()
        }
    }
}
