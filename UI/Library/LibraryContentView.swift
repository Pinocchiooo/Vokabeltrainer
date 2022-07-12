//
//  LibraryContentView.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 31.03.22.
//

import SwiftUI

struct LibraryContentView: View {
    var levelArray: [[Vocable]]
    var body: some View {
        List {
            if !levelArray[0].isEmpty {
                Section(header: Text("noch nicht gelernt")) {
                    ForEach(levelArray[0]) { voc in
                        LibraryRow(vocable: voc)
                            .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                VocableStore.instance.deleteVocable(vocable: voc)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            if !levelArray[1].isEmpty {
                Section(header: Text("Level 1")) {
                    ForEach(levelArray[1]) { voc in
                        LibraryRow(vocable: voc)
                            .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                VocableStore.instance.deleteVocable(vocable: voc)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            if !levelArray[2].isEmpty {
                Section(header: Text("Level 2")) {
                    ForEach(levelArray[2]) { voc in
                        LibraryRow(vocable: voc)
                            .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                VocableStore.instance.deleteVocable(vocable: voc)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            if !levelArray[3].isEmpty {
                Section(header: Text("Level 3")) {
                    ForEach(levelArray[3]) { voc in
                        LibraryRow(vocable: voc)
                            .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                VocableStore.instance.deleteVocable(vocable: voc)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            if !levelArray[4].isEmpty {
                Section(header: Text("Level 4")) {
                    ForEach(levelArray[4]) { voc in
                        LibraryRow(vocable: voc)
                            .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                VocableStore.instance.deleteVocable(vocable: voc)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            if !levelArray[5].isEmpty {
                Section(header: Text("Level 5")) {
                    ForEach(levelArray[5]) { voc in
                        LibraryRow(vocable: voc)
                            .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                VocableStore.instance.deleteVocable(vocable: voc)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            if !levelArray[6].isEmpty {
                Section(header: Text("Langzeitgedächtnis")) {
                    ForEach(levelArray[6]) { voc in
                        LibraryRow(vocable: voc)
                            .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                VocableStore.instance.deleteVocable(vocable: voc)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }.listStyle(DefaultListStyle())
    }
}
