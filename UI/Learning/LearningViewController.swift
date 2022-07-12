//
//  LearningViewController.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 27.02.22.
//

import SwiftUI
import RealmSwift

struct LearningViewController: View {
    var learningViewModel: LearningViewModel
    @State var currentVocable: Vocable
    @State var presentAlert = false
    @State var aufgedeckt = false
    @Environment(\.presentationMode) var presentation
    @Binding var sessionActive: Bool
    @State var textField = ""
    @State var wrightSpellt = false
    @State var sessionFinished = false
    @State var submit = false
    
    
    var body: some View {
        VStack {
            ZStack {
                if learningViewModel.learningMode == .write {
                    LearningCardsWrite(aufgedeckt: $aufgedeckt, native: currentVocable.native, foreign: currentVocable.foreign, textField: $textField, submit: $submit, presentAlert: $presentAlert, learningDirectionChanged: learningViewModel.changedLearningDirection)
                } else {
                    LearningCards(native: currentVocable.native, foreign: currentVocable.foreign, aufgedeckt: $aufgedeckt, learningDirectionChanged: learningViewModel.changedLearningDirection)
                }
            }
            .alert(isPresented: $presentAlert) {
                if sessionFinished == true {
                    return Alert(title: Text("Hurra!"), message: Text("Du hast alle Vokabeln des Sets gelernt."), dismissButton: .default(Text("Jeah!")) {
                        sessionActive = false
                    })
                } else if currentVocable.foreign.uppercased() == textField.uppercased() && !learningViewModel.changedLearningDirection || currentVocable.native.uppercased() == textField.uppercased() && learningViewModel.changedLearningDirection{
                    return Alert(title: Text("Richtig!"), message: Text("Du hast die Vokabel richtig geschrieben."), dismissButton: .default(Text("Cool!")) {
                        saveAndNext(correct: true)
                    })
                } else {
                    return Alert(title: Text("Falsch."), message: Text("Richtige Lösung: " + (!learningViewModel.changedLearningDirection ? currentVocable.foreign: currentVocable.native)), dismissButton: .default(Text("Okay.")) {
                        saveAndNext(correct: false)
                    })
                }
            }.padding()
            if learningViewModel.learningMode == .write {
                Button("Prüfen") {
                    aufgedeckt = true
                    presentAlert = true
                }
                .buttonStyle(CustomButton())
            }
            else if aufgedeckt {
                switch learningViewModel.learningMode {
                case .cover:
                    HStack {
                        Button("Falsch") {
                            saveAndNext(correct: false)
                        }
                        .buttonStyle(CustomButton())
                        Button("Richtig") {
                            saveAndNext(correct: true)
                        }
                        .buttonStyle(CustomButton())
                    }
                case .write:
                    EmptyView()
                case .memorize:
                    Button("Gemerkt") {
                        saveAndNext(correct: true)
                    }
                    .buttonStyle(CustomButton())
                }
            } else {
                Button("Aufdecken") {
                    aufgedeckt = true
                }
                .buttonStyle(CustomButton())
            }
        }
    }
    
    /// hand in the current Vocable to LearningViewModel and update the currentVocable or end the Learningsession
    /// - Parameter correct: whether the vocable has been guessed correctly
    func saveAndNext(correct: Bool) {
        learningViewModel.setLearnStateFor(vocable: &currentVocable, correct: correct)
        learningViewModel.saveVocable(vocable: currentVocable)
        if let currentVocable =  learningViewModel.getNextVocable() {
            self.currentVocable = currentVocable
            aufgedeckt = false
        } else {
            sessionFinished = true
            presentAlert = true
        }
    }
}
