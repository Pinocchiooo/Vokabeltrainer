
//
//  ContentView.swift
//  Shared
//
//  Created by Adriano Brunster on 19.02.22.
//

import SwiftUI

struct TabViewController: View {
    
    var body: some View {
        TabView {
            NewVocabsView()
                .tabItem {
                    Label("Neue Vokabeln", systemImage: "plus")
                }
            LearningStartSessionViewController()
                .tabItem {
                    Label("Lernen", systemImage: "cloud")
                }
            LibraryViewController()
                .tabItem {
                    Label("Bibliothek", systemImage: "books.vertical")
                }
            SettingsView()
                .tabItem {
                    Label("Einstellungen", systemImage: "gearshape")
                }
        }
    }
}

