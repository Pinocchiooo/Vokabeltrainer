//
//  LearningViewModel.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 22.02.22.
//

import Foundation
import SwiftUI

///manage the Data shown in Learningsection
class LearningViewModel {
    
    /// contains all the vocables of VocableStore, timeliness is based on the updateVocables() Method
    var vocableSet: [Vocable] = []
    /// provides the learningStatus of each vovable
    var vocablesLearned: [String: Bool] = [:]
    var learningMode: LearningMode
    var levelFilter: Int?
    /// an array contains all levels where vocables be present
    var availableLevel: [Int] {
        get {
            var levelArray: [Int] = []
            for i in 0...5 {
                if getVocAvailable(for: i) {
                    levelArray.append(i)
                }
            }
            return levelArray
        }
    }
    
    /// references the object in UserData
    @AppStorage("changedLearningDirection") var changedLearningDirection = false
    
    /// check whether vocables are available in specific level
    /// - Parameter level: the level to be queried
    /// - Returns: wether a vocable in this level is available
    private func getVocAvailable(for level: Int) -> Bool {
        for voc in vocableSet {
            if voc.level == level {
                return true
            }
        }
        return false
    }
    
    init() {
        self.learningMode = .cover
        self.updateVocables()
    }
    
    /// determine the Index in VocabelSet of this Vocable
    /// - Parameter vocable: the Vocable the index will determined of
    /// - Returns: dhe Index of Vocable if available
    private func getIndexOfVocable(vocable: Vocable) -> Int? {
        return vocableSet.firstIndex(of: vocable)
    }
    
    /// determine the next vocable in VocableSet which has to be lerarned
    /// - Returns: returns the Next Vocable to learn
    func getNextVocable() -> Vocable? {
        return vocableSet.first {vocablesLearned[$0.id] == false}
    }
    
    /// update the vocables level and/ or failure
    /// - Parameters:
    ///   - vocable: the vocable to update
    ///   - correct: whether the learniteration was correct
    func setLearnStateFor( vocable: inout Vocable, correct: Bool) {
        vocablesLearned[vocable.id] = correct
        if let index = getIndexOfVocable(vocable: vocable) {
            if correct {
                vocable.level += 1
            } else {
                vocable.level = 1
                vocable.failure += 1
                vocableSet.remove(at: index)
                vocableSet.append(vocable)
            }
        } else {
            print("couldn't find index from")
        }
    }
    
    /// update the vocable in realm
    /// - Parameter vocable: the vocable to update
    func saveVocable(vocable: Vocable) {
        VocableStore.instance.updateVocable(vocable: vocable)
    }
    
    /// update the VocableSet with the current shuffled Vocables to learn
    func updateVocables() {
        self.vocableSet = VocableStore.instance.vocables
        vocableSet.shuffle()
        for vocable in vocableSet {
            if ((levelFilter == -1 || levelFilter == nil) && vocable.level < 6 || levelFilter != nil  && vocable.level == levelFilter) {
                vocablesLearned[vocable.id] = false
            } else {
                vocablesLearned[vocable.id] = true
            }
        }
    }
}

/// the mode the learningsession can be
enum LearningMode: String, CaseIterable, Identifiable {
    var id: Self { self }
    case memorize = "Einprägen", write = "Schreiben", cover = "Aufdecken"
}

