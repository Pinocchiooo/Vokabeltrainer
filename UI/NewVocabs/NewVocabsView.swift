//
//  NewVocabsView.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 19.02.22.
//

import SwiftUI
import Introspect

struct NewVocabsView: View {
    
    @State private var foreignVoc: String = ""
    @State private var nativeVoc: String = ""
    @State private var buttonToggled = false
    @State private var presentAlert = false
    
    var body: some View {
        VStack {
            TextField("Muttersprache", text: $nativeVoc)
                .padding()
                .frame(width: Guidelines.cardWidth, height: Guidelines.cardHeight )
                .background(CardView())
                .textFieldFocusableArea()
                .padding()
            TextField("Fremdsprache", text: $foreignVoc)
                .padding()
                .frame(width: Guidelines.cardWidth, height: Guidelines.cardHeight )
                .background(CardView())
                .textFieldFocusableArea()
                .padding()
            Button("Eingabe") {
                if foreignVoc != "" && nativeVoc != "" {
                    let newVoc = Vocable(native: nativeVoc, foreign: foreignVoc)
                    VocableStore.instance.saveNewVocable(vocable: newVoc)
                    foreignVoc = ""
                    nativeVoc = ""
                } else {
                    presentAlert = true
                }
            }
            .buttonStyle(CustomButton())
            .alert(isPresented: $presentAlert) {
                Alert(title: Text("Ups!"), message: Text("Du hast wohl vergessen beide Karten auszufüllen."), dismissButton: .default(Text("Achso")) {
                    presentAlert = false
                })
            }.padding()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
            
            if value.translation.height > 0 {
                hideKeyboard()
            }
        }))
    }
}




