//
//  SettingsView.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 19.02.22.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var presentAlert = false
    @State var presentError: Bool = false
    @State var presentDelete: Bool = false
    @State var presentImportError: Bool = false
    @State var presentImportSuccess: Bool = false
    @State private var openFile: Bool = false
    /// references the object in UserData
    @AppStorage("changedLearningDirection") private var changedLearningDirection = false
    
    var body: some View {
        List() {
            HStack {
                Text("Export")
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                export()
            }
            HStack {
                Text("Import")
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.openFile = true
            }
            HStack {
                Text("Umgekehrte Abfragerichtung")
                Spacer()
                Toggle("", isOn: $changedLearningDirection)
            }
            HStack {
                Text("Alle Vokabeln löschen")
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                presentDelete = true
                presentAlert = true
            }
        }
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.commaSeparatedText]) { (res) in
            do {
                openFile = false
                let fileUrl = try res.get()
                do {
                    try VocableStore.instance.importVocable(url: fileUrl)
                    presentAlert = true
                    presentImportSuccess = true
                } catch {
                    presentAlert = true
                    presentImportError = true
                }
            } catch {
                print("Error reading file")
                print(error.localizedDescription)
            }
        }
        .alert(isPresented: $presentAlert) {
            /* all Alert of the settingsection will be defined here and can be called with
             "presentAlert = true" and turning true the specific presentState
             */
            if presentDelete {
                return Alert(
                    title: Text("Ganz sicher?"),
                    message: Text("Möchtest du wirklich alle deine Vokabeln löschen?"),
                    primaryButton: .default(Text("Nein, lieber nicht."), action: {
                        presentAlert = false
                        presentDelete = false
                    }),
                    secondaryButton: .destructive(Text("Ja, bitte löschen."), action: {
                        VocableStore.instance.deleteAllVocables()
                        presentAlert = false
                        presentDelete = false
                        
                    })
                )
            } else if presentError {
                return Alert(title: Text("Ups!"), message: Text("Leider hat der Export nicht funktioniert."), dismissButton: .default(Text("Okay.")) {
                    presentAlert = false
                    presentError = false
                })
            } else if presentImportError {
                return Alert(title: Text("Ohje."), message: Text("Das Importieren hat leider nicht funktioniert. Um zu sehen wie das richtige Format aussieht, exportiere zunächst deine Vokabeln."), dismissButton: .default(Text("Okay.")) {
                    presentAlert = false
                    presentImportError = false
                })
            } else {
                return Alert(title: Text("Cool!"), message: Text("Deine Vokabelliste wurde angepasst."), dismissButton: .default(Text("Danke.")) {
                    presentAlert = false
                    presentImportSuccess = false
                })
            }
        }
    }
    
    /// export all vocables into an csv-file on the place the user will choose
    func export() {
        guard let url = VocableStore.instance.exportVocable() else {
            presentError = true
            presentAlert = true
            return
        }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        UIApplication.shared .windows.first?.rootViewController?.present(activityVC, animated: true, completion: {
        })
    }
    
}
