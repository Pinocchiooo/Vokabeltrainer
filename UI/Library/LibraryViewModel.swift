//
//  LibraryViewModel.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 23.03.22.
//

import Foundation

/// manage the data shown in LibraryViewController
class LibraryViewModel: ObservableObject {
    private var observationToken: ObservationToken?
    @Published var vocables: [Vocable] = []

    init() {
        self.updateVocables()
        self.observationToken = VocableStore.instance.observe(do: {[weak self] _ in
            self?.updateVocables()
        })
    }
    
    /// sort the Vocables
    /// - Parameters:
    ///   - option: the way the vocables should be ordered
    ///   - orderDirectionFromLow: determine if the order should be from low to height or not
    /// - Returns: returns an array of the ordered Vocables
    private func getOrderedVocsBy(option: Vocable.filterOption, orderDirectionFromLow: Bool) -> [Vocable] {
        var vocs = vocables
        switch option {
        case .native:
            vocs.sort {
                if orderDirectionFromLow {
                    return $0.native < $1.native
                } else {
                    return $0.native > $1.native
                }
            }
        case .failure:
            vocs.sort {
                if orderDirectionFromLow {
                    return $0.failure < $1.failure
                } else {
                    return $0.failure > $1.failure
                }
            }
        }
        return vocs
    }
    
    /// ordered the vocables into seven vocable arrays in included in one array
    /// - Parameters:
    ///   - orderedBy: the way the vocables should be ordered
    ///   - orderDirectionFromLow: determine if the order should be from low to height or not
    ///   - searchText: the text the user have insert to search specific vocables
    /// - Returns: a array of seven arrays with the ordered vocables splittet by level
    func getVocsInLevelArray(orderedBy: Vocable.filterOption, orderDirectionFromLow: Bool, searchText: String) -> [[Vocable]] {
        var level0: [Vocable] = []
        var level1: [Vocable] = []
        var level2: [Vocable] = []
        var level3: [Vocable] = []
        var level4: [Vocable] = []
        var level5: [Vocable] = []
        var level6: [Vocable] = []
        
        var vocs = getOrderedVocsBy(option: orderedBy, orderDirectionFromLow: orderDirectionFromLow)
        
        if searchText != "" {
            vocs = vocs.filter { voc in
                return voc.native.hasPrefix(searchText) || voc.foreign.hasPrefix(searchText)
            }
        }
        
        for voc in vocs {
            switch voc.level {
            case 0:
                level0.append(voc)
            case 1:
                level1.append(voc)
            case 2:
                level2.append(voc)
            case 3:
                level3.append(voc)
            case 4:
                level4.append(voc)
            case 5:
                level5.append(voc)
            default:
                level6.append(voc)
            }
        }
        return [level0,level1,level2,level3,level4,level5,level6]
    }

    deinit {
        observationToken?.invalidate()
        observationToken = nil
    }
    
    /// update the vocables into the current in VocableStore
    func updateVocables() {
        self.vocables = VocableStore.instance.vocables
        objectWillChange.send()
    }
}
