//
//  LearningStartSessionView.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 23.02.22.
//

import SwiftUI

struct LearningStartSessionViewController: View {
    
    @State var learningMode: LearningMode = .cover
    @State var useFilter: Bool = false
    @State var levelFilter = -1
    var learningViewModel = LearningViewModel()
    @State var presentAlert = false
    @State var learningSessionActive = false
    @State var firstVoc: Vocable = Vocable(DBVocable())
    @State var availableLevels: [Int]?
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Text("Lernmethode: ")
                    Spacer()
                    Picker("LernmethodeFilter", selection: $learningMode) {
                        ForEach(LearningMode.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray4))
                    .cornerRadius(Guidelines.cornerRadius)
                    .padding(.horizontal, 10)
                }
                .padding()
                Toggle("Vokabeln filtern", isOn: $useFilter)
                    .onChange(of: useFilter, perform: { usefilter in
                        if !usefilter {
                            levelFilter = -1
                        } else {
                            levelFilter = learningViewModel.availableLevel.first ?? -2
                        }
                    })
                    .padding()
                if useFilter {
                    VStack {
                        HStack {
                            Text("Level")
                            Picker("LevelFilter", selection: $levelFilter) {
                                ForEach((availableLevels ?? learningViewModel.availableLevel), id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray4))
                            .cornerRadius(Guidelines.cornerRadius)
                            .padding(.horizontal, 10)
                        }
                    }
                }
                Button("Start") {
                    learningViewModel.learningMode = learningMode
                    learningViewModel.levelFilter = levelFilter
                    learningViewModel.updateVocables()
                    
                    if let firstVoc = learningViewModel.getNextVocable() {
                        self.firstVoc = firstVoc
                        learningSessionActive = true
                    } else {
                        presentAlert = true
                    }
                }
                .buttonStyle(CustomButton())
                .alert(isPresented: $presentAlert) {
                    Alert(title: Text("Oh.."), message: Text("Leider konnten keine passenden Vokabeln gefunden werden."), dismissButton: .default(Text("Nagut")) {
                        presentAlert = false
                    })
                }
                NavigationLink(
                    destination:  LearningViewController(learningViewModel: learningViewModel, currentVocable: firstVoc, sessionActive: $learningSessionActive),
                    isActive: $learningSessionActive,
                    label: {
                        EmptyView()
                    })
            }
            .onAppear {
                learningViewModel.updateVocables()
                availableLevels = learningViewModel.availableLevel
                if useFilter {
                    levelFilter = learningViewModel.availableLevel.first ?? -2
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .background(Color.green)
    }
}
